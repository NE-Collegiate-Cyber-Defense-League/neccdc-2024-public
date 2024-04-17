[CmdletBinding()]
param (
    [String]$DisplayName,
    [String[]]$Identities
)

#region imports
#First import ActiveDirectory module to be able to create [Microsoft.ActiveDirectory.Management.ADPropertyValueCollection] type
Import-Module ActiveDirectory

# Install PSPKI module for managing Certification Authority
Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Module -Name PSPKI -Force -SkipPublisherCheck | Out-Null  #explicit version because of this issue https://github.com/PKISolutions/PSPKI/issues/113
Import-Module PSPKI
#endregion

#region initial functions

Function Get-RandomHex {
    param ([int]$Length)
    $Hex = '0123456789ABCDEF'
    [string]$Return = $null
    For ($i = 1; $i -le $length; $i++) {
        $Return += $Hex.Substring((Get-Random -Minimum 0 -Maximum 16), 1)
    }
    Return $Return
}

Function IsUniqueOID {
    param ($cn, $TemplateOID, $Server, $ConfigNC)
    $Search = Get-ADObject -Server $Server `
        -SearchBase "CN=OID,CN=Public Key Services,CN=Services,$ConfigNC" `
        -Filter { cn -eq $cn -and msPKI-Cert-Template-OID -eq $TemplateOID }
    If ($Search) { $False } Else { $True }
}

Function New-TemplateOID {
    Param($Server, $ConfigNC)
    <#
    OID CN/Name                    [10000000-99999999].[32 hex characters]
    OID msPKI-Cert-Template-OID    [Forest base OID].[1000000-99999999].[10000000-99999999]  <--- second number same as first number in OID name
    #>
    do {
        $OID_Part_1 = Get-Random -Minimum 1000000  -Maximum 99999999
        $OID_Part_2 = Get-Random -Minimum 10000000 -Maximum 99999999
        $OID_Part_3 = Get-RandomHex -Length 32
        $OID_Forest = Get-ADObject -Server $Server `
            -Identity "CN=OID,CN=Public Key Services,CN=Services,$ConfigNC" `
            -Properties msPKI-Cert-Template-OID |
        Select-Object -ExpandProperty msPKI-Cert-Template-OID
        $msPKICertTemplateOID = "$OID_Forest.$OID_Part_1.$OID_Part_2"
        $Name = "$OID_Part_2.$OID_Part_3"
    } until (IsUniqueOID -cn $Name -TemplateOID $msPKICertTemplateOID -Server $Server -ConfigNC $ConfigNC)
    Return @{
        TemplateOID  = $msPKICertTemplateOID
        TemplateName = $Name
    }
}

Function New-Template {
    Param($DisplayName, $TemplateOtherAttributes)

    #grab DC
    $Server = (Get-ADDomainController -Discover -ForceDiscover -Writable).HostName[0]
    #grab Naming Context
    $ConfigNC = (Get-ADRootDSE -Server $Server).configurationNamingContext
    #Create OID
    $OID = New-TemplateOID -Server $Server -ConfigNC $ConfigNC
    $TemplateOIDPath = "CN=OID,CN=Public Key Services,CN=Services,$ConfigNC"
    $OIDOtherAttributes = @{
        'DisplayName'             = $DisplayName
        'flags'                   = [System.Int32]'1'
        'msPKI-Cert-Template-OID' = $OID.TemplateOID
    }
    New-ADObject -Path $TemplateOIDPath -OtherAttributes $OIDOtherAttributes -Name $OID.TemplateName -Type 'msPKI-Enterprise-Oid' -Server $Server
    #Create Template itself
    $TemplateOtherAttributes += @{
        'msPKI-Cert-Template-OID' = $OID.TemplateOID
    }
    $TemplatePath = "CN=Certificate Templates,CN=Public Key Services,CN=Services,$ConfigNC"
    New-ADObject -Path $TemplatePath -OtherAttributes $TemplateOtherAttributes -Name $DisplayName -DisplayName $DisplayName -Type pKICertificateTemplate -Server $Server
}
#endregion

