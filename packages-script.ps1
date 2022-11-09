Write-Output "=================="
Write-Output "Instalando pacotes"
Write-Output "=================="

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

#Utils
choco install dotnet3.5 -y
choco install anydesk.install -y
choco install microsoft-teams -y
choco install office365business -y
choco install visualstudio2019buildtools -y
choco install tortoisegit -y
choco install winmerge -y
choco install sql-server-2017-cumulative-update -y
choco install sql-server-management-studio -y
choco install sliksvn -y
choco install javaruntime -y

#Sophos
Start-Process -NoNewWindow -FilePath  "\\example\SophosSetup.exe"

#Zabbix
Copy-Item -Path "\\example\*" -Destination "C:\Windows\" -Force -Recurse

Write-Output "=================="
Write-Output "Atualizando pacotes"
Write-Output "=================="

choco upgrade dotnet3.5 -y
choco upgrade anydesk.install -y
choco upgrade microsoft-teams -y
choco upgrade office365business -y
choco upgrade visualstudio2019buildtools -y
choco upgrade tortoisegit -y
choco upgrade winmerge -y
choco upgrade sql-server-2017-cumulative-update -y
choco upgrade sql-server-management-studio -y
choco upgrade sliksvn -y
choco upgrade javaruntime -y

Write-Output "=================="
Write-Output "Adquirindo informações!!!"
Write-Output "=================="

Get-NetAdapter -InterfaceDescription * | select Name,MacAddress | out-file C:\IPinfo.txt | Format-Wide
gc env:computername | Add-Content C:\IPinfo.txt
Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true |
    Select-Object -ExpandProperty IPAddress | Add-Content C:\IPinfo.txt | Format-List

$From = "example@example.com.br"
$To = "example@example.com.br"
$Attachment = "C:\Script\TesteInfo.txt"
$Subject = "Nova máquina no domínio"
$Body = "<h2>Abrir chamado para fixação do IP com as seguintes informações do arquivo em anexo</h2><br><br>"
$Body += "Informações de IP!"
$SMTPServer = "smtp.office365.com"
$SMTPPort = "587"
Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential (Get-Credential) -Attachments $Attachment


Remove-Item –path C:\IPinfo.txt –recurse

Write-Output "=================="
Write-Output "Finalizado!!!"
Write-Output "=================="