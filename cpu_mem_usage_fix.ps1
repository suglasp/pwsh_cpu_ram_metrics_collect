
#
# Pieter De Ridder
#
# fixes a CSV file
# - replaces for decimal values the '.' notation to ','
# - filter only processes we want (using cpu_mem_processes.cfg)
#

$TimeStamp          = Get-Date
[string]$inputFile  = ".\cpu_usage_merged_$($TimeStamp.ToString("ddMMyyyy")).csv"
[string]$outputFile = $inputFile.Substring(0, $inputFile.Length -4) + "_v2.csv"
[string]$exProcFile = ".\cpu_mem_processes.cfg"
$exclusiveProcesses = @()

# read processes to filter
if (Test-Path $exProcFile) {
    $exclusiveProcesses = Get-Content -Path $exProcFile
}

# clean file in case we run a new cycle
if (Test-Path $outputFile) {
    Remove-Item $outputFile -Force
}

# fix original file and build new file
if (Test-Path $inputFile) {
    # create new output file
    Write-Host "-- Create to new output file"
    New-Item -ItemType file $outputFile –Force

    # fix file
    Write-Host "-- Fixing file"
    $arrInFileLines = Get-Content -Path $inputFile

    # replace '.' to ',' on decimals
    Write-Host ""
    Write-Host "Processing items..."

    $arrOutFileLines = @()
    $arrOutFileLines += ";;;;;;;" # add a empty header line to file (for Excel -> filter function on columns)
        
    foreach($line in $arrInFileLines) {
        # first, check if we want this line
        # filter on process name
        [bool]$bWantLine = $false
           
        foreach($processname in $exclusiveProcesses) {
            if ($line.Contains($processname)) {
                $bWantLine = $true
            }
        }

        # if we want it, process it for '.' to ',' and add to new list
        if ($bWantLine) {
            # read CSV line by line
            $arrSplitLine = $line.Split(";")
       
            # fix decimal values from '.' to ','      
            for($i = 0; $i -le ($arrSplitLine.Length -1); $i++) {


                if ($arrSplitLine[$i] -like "*.*") {
                    #$arrSplitLine[$i] -replace ".", ","                
                    $arrSplitLine[$i] = $arrSplitLine[$i].Replace('.', ',')
                }
            }

            # rebuild and add new lines to new array
            $newline = [string]::Empty
            for($i = 0; $i -le ($arrSplitLine.Length -1); $i++) {
                $newline += $arrSplitLine[$i]

                if ($i -le ($arrSplitLine.Length -2)) {
                    $newline += ";"
                }
            }
        
            $arrOutFileLines += $newline

        }
    }


    # write new file
    Write-Host ""
    Write-Host "Writing new file..."
    foreach($newline in $arrOutFileLines) {
         $newline | Out-File -FilePath $outputFile -Append -Encoding utf8
    }

} else {
    Write-Host "File $($inputFile) not found!"
}

Write-Host "-- done"