#region Create Templates
#Create Autoenrollment Template for ADCS
$TemplateOtherAttributes = @{
    'flags'                                = [System.Int32]'131680'
    'msPKI-Certificate-Application-Policy' = [Microsoft.ActiveDirectory.Management.ADPropertyValueCollection]@('1.3.6.1.5.5.7.3.2', '1.3.6.1.5.5.7.3.1')
    'msPKI-Certificate-Name-Flag'          = [System.Int32]'1207959552'
    'msPKI-Enrollment-Flag'                = [System.Int32]'32'
    'msPKI-Minimal-Key-Size'               = [System.Int32]'2048'
    'msPKI-Private-Key-Flag'               = [System.Int32]'101056640'
    'msPKI-RA-Application-Policies'        = [Microsoft.ActiveDirectory.Management.ADPropertyValueCollection]@('msPKI-Asymmetric-Algorithm`PZPWSTR`RSA`msPKI-Hash-Algorithm`PZPWSTR`SHA512`msPKI-Key-Usage`DWORD`16777215`msPKI-Symmetric-Algorithm`PZPWSTR`3DES`msPKI-Symmetric-Key-Length`DWORD`168`')
    'msPKI-RA-Signature'                   = [System.Int32]'0'
    'msPKI-Template-Minor-Revision'        = [System.Int32]'1'
    'msPKI-Template-Schema-Version'        = [System.Int32]'4'
    'pKIMaxIssuingDepth'                   = [System.Int32]'0'
    'ObjectClass'                          = [System.String]'pKICertificateTemplate'
    'pKICriticalExtensions'                = [Microsoft.ActiveDirectory.Management.ADPropertyValueCollection]@('2.5.29.15')
    'pKIDefaultCSPs'                       = [Microsoft.ActiveDirectory.Management.ADPropertyValueCollection]@('1,Microsoft Software Key Storage Provider', '2,Microsoft Platform Crypto Provider')
    'pKIDefaultKeySpec'                    = [System.Int32]'1'
    'pKIExpirationPeriod'                  = [System.Byte[]]@('0', '64', '57', '135', '46', '225', '254', '255')
    'pKIExtendedKeyUsage'                  = [Microsoft.ActiveDirectory.Management.ADPropertyValueCollection]@('1.3.6.1.5.5.7.3.1', '1.3.6.1.5.5.7.3.2')
    'pKIKeyUsage'                          = [System.Byte[]]@('136')
    'pKIOverlapPeriod'                     = [System.Byte[]]@('0', '128', '166', '10', '255', '222', '255', '255')
    'revision'                             = [System.Int32]'100'
}
#endregion

#region Publish Templates
try {
    # Create the template
    New-Template -DisplayName $DisplayName -TemplateOtherAttributes $TemplateOtherAttributes
} catch {
    if ($_.Exception.Message -match "already in use") {
        Write-Output "[+] [$env:COMPUTERNAME] Certificate Template $DisplayName already exists."
    } else {
        throw "[+] An error occurred: $_"
    }
}

try {
    #grab DC
    $Server = (Get-ADDomainController -Discover -ForceDiscover -Writable).HostName[0]
    #grab Naming Context
    $ConfigNC = (Get-ADRootDSE -Server $Server).configurationNamingContext
    
    ### WARNING: Issues on all available CAs. Test in your environment.
    $EnrollmentPath = "CN=Enrollment Services,CN=Public Key Services,CN=Services,$ConfigNC"
    $CAs = Get-ADObject -SearchBase $EnrollmentPath -SearchScope OneLevel -Filter * -Server $Server
    ForEach ($CA in $CAs) {
        Set-ADObject -Identity $CA.DistinguishedName -Add @{certificateTemplates = $DisplayName } -Server $Server
        Write-Output "[+] [$env:COMPUTERNAME] Adding Certificate Template $DisplayName to CA $($CA.Name)"
    }
} catch {
    throw "[+] An error occurred: $_"
}

try {
    #Set permissions on Templates so all computers can autoenroll it
    $Identities | ForEach-Object {
        Write-Output "[+] [$env:COMPUTERNAME] Setting permissions for $_ on Certificate Template $DisplayName"

        Get-CertificateTemplate -Name $DisplayName | Get-CertificateTemplateAcl | Add-CertificateTemplateAcl -Identity $_ -AccessType Allow -AccessMask Read, Enroll, AutoEnroll | Set-CertificateTemplateAcl | Out-Null
    }
} catch {
    throw "[+] An error occurred: $_"
}
#endregion
