Pieter De Ridder a.k.a. Suglasp
Written this suite of PS scripts to collect system metrics in a csv format.

>> Suite Files:
- cpu_mem_processes.cfg          : fill in process names, these will be filtered for metric collection.
- cpu_mem_usage_collect_loop.ps1 : core script. Start this to collect metrics.
- cpu_mem_usage_collect.ps1      : behind the scenes script.
- cpu_mem_usage_fix.ps1          : this script does to filtering and also for EU region, replaces decimal '.' to ',' values.
- cpu_mem_usage_merge.ps1        : this merges all collected files to one nice big csv file.

>> How to:
Start Powershell.
Run 'cpu_mem_usage_collect_loop.ps1'.
The script will asks the interval in seconds and how many samples to take. (default is 1 sec per sample).

After that, loop start the script cpu_mem_usage_collect.ps1 in a loop.
Each run of cpu_mem_usage_collect.ps1 creates a csv file with results of each process with mem and cpu status.
These files of each collection are several intermediate csv files (stubs).

When the loop finishes, it starts the merge script 'cpu_mem_usage_merge.ps1'. This merges all stub csv files into one nice big csv file.
Finally, the loop calls a fix script 'cpu_mem_usage_fix.ps1' that filters only the processes we want listed in file 'cpu_mem_processes.cfg'.

>> final output columns of csv:
<data>;<time>;<procname>;<cpu>;<cpu_procent>;<workset>;<workset64>;<description>


>> Notes:
If you would early abort (CTRL+C) the "cpu_mem_usage_collect_loop.ps1" script, you can merge the csv files manually afterwards.
In the folder where the stub csv files are, run both script in this order.
.\cpu_mem_usage_merge.ps1
.\cpu_mem_usage_fix.ps1
