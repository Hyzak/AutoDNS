@echo off
color 02
net session >nul 2>&1
if %errorlevel% neq 0 (
    title AutoDNS - Error de permisos
    echo ERROR: Este script requiere privilegios de administrador.
    echo Por favor, haz clic derecho y selecciona "Ejecutar como administrador".
    pause
    exit /b
)
title AutoDNS - Ejecutando script
set "tf=%temp%\AD_tf.ps1"
del "%tf%" >nul 2>&1
>> "%tf%" echo $dnsList = @(
>> "%tf%" echo     @{Name="Cloudflare"; IP="1.1.1.1"},
>> "%tf%" echo     @{Name="Cloudflare (secundario)"; IP="1.0.0.1"},
>> "%tf%" echo     @{Name="Google"; IP="8.8.8.8"},
>> "%tf%" echo     @{Name="Google (secundario)"; IP="8.8.4.4"},
>> "%tf%" echo     @{Name="Quad9"; IP="9.9.9.9"},
>> "%tf%" echo     @{Name="Quad9 (secundario)"; IP="149.112.112.112"},
>> "%tf%" echo     @{Name="OpenDNS"; IP="208.67.222.222"},
>> "%tf%" echo     @{Name="OpenDNS (secundario)"; IP="208.67.220.220"},
>> "%tf%" echo     @{Name="Comodo Secure"; IP="8.26.56.26"},
>> "%tf%" echo     @{Name="Comodo Secure (secundario)"; IP="8.20.247.20"},
>> "%tf%" echo     @{Name="AdGuard DNS"; IP="94.140.14.14"},
>> "%tf%" echo     @{Name="AdGuard DNS (secundario)"; IP="94.140.15.15"},
>> "%tf%" echo     @{Name="CleanBrowsing"; IP="185.228.168.9"},
>> "%tf%" echo     @{Name="CleanBrowsing (secundario)"; IP="185.228.169.9"},
>> "%tf%" echo     @{Name="Level3"; IP="209.244.0.3"},
>> "%tf%" echo     @{Name="Level3 (secundario)"; IP="209.244.0.4"},
>> "%tf%" echo     @{Name="Neustar UltraDNS"; IP="156.154.70.1"},
>> "%tf%" echo     @{Name="Neustar UltraDNS (secundario)"; IP="156.154.71.1"}
>> "%tf%" echo )
>> "%tf%" echo $results = @()
>> "%tf%" echo Write-Host "Evaluando servidores DNS..." -ForegroundColor Cyan
>> "%tf%" echo foreach ($dns in $dnsList) {
>> "%tf%" echo     Write-Host "- $($dns.Name):" -ForegroundColor Yellow -NoNewline
>> "%tf%" echo     try {
>> "%tf%" echo         $pingResult = Test-Connection -ComputerName $dns.IP -Count 2 -BufferSize 16 -ErrorAction Stop
>> "%tf%" echo         $avg = ($pingResult ^| Measure-Object -Property ResponseTime -Average).Average
>> "%tf%" echo         Write-Host " $avg ms" -ForegroundColor Green
>> "%tf%" echo         $results += [PSCustomObject]@{
>> "%tf%" echo             IP = $dns.IP
>> "%tf%" echo             Name = $dns.Name
>> "%tf%" echo             Latency = $avg
>> "%tf%" echo         }
>> "%tf%" echo     } catch {
>> "%tf%" echo         Write-Host "No se pudo contactar" -ForegroundColor Red
>> "%tf%" echo     }
>> "%tf%" echo }
>> "%tf%" echo if ($results.Count -lt 2) {
>> "%tf%" echo     Write-Host "Error: No se encontraron suficientes servidores DNS funcionales." -ForegroundColor Red
>> "%tf%" echo     return
>> "%tf%" echo }
>> "%tf%" echo $sorted = $results ^| Sort-Object -Property Latency
>> "%tf%" echo $primary = $sorted[0]
>> "%tf%" echo $secondary = $sorted[1]
>> "%tf%" echo Write-Host "DNS primario: $($primary.Name) ($($primary.IP)) - $($primary.Latency) ms" -ForegroundColor Cyan
>> "%tf%" echo Write-Host "DNS secundario: $($secondary.Name) ($($secondary.IP)) - $($secondary.Latency) ms" -ForegroundColor Cyan
>> "%tf%" echo $adapter = Get-NetAdapter -Physical ^| Where-Object { $_.Status -eq "Up" -and ($_.Name -like "*Ethernet*" -or $_.Name -like "*Wi-Fi*" -or $_.InterfaceDescription -like "*Ethernet*" -or $_.InterfaceDescription -like "*Wi-Fi*") } ^| Select-Object -First 1
>> "%tf%" echo if ($adapter) {
>> "%tf%" echo     Write-Host "Aplicando DNS al adaptador: $($adapter.Name)" -ForegroundColor Cyan
>> "%tf%" echo     try {
>> "%tf%" echo         Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ServerAddresses $primary.IP, $secondary.IP -ErrorAction Stop
>> "%tf%" echo         Write-Host "el DNS se ha configurado exitosamente." -ForegroundColor Green
>> "%tf%" echo     } catch {
>> "%tf%" echo         Write-Host "Error al aplicar la configuración DNS. Detalles: $_" -ForegroundColor Red
>> "%tf%" echo     }
>> "%tf%" echo } else {
>> "%tf%" echo     Write-Host "Error: No se pudo encontrar un adaptador de red físico válido" -ForegroundColor Red
>> "%tf%" echo }
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%tf%"
if %errorlevel% neq 0 (
    title AutoDNS - Error del script
    echo Error: Falló la ejecución del script PowerShell.
    pause
)
del "%tf%" >nul 2>&1
for /l %%i in (10,-1,1) do (
    title AutoDNS - Saliendo en %%i...
    timeout /t 1 /nobreak >nul
)