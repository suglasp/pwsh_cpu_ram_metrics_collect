
#
# Pieter De Ridder
# collect to csv file in a loop
#


#region Global vars
[int]$global:sec_counter = 0    # count hops have passed
[int]$global:sec_wait    = 1    # timeout in seconds (interval)
[int]$global:sec_hops    = 1    # counter limit
#endregion

#region notifications
Write-Host "notice: Run this script elevated for stats on service processes."
#endregion

#region Prompt for input

# request number of seconds
$global:sec_wait = Read-Host -Prompt "Enter number of seconds between interval (default is $($global:sec_wait) second(s))"

if ($global:sec_wait -le 0) {
    $global:sec_wait = 1  # min 1 second
}

if ($global:sec_wait -ge 3600) {
    $global:sec_wait = 3600  # max 1 hour in seconds
}

Write-Host " --> Set interval to $($global:sec_wait)."

# request number of hops
$global:sec_hops = Read-Host -Prompt "Enter number of hops (default is $($global:sec_hops) hop(s))"
Write-Host " --> Set hops to $($global:sec_hops)."
#endregion

#region main loop
[bool]$bKeepLooping = $true
while($bKeepLooping) {
    $global:sec_counter++

    if ($global:sec_counter -ge $global:sec_hops) {
        $bKeepLooping = $false
        break;
    }

     Write-Host "fire! [cycle: $($global:sec_counter), seconds passed: ($($global:sec_counter * $global:sec_wait))s]"
    .\cpu_mem_usage_collect.ps1
    
    Start-Sleep -Seconds $global:sec_wait
}
#endregion



#region Merge files to large CSV
.\cpu_mem_usage_merge.ps1
#endregion


#region Fix CSV file and filter
.\cpu_mem_usage_fix.ps1
#endregion
