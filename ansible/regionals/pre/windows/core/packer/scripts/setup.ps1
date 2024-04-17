function Enable-ICMP {
    param (
        [bool]$Enable = $true
    )

    $fw = New-Object -ComObject HNetCfg.FwPolicy2
    $icmpRules = $fw.Rules | Where-Object { $_.Name -like "File and Printer Sharing (Echo*" }

    foreach ($rule in $icmpRules) {
        $rule.Enabled = $Enable
    }
}

Enable-ICMP -Enable $true
