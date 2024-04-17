Function New-LegacySelfSignedCert {
    Param (
        [string]$SubjectName,
        [int]$ValidDays = 1095
    )

    $hostnonFQDN = $env:computerName
    $hostFQDN = [System.Net.Dns]::GetHostByName(($env:computerName)).Hostname
    $SignatureAlgorithm = "SHA256"

    $name = New-Object -COM "X509Enrollment.CX500DistinguishedName.1"
    $name.Encode("CN=$SubjectName", 0)

    $key = New-Object -COM "X509Enrollment.CX509PrivateKey.1"
    $key.ProviderName = "Microsoft Enhanced RSA and AES Cryptographic Provider"
    $key.KeySpec = 1
    $key.Length = 4096
    $key.SecurityDescriptor = "D:PAI(A;;0xd01f01ff;;;SY)(A;;0xd01f01ff;;;BA)(A;;0x80120089;;;NS)"
    $key.MachineContext = 1
    $key.Create()

    $serverauthoid = New-Object -COM "X509Enrollment.CObjectId.1"
    $serverauthoid.InitializeFromValue("1.3.6.1.5.5.7.3.1")
    $ekuoids = New-Object -COM "X509Enrollment.CObjectIds.1"
    $ekuoids.Add($serverauthoid)
    $ekuext = New-Object -COM "X509Enrollment.CX509ExtensionEnhancedKeyUsage.1"
    $ekuext.InitializeEncode($ekuoids)

    $cert = New-Object -COM "X509Enrollment.CX509CertificateRequestCertificate.1"
    $cert.InitializeFromPrivateKey(2, $key, "")
    $cert.Subject = $name
    $cert.Issuer = $cert.Subject
    $cert.NotBefore = (Get-Date).AddDays(-1)
    $cert.NotAfter = $cert.NotBefore.AddDays($ValidDays)

    $SigOID = New-Object -ComObject X509Enrollment.CObjectId
    $SigOID.InitializeFromValue(([Security.Cryptography.Oid]$SignatureAlgorithm).Value)

    [string[]] $AlternativeName += $hostnonFQDN
    $AlternativeName += $hostFQDN
    $IAlternativeNames = New-Object -ComObject X509Enrollment.CAlternativeNames

    foreach ($AN in $AlternativeName) {
        $AltName = New-Object -ComObject X509Enrollment.CAlternativeName
        $AltName.InitializeFromString(0x3, $AN)
        $IAlternativeNames.Add($AltName)
    }

    $SubjectAlternativeName = New-Object -ComObject X509Enrollment.CX509ExtensionAlternativeNames
    $SubjectAlternativeName.InitializeEncode($IAlternativeNames)

    [String[]]$KeyUsage = ("DigitalSignature", "KeyEncipherment")
    $KeyUsageObj = New-Object -ComObject X509Enrollment.CX509ExtensionKeyUsage
    $KeyUsageObj.InitializeEncode([int][Security.Cryptography.X509Certificates.X509KeyUsageFlags]($KeyUsage))
    $KeyUsageObj.Critical = $true

    $cert.X509Extensions.Add($KeyUsageObj)
    $cert.X509Extensions.Add($ekuext)
    $cert.SignatureInformation.HashAlgorithm = $SigOID
    $CERT.X509Extensions.Add($SubjectAlternativeName)
    $cert.Encode()

    $enrollment = New-Object -COM "X509Enrollment.CX509Enrollment.1"
    $enrollment.InitializeFromRequest($cert)
    $certdata = $enrollment.CreateRequest(0)
    $enrollment.InstallResponse(2, $certdata, 0, "")

    # extract/return the thumbprint from the generated cert
    $parsed_cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
    $parsed_cert.Import([System.Text.Encoding]::UTF8.GetBytes($certdata))

    return $parsed_cert.Thumbprint
}

