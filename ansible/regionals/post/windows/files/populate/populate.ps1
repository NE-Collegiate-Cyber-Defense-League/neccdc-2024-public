[CmdletBinding()]
param (
    [Switch]
    $CreateOUs,
    [Switch]
    $CreateUsers,
    [Switch]
    $CreateGroups,
    [Switch]
    $CreateGPOs
)

$Data = Import-Csv -Path "C:\users.csv"
$Domain = Get-ADDomain | Select-Object -ExpandProperty DNSRoot
$DomainDN = Get-ADDomain | Select-Object -ExpandProperty DistinguishedName
$RootOUName = "RUST"
$ComputersOUName = "Computers"
$GroupsOUName = "Groups"
$ServersOUName = "Servers"
$WorkstationsOUName = "Workstations"
$UsersOUName = "Users"

$RootOUPath = "OU=$RootOUName,$DomainDN"
$UsersOUPath = "OU=$UsersOUName,$RootOUPath"
$ComputersOUPath = "OU=$ComputersOUName,$RootOUPath"
$GroupsOUPath = "OU=$GroupsOUName,$RootOUPath"
$WorkstationsOUPath = "OU=$WorkstationsOUName,$ComputersOUPath"
$ServersOUPath = "OU=$ServersOUName,$ComputersOUPath"

# Set default password policy prior to creating Users
try {
    $defaultPasswordPolicyParams = @{
        Identity                    = $Domain
        ComplexityEnabled           = $false
        ReversibleEncryptionEnabled = $true
        MinPasswordLength           = 0
    }

    Set-ADDefaultDomainPasswordPolicy @defaultPasswordPolicyParams
} catch {
    <#Do this if a terminating exception happens#>
}

if ($CreateOUs) {
    Write-Output "[+] Creating root OUs in $Domain"
    $commands = @(
        { New-ADOrganizationalUnit -Name $RootOUName -Path $DomainDN },
        { New-ADOrganizationalUnit -Name $UsersOUName -Path $RootOUPath },
        { New-ADOrganizationalUnit -Name $ComputersOUName -Path $RootOUPath },
        { New-ADOrganizationalUnit -Name $GroupsOUName -Path $RootOUPath },
        { New-ADOrganizationalUnit -Name $ServersOUName -Path $ComputersOUPath },
        { New-ADOrganizationalUnit -Name $WorkstationsOUName -Path $ComputersOUPath }
    )
    
    # Iterate over each command and execute it within a try-catch block
    foreach ($command in $commands) {
        try {
            & $command
        } catch {
            if (($_.Exception.Message -match "already exists") -or
                ($_.Exception.Message -match "name that is already in use")) {
                Write-Output "[+] OU already exists"
                break
            } else {
                throw "[+] An error occurred: $_"
            }
        }
    }
    
} else {
    Write-Output "[+] Skipping OU creation"
}

if ($CreateUsers) {
    Write-Output "[+] Creating bulk users in $Domain"
    foreach ($_ in $Data) {
        try {           
            $splat = @{
                AccountPassword   = $(ConvertTo-SecureString -String $_.Password -AsPlainText -Force)
                Company           = "Rust Energy"
                Department        = $_.Department
                Name              = "$($_.GivenName) $($_.Surname)"
                DisplayName       = "$($_.GivenName) $($_.Surname)"
                GivenName         = $_.GivenName
                Surname           = $_.Surname
                SamAccountName    = $_.Username
                UserPrincipalName = "$($_.Username)@$Domain"
                Title             = $_.JobTitle
                Path              = $UsersOUPath
                Enabled           = $true
            }
            New-ADUser @splat
        } catch {
            if ($_.Exception.Message -match "already exists") {
                Write-Output "[+] Users already exists"
                break
            } else {
                throw "[+] An error occurred: $_"
            }
        }
    }
} else {
    Write-Output "[+] Skipping user creation"
}

