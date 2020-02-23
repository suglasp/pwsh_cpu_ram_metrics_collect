
#
# Pieter De Ridder
# collect cpu usage of all processes
# write to CSV file
#



#region date and time
$TimeStamp = Get-Date
$TimeDate = $TimeStamp.ToString("dd-MM-yyyy")
$TimeNow = $TimeStamp.ToString("HH:mm:ss")
#endregion

#region format a cpupercent column
$CPUPercent = @{
  Name = 'CPUPercent'
  Expression = {
    $TotalSec = (New-TimeSpan -Start $_.StartTime).TotalSeconds
    [Math]::Round( ($_.CPU * 100 / $TotalSec), 2)
  }
}
#endregion

#region 1st stage : fetch processes and data
$Process = Get-Process | Select -Property Name, CPU, $CPUPercent, WorkingSet, WorkingSet64, Description | Sort-Object -Property Name -Descending
#endregion


#region 2nd stage : format and export to CSV
$Process_Format = @()

foreach($proc in $Process) {
    $pDetails = New-Object PSObject -Property @{
    "TimeStamp" = $TimeDate
    "TimeNow" = $TimeNow
    "Name" = $proc.Name
    "CPU" =$proc.CPU
    "CPUPercent"= $proc.CPUPercent
    "WorkingSet" = $proc.WorkingSet
    "WorkingSet64" = $proc.WorkingSet64
    "Description" = $proc.Description
    }
  
  
    #if ($pDetails.CPU -ne $null) {
        #$Process_Format += $pDetails
 
        #$pDetails | Select -Property * | Out-File -FilePath "c:\temp\cpu_usage.csv" -Append -NoClobber -Encoding utf8
          
        [string]$out = "$($pDetails.TimeStamp);$($pDetails.TimeNow);$($pDetails.Name);$($pDetails.CPU);$($pDetails.CPUPercent);$($pDetails.WorkingSet);$($pDetails.WorkingSet64);$($pDetails.Description)"
        $Process_Format += $out
    #}
}

#$Process_Format | Select -Property TimeStamp, TimeNow, Name, CPU, CPUPercent, Description | Export-Csv -Path "c:\temp\cpu_usage.csv" -Delimiter ';' -Encoding utf8 -Append
$Process_Format | Out-File -FilePath ".\cpu_usage_$($TimeStamp.ToString("ddMMyyyy_HHmmss")).csv" -Append -Encoding utf8
#endregion
