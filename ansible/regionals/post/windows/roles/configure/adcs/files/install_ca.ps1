[CmdletBinding()]
param (
    [String]
    $cert_file_password
)

$caParams = @{
    CAType            = "EnterpriseRootCA"
    CertFile          = "C:\ProgramData\RustEnergyRootCA.p12"
    CertFilePassword  = ($cert_file_password | ConvertTo-SecureString -AsPlainText -Force)
    DatabaseDirectory = "C:\windows\system32\certLog"
    LogDirectory      = "C:\windows\system32\certLog"
    Force             = $true
}

try {
    Install-ADcsCertificationAuthority @caParams
    $Ansible.Changed = $true
} catch {
    if ($_.Exception.Message -match "The Certification Authority is already installed.") {
        $Ansible.Changed = $false
    } else {
        $Ansible.Changed = $false
        throw $_
    }
}