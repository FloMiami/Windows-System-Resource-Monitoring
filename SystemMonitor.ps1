# Check disk usage and alert if it's above 80%
$disk = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.UsedSpace -ne 0 -and ($_.Used / $_.UsedSpace) -ge 0.8 }
if ($disk) {
    # Loop through each drive and output the usage
    Write-Output "Disk usage is above 80% on the following drives:"
    $disk | ForEach-Object { Write-Output "$($_.Name): $([math]::Round($_.Used / 1GB, 2)) GB used" }
} else {
    Write-Output "Disk usage is within normal limits."
}

# Check memory usage and alert if it's above 80%
$memory = Get-WmiObject -Class Win32_OperatingSystem
if ($memory.TotalVisibleMemorySize -ne 0) {
    $usedMemoryPercent = (($memory.TotalVisibleMemorySize - $memory.FreePhysicalMemory) / $memory.TotalVisibleMemorySize) * 100
    if ($usedMemoryPercent -ge 80) {
        Write-Output "Memory usage is above 80%: $([math]::Round($usedMemoryPercent, 2))%"
    } else {
        Write-Output "Memory usage is within normal limits: $([math]::Round($usedMemoryPercent, 2))%"
    }
} else {
    Write-Output "Unable to retrieve memory usage information."
}

<#
Check CPU usage and alert if it's above 80%.
This uses the Get-Counter cmdlet to fetch real-time CPU performance data.
#>
$cpu = Get-Counter '\Processor(_Total)\% Processor Time'
$cpuUsage = $cpu.CounterSamples.CookedValue
if ($cpuUsage -ge 80) {
    Write-Output "CPU usage is above 80%: $([math]::Round($cpuUsage, 2))%"
} else {
    Write-Output "CPU usage is within normal limits: $([math]::Round($cpuUsage, 2))%"
}