Function Enable-GlobalHttpFirewallAccess {
    Write-Output "Forcing global HTTP firewall access"
    # this is a fairly naive implementation; could be more sophisticated about rule matching/collapsing
    $fw = New-Object -ComObject HNetCfg.FWPolicy2

    # try to find/enable the default rule first
    $add_rule = $false
    $matching_rules = $fw.Rules | Where-Object { $_.Name -eq "Windows Remote Management (HTTP-In)" }
    $rule = $null
    If ($matching_rules) {
        If ($matching_rules -isnot [Array]) {
            Write-Output "Editing existing single HTTP firewall rule"
            $rule = $matching_rules
        } Else {
            # try to find one with the All or Public profile first
            Write-Output "Found multiple existing HTTP firewall rules..."
            $rule = $matching_rules | ForEach-Object { $_.Profiles -band 4 }[0]

            If (-not $rule -or $rule -is [Array]) {
                Write-Output "Editing an arbitrary single HTTP firewall rule (multiple existed)"
                # oh well, just pick the first one
                $rule = $matching_rules[0]
            }
        }
    }

    If (-not $rule) {
        Write-Output "Creating a new HTTP firewall rule"
        $rule = New-Object -ComObject HNetCfg.FWRule
        $rule.Name = "Windows Remote Management (HTTP-In)"
        $rule.Description = "Inbound rule for Windows Remote Management via WS-Management. [TCP 5985]"
        $add_rule = $true
    }

    $rule.Profiles = 0x7FFFFFFF
    $rule.Protocol = 6
    $rule.LocalPorts = 5985
    $rule.RemotePorts = "*"
    $rule.LocalAddresses = "*"
    $rule.RemoteAddresses = "*"
    $rule.Enabled = $true
    $rule.Direction = 1
    $rule.Action = 1
    $rule.Grouping = "Windows Remote Management"

    If ($add_rule) {
        $fw.Rules.Add($rule)
    }

    Write-Output "HTTP firewall rule $($rule.Name) updated"
}

# Setup error handling.
Trap {
    $_
    Exit 1
}
$ErrorActionPreference = "Stop"

$SubjectName = $env:COMPUTERNAME
$CertValidityDays = 1095
$SkipNetworkProfileCheck = $true
$ForceNewSSLCert = $false
$GlobalHttpFirewallAccess = $true
$DisableBasicAuth = $false
$EnableCredSSP = $true

# Get the ID and security principal of the current user account
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal = new-object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the Administrator role
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running "as Administrator"
if (-Not $myWindowsPrincipal.IsInRole($adminRole)) {
    Write-Output "ERROR: You need elevated Administrator privileges in order to run this script."
    Write-Output "       Start Windows PowerShell by using the Run as Administrator option."
    Exit 2
}

$EventSource = $MyInvocation.MyCommand.Name
If (-Not $EventSource) {
    $EventSource = "Powershell CLI"
}

If ([System.Diagnostics.EventLog]::Exists('Application') -eq $False -or [System.Diagnostics.EventLog]::SourceExists($EventSource) -eq $False) {
    New-EventLog -LogName Application -Source $EventSource
}

# Detect PowerShell version.
If ($PSVersionTable.PSVersion.Major -lt 3) {
    Throw "PowerShell version 3 or higher is required."
}

# Find and start the WinRM service.
Write-Output "Verifying WinRM service."
If (!(Get-Service "WinRM")) {
    Throw "Unable to find the WinRM service."
} ElseIf ((Get-Service "WinRM").Status -ne "Running") {
    Write-Output "Setting WinRM service to start automatically on boot."
    Set-Service -Name "WinRM" -StartupType Automatic
    Write-Output "Starting WinRM service."
    Start-Service -Name "WinRM" -ErrorAction Stop
}

# WinRM should be running; check that we have a PS session config.
If (!(Get-PSSessionConfiguration -Verbose:$false) -or (!(Get-ChildItem WSMan:\localhost\Listener))) {
    If ($SkipNetworkProfileCheck) {
        Write-Output "Enabling PS Remoting without checking Network profile."
        Enable-PSRemoting -SkipNetworkProfileCheck -Force -ErrorAction Stop
    } Else {
        Write-Output "Enabling PS Remoting."
        Enable-PSRemoting -Force -ErrorAction Stop
    }
} Else {
    Write-Output "PS Remoting is already enabled."
}

# Ensure LocalAccountTokenFilterPolicy is set to 1
# https://github.com/ansible/ansible/issues/42978
$token_path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$token_prop_name = "LocalAccountTokenFilterPolicy"
$token_key = Get-Item -Path $token_path
$token_value = $token_key.GetValue($token_prop_name, $null)
if ($token_value -ne 1) {
    Write-Output "Setting LocalAccountTOkenFilterPolicy to 1"
    if ($null -ne $token_value) {
        Remove-ItemProperty -Path $token_path -Name $token_prop_name
    }
    New-ItemProperty -Path $token_path -Name $token_prop_name -Value 1 -PropertyType DWORD > $null
}

