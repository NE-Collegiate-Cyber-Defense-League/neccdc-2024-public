[CmdletBinding()]
param ()
try {
    Install-AdcsWebEnrollment -Force
    $Ansible.Changed = $true
} catch {
    $Ansible.Changed = $false
}