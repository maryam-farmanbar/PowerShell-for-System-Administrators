<#
.SYNOPSIS
    Skript zur Generierung eines System-Inventarberichts.
    
.DESCRIPTION
    Dieses Skript sammelt grundlegende Systeminformationen (Betriebssystem, CPU, Arbeitsspeicher, Festplatten)
    und exportiert diese in eine CSV-Datei für die IT-Asset-Dokumentation.

.AUTHOR
    Maryam Farmanbar
    
.VERSION
    1.0
#>

# Variablen definieren
$OutputPfad = "C:\Temp\SystemInfo_Report.csv"

# Informationen sammeln
$SystemInfo = Get-CimInstance Win32_OperatingSystem | Select-Object @{Name="Hostname";Expression={$_.CSName}}, Caption, Version
$CpuInfo    = Get-CimInstance Win32_Processor | Select-Object @{Name="CPU";Expression={$_.Name}}
$RamInfo    = Get-CimInstance Win32_ComputerSystem | Select-Object @{Name="RAM_GB";Expression={[math]::round($_.TotalPhysicalMemory / 1GB, 2)}}
$DiskInfo   = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID = 'C:'" | Select-Object @{Name="Festplatte_C_Frei_GB";Expression={[math]::round($_.FreeSpace / 1GB, 2)}}

# Objekt erstellen und exportieren
$Report = [PSCustomObject]@{
    Hostname = $SystemInfo.Hostname
    OS       = $SystemInfo.Caption
    CPU      = $CpuInfo.CPU
    RAM_GB   = $RamInfo.RAM_GB
    Disk_C_GB = $DiskInfo.Festplatte_C_Frei_GB
    Datum    = Get-Date -Format "yyyy-MM-dd"
}

$Report | Export-Csv -Path $OutputPfad -NoTypeInformation -Encoding UTF8

Write-Host "Bericht erfolgreich unter $OutputPfad gespeichert." -ForegroundColor Green
