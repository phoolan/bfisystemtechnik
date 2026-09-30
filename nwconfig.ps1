# Holt alle aktiven Netzwerkadapter mit einer IPv4-Adresse
$adapters = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }

# Hostnamen auslesen
$hostname = hostname


Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " NETZWERKINFORMATIONEN FÜR: $hostname" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

foreach ($adapter in $adapters) {
    Write-Host "Adapter: $($adapter.Description)" -ForegroundColor Yellow
    Write-Host "------------------------------------------"
    
    # IPv4-Adresse extrahieren (Filtert IPv6 heraus)
    $ip = $adapter.IPAddress | Where-Object { $_ -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$' }
    $subnet = $adapter.IPSubnet | Where-Object { $_ -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$' }
    
    Write-Host "  IP-Adresse:   $ip"
    Write-Host "  Subnetzmaske: $subnet"
    Write-Host "  Gateway:      $($adapter.DefaultIPGateway)"
    Write-Host "  DNS-Server:   $($adapter.DNSServerSearchOrder -join ', ')"
    
    # DHCP Status prüfen
    if ($adapter.DHCPEnabled) {
        Write-Host "  DHCP aktiv:   Ja" -ForegroundColor Green
    } else {
        Write-Host "  DHCP aktiv:   Nein (Statisch)" -ForegroundColor Red
    }
    Write-Host ""
}
