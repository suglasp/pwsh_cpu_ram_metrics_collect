
#
# Pieter De Ridder
# merge all output files to one big nice CSV file
#

$TimeStamp = Get-Date
$combinedFilenameOut = ".\cpu_usage_merged_$($TimeStamp.ToString("ddMMyyyy")).csv"

# create large output file
Write-Host "-- Create to merge output file"
New-Item -ItemType file ".\$($combinedFilenameOut)" –Force

# read in sub files for input
Write-Host "-- Processing stubs"
$inputFiles = Get-ChildItem -File -Filter "cpu_usage_$($TimeStamp.ToString("ddMMyyyy"))_*"

# merge files
Write-Host "-- Merging stubs"
$inputFiles | % { Write-Host "Merging $_ ..."; Get-Content $_.Name | Add-Content ".\$($combinedFilenameOut)" }

# cleanup files
Write-host "-- Cleaning stubs"
$inputFiles | % { Remove-Item $_ -Force -Confirm:$false }