if ($CreateGroups) {
    $ServerAdmins = @{
        Name    = "Server Admins"
        Members = "Enterprise Admins", "Domain Admins", "Schema Admins"
    }

    $DesktopAdmins = @{
        Name    = "Desktop Admins"
        Members = "Group Policy Creator Owners", "Key Admins", "Cert Publishers", "DnsAdmins"
    }

    $NonDepartmentalGroups = @($ServerAdmins, $DesktopAdmins)
    foreach ($_ in $NonDepartmentalGroups) {
        try {
            New-ADGroup -Name $_.Name -GroupCategory Security -GroupScope DomainLocal -Description "RUST ENERGY" -Path $GroupsOUPath
        } catch {
            if ($_.Exception.Message -match "already exists") {
                Write-Output "[+] Groups already exists"
                break
            } else {
                throw "[+] An error occurred: $_"
            }
        } finally {
            Add-ADGroupMember -Identity $_.Name -Members $_.Members
        }
    }

    Write-Output "[+] Creating bulk groups in $Domain"
    $Groups = $Data | Select-Object -ExpandProperty Department | Sort-Object -Unique
    foreach ($_ in $Groups) {
        try {
            New-ADGroup -Name $_ -GroupCategory Security -GroupScope Global -Description "RUST ENERGY" -Path $GroupsOUPath
        } catch {
            if ($_.Exception.Message -match "already exists") {
                Write-Output "[+] Groups already exists"
                break
            } else {
                throw "[+] An error occurred: $_"
            }
        } finally {
            # Add all users to the group
            $Users = Get-ADUser -Filter { Department -eq $_ }
            Add-ADGroupMember -Identity $_ -Members $Users
        }
    }

    Write-Output "[+] Adding IT employees to respective admin groups"
    $ITEmployees = Get-ADUser -Filter { (Department -eq "IT") -or (Title -eq "CIO") } -Properties Department, Title
    try {
        Add-ADGroupMember -Identity "Enterprise Admins" -Members $($ITEmployees | Where-Object { $_.Title -match "CIO|Manager" })
        Add-ADGroupMember -Identity "Domain Admins" -Members $($ITEmployees | Where-Object { $_.Title -match "CIO|Manager|Specialist" })
        Add-ADGroupMember -Identity "Group Policy Creator Owners" -Members $($ITEmployees | Where-Object { $_.Title -match "CIO|Manager|Specialist|Assistant" })
        Add-ADGroupMember -Identity "Schema Admins" -Members $($ITEmployees | Where-Object { $_.Title -match "CIO|Manager|Specialist|Assistant" })
        Add-ADGroupMember -Identity "DnsAdmins" -Members $($ITEmployees | Where-Object { $_.Title -match "CIO|Manager|Specialist|Assistant|Advisor" })
        Add-ADGroupMember -Identity "Key Admins" -Members $($ITEmployees | Where-Object { $_.Title -match "CIO|Manager|Specialist|Assistant|Advisor" })
        Add-ADGroupMember -Identity "Cert Publishers" -Members $($ITEmployees | Where-Object { $_.Title -match "CIO|Manager|Specialist|Assistant|Advisor" })    
    } catch {
        throw "[+] An error occurred: $_"
    }
} else {
    Write-Output "[+] Skipping group creation"
}

Write-Output "[+] Adding 20 random users to Desktop Admin group"
try {
    $max = (Get-Content "C:\users.csv").count

    for ($i = 0; $i -lt 20; $i++) {
        $num = (Get-Random -Minimum 1 -Maximum $max) - 1
        $user = (Get-Content "C:\users.csv" | Select-Object -Index $num)

        if ($user.split(',')[4] -notin "IT, Services") {
            Add-ADGroupMember -Identity "Desktop Admins" -Members $user.split(',')[2]
        }
    }
} catch {
    throw "[+] An error occurred: $_"
} else {
    Write-Output "[+] Skipping user add"
}

if ($CreateGPOs) {
    Write-Output "[+] Creating and linking GPOs in $Domain"

    $GPOPath = "C:\temp\gpo"
    foreach ($gpo in Get-ChildItem -Path $GPOPath) { 
        
        $BackupFilePath = $gpo.FullName + "\bkupInfo.xml"
        if (-not (Test-Path $BackupFilePath)) {
            Write-Output "[+] Backup file not found in $($gpo.FullName)"
            continue
        }

        $GPOxml = [xml](Get-Content -Path $BackupFilePath)
        $GPOName = $GPOxml.BackupInst.GPODisplayName."#cdata-section"
        $GPOId = $GPOxml.BackupInst.ID."#cdata-section" -replace '{|}'

        try {
            Import-GPO -BackupId $GPOId -TargetName $GPOName -path $GPOPath -CreateIfNeeded | Out-Null
            
            Write-Output "[+] Imported: $GPOName successfully"
            
            switch -Wildcard ($GPOName) {
                "Global*" { New-GPLink -Name $GPOName -Target $DomainDN -LinkEnabled Yes | Out-Null }
                "Computers*" { New-GPLink -Name $GPOName -Target $ComputersOUPath -LinkEnabled Yes | Out-Null }
                "Workstations*" { New-GPLink -Name $GPOName -Target $WorkstationsOUPath -LinkEnabled Yes | Out-Null }
                "Servers*" { New-GPLink -Name $GPOName -Target $ServersOUPath -LinkEnabled Yes | Out-Null }
                default { New-GPLink -Name $GPOName -Target $DomainDN -LinkEnabled Yes | Out-Null }
            }
        } catch {
            throw "[+] An error occurred: $_"
        }
    }    
}