# Make sure there is a SSL listener.
$listeners = Get-ChildItem WSMan:\localhost\Listener
If (!($listeners | Where-Object { $_.Keys -like "TRANSPORT=HTTPS" })) {
    # We cannot use New-SelfSignedCertificate on 2012R2 and earlier
    $thumbprint = New-LegacySelfSignedCert -SubjectName $SubjectName -ValidDays $CertValidityDays
    Write-Output "Self-signed SSL certificate generated; thumbprint: $thumbprint"

    # Create the hashtables of settings to be used.
    $valueset = @{
        Hostname              = $SubjectName
        CertificateThumbprint = $thumbprint
    }

    $selectorset = @{
        Transport = "HTTPS"
        Address   = "*"
    }

    Write-Output "Enabling SSL listener."
    New-WSManInstance -ResourceURI 'winrm/config/Listener' -SelectorSet $selectorset -ValueSet $valueset
} Else {
    Write-Output "SSL listener is already active."

    # Force a new SSL cert on Listener if the $ForceNewSSLCert
    If ($ForceNewSSLCert) {

        # We cannot use New-SelfSignedCertificate on 2012R2 and earlier
        $thumbprint = New-LegacySelfSignedCert -SubjectName $SubjectName -ValidDays $CertValidityDays
        Write-Output "Self-signed SSL certificate generated; thumbprint: $thumbprint"

        $valueset = @{
            CertificateThumbprint = $thumbprint
            Hostname              = $SubjectName
        }

        # Delete the listener for SSL
        $selectorset = @{
            Address   = "*"
            Transport = "HTTPS"
        }
        Remove-WSManInstance -ResourceURI 'winrm/config/Listener' -SelectorSet $selectorset

        # Add new Listener with new SSL cert
        New-WSManInstance -ResourceURI 'winrm/config/Listener' -SelectorSet $selectorset -ValueSet $valueset
    }
}

# Check for basic authentication.
$basicAuthSetting = Get-ChildItem WSMan:\localhost\Service\Auth | Where-Object { $_.Name -eq "Basic" }

If ($DisableBasicAuth) {
    If (($basicAuthSetting.Value) -eq $true) {
        Write-Output "Disabling basic auth support."
        Set-Item -Path "WSMan:\localhost\Service\Auth\Basic" -Value $false
    } Else {
        Write-Output "Basic auth is already disabled."
    }
} Else {
    If (($basicAuthSetting.Value) -eq $false) {
        Write-Output "Enabling basic auth support."
        Set-Item -Path "WSMan:\localhost\Service\Auth\Basic" -Value $true
    } Else {
        Write-Output "Basic auth is already enabled."
    }
}

# If EnableCredSSP if set to true
If ($EnableCredSSP) {
    # Check for CredSSP authentication
    $credsspAuthSetting = Get-ChildItem WSMan:\localhost\Service\Auth | Where-Object { $_.Name -eq "CredSSP" }
    If (($credsspAuthSetting.Value) -eq $false) {
        Write-Output "Enabling CredSSP auth support."
        Enable-WSManCredSSP -role server -Force
    }
}

If ($GlobalHttpFirewallAccess) {
    Enable-GlobalHttpFirewallAccess
}

# Configure firewall to allow WinRM HTTPS connections.
$fwtest1 = netsh advfirewall firewall show rule name="Allow WinRM HTTPS"
$fwtest2 = netsh advfirewall firewall show rule name="Allow WinRM HTTPS" profile=any
If ($fwtest1.count -lt 5) {
    Write-Output "Adding firewall rule to allow WinRM HTTPS."
    netsh advfirewall firewall add rule profile=any name="Allow WinRM HTTPS" dir=in localport=5986 protocol=TCP action=allow
} ElseIf (($fwtest1.count -ge 5) -and ($fwtest2.count -lt 5)) {
    Write-Output "Updating firewall rule to allow WinRM HTTPS for any profile."
    netsh advfirewall firewall set rule name="Allow WinRM HTTPS" new profile=any
} Else {
    Write-Output "Firewall rule already exists to allow WinRM HTTPS."
}

# Test a remoting connection to localhost, which should work.
$httpResult = Invoke-Command -ComputerName "localhost" -ScriptBlock { $env:COMPUTERNAME } -ErrorVariable httpError -ErrorAction SilentlyContinue
$httpsOptions = New-PSSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck

$httpsResult = New-PSSession -UseSSL -ComputerName "localhost" -SessionOption $httpsOptions -ErrorVariable httpsError -ErrorAction SilentlyContinue

If ($httpResult -and $httpsResult) {
    Write-Output "HTTP: Enabled | HTTPS: Enabled"
} ElseIf ($httpsResult -and !$httpResult) {
    Write-Output "HTTP: Disabled | HTTPS: Enabled"
} ElseIf ($httpResult -and !$httpsResult) {
    Write-Output "HTTP: Enabled | HTTPS: Disabled"
} Else {
    Throw "Unable to establish an HTTP or HTTPS remoting session."
}
Write-Output "PS Remoting has been successfully configured for Ansible."