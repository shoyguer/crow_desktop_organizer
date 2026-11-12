<#
  Removes a developer install of Crow DO: the context menu package, the startup
  entry, the classic menu entry and the install folder. Your folders and
  shortcuts in Documents\Crow DO are kept.
#>
param([string]$InstallDir = "$env:LOCALAPPDATA\Programs\Crow DO")
Get-Process CrowDO -ErrorAction SilentlyContinue | Stop-Process -Force
'Crow.DesktopOrganizer', 'Crow.FolderOrganizer' | ForEach-Object { Get-AppxPackage -Name $_ } | Remove-AppxPackage
Remove-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Crow DO' -ErrorAction SilentlyContinue
Remove-Item 'HKCU:\Software\Classes\DesktopBackground\Shell\CrowDO' -Recurse -ErrorAction SilentlyContinue
Start-Sleep -Milliseconds 500
Remove-Item $InstallDir -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA\Crow DO" -Recurse -Force -ErrorAction SilentlyContinue
# Give back the shared desktop permission the installer granted (asks for admin).
$sid = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$pub = [Environment]::GetFolderPath('CommonDesktopDirectory')
Start-Process powershell -Verb RunAs -Wait -ArgumentList '-NoProfile', '-Command', "icacls '$pub' /remove:g '*$sid' | Out-Null"
Write-Host 'Crow DO was removed. Your folders are still in Documents\Crow DO.'
