Set-ExecutionPolicy Unrestricted

# Mount new disk 
# TODO : Localizar o disco pelo nome e não pelo numero
# Get-Disk
Initialize-Disk -Number 1 -PartitionStyle MBR
New-Partition -DiskNumber 1 -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel dados
Get-Partition -DiskNumber 1 | Set-Partition -NewDriveLetter D

$acl = Get-Acl -Path 'D:'
$permission = 'Everyone', 'FullControl', 'ContainerInherit, ObjectInherit', 'None', 'Allow'
$rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permission
$acl.SetAccessRule($rule)
$acl | Set-Acl -Path 'D:'

## Configuracao de um novo usuario
New-LocalUser "handson" -noPassword -FullName "TOTVS Benchmark Handson" -Description "User of benchmark test"
net user handson "Engpro#DBA2020"
Add-localGroupMember -Group "Administrators" -Member "handson"

$pass = ConvertTo-SecureString "Engpro#DBA2020" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("$(hostname)\handson", $pass)

## Cria a estrutura do Protheus
mkdir d:\arte
mkdir d:\arte\odbc
mkdir d:\arte\util
mkdir d:\arte\scripts

# Download do bundle na bucket
gsutil cp gs://bmkprotheus/protheus_bundle_x64-12.1.27-win-sec.zip d:\arte
gsutil cp gs://bmkprotheus/odbc/sqlncli.msi d:\arte\odbc\
gsutil cp gs://bmkprotheus/odbc/msodbcsql.msi d:\arte\odbc\
gsutil cp gs://bmkprotheus/odbc/psqlodbc_x64.msi d:\arte\odbc\
gsutil cp gs://bmkprotheus/util/jre-8u271-windows-x64.exe d:\arte\util\
gsutil cp gs://bmkprotheus/util/npp.7.9.Installer.x64.exe d:\arte\util\
gsutil cp gs://bmkprotheus/scripts/AddLogonAsService.ps1 d:\arte\scripts\

# Descompacta o arquivo baixado
Expand-Archive -LiteralPath 'd:\arte\protheus_bundle_x64-12.1.27-win-sec.zip' -DestinationPath d:\

# Atualiza RPO
gsutil cp gs://bmkprotheus/tttp120.rpo d:\totvs\protheus\apo\

mkdir D:\totvs\logs

(Get-Content -path D:\totvs\tec\appserver01\appserver.ini -Raw) -replace 'WW', $(hostname) | Set-Content -path D:\totvs\tec\appserver01\appserver.ini
(Get-Content -path D:\totvs\tec\appserver02\appserver.ini -Raw) -replace 'WW', $(hostname) | Set-Content -path D:\totvs\tec\appserver02\appserver.ini

## Configurando o compartilhamento de diretorio
New-SmbShare -Name "logs" -Path "D:\totvs\logs" -FullAccess "Everyone" -ChangeAccess "Users" -Description "Logs Protheus directory"
New-SmbShare -Name "arte" -Path "D:\arte" -FullAccess "Everyone" -ChangeAccess "Users" -Description "Arteifacts directory"

## Instalacao de ferramentas
Start-process -FilePath "D:\arte\util\npp.7.9.Installer.x64.exe" -ArgumentList '/S' -Verb runas -Wait
Start-process -FilePath "D:\arte\util\jre-8u271-windows-x64.exe" -ArgumentList '/s' -Wait

## Configuracao conexao com Banco de Dados
# Instalando ODBC SQL Server
# Start-process msiexec.exe -Wait -ArgumentList '/i D:\arte\odbc\sqlncli.msi /quiet IACCEPTSQLNCLILICENSETERMS=YES ADDLOCAL=ALL'
# Start-process msiexec.exe -Wait -ArgumentList '/i d:\arte\odbc\msodbcsql.msi /quiet IACCEPTSQLNCLILICENSETERMS=YES ADDLOCAL=ALL'
Start-process msiexec.exe -Wait -ArgumentList '/quiet /passive /qn /i d:\arte\odbc\msodbcsql.msi IACCEPTMSODBCSQLLICENSETERMS=YES ADDLOCAL=ALL'
# Instalando ODBC PostgreSQL
Start-process msiexec.exe -Wait -ArgumentList '/i D:\arte\odbc\psqlodbc_x64.msi /quiet'

# sleep 20

# Desabilita o Firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
#Set High Performance
powercfg.exe /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
#vcx - Desliga o Server Manager no startup
Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask -Verbose

# Adiciona o usuario HANDSON no Logon As Service
D:\arte\scripts\AddLogonAsService.ps1 handson
del D:\arte\scripts\AddLogonAsService.ps1

New-Service -Name "dbaccess-secondary" -DisplayName "..TOTVS | DBACCESS_SECONDARY" -Description "DBAccess secondary service" -BinaryPathName "D:\totvs\tec\dbaccess-secondary\dbaccess64.exe" -StartupType Automatic -credential $cred 
New-Service -Name "appserver-secondary01" -DisplayName ".TOTVS | APPSERVER_SECONDARY01" -Description "Appserver 01 secondary service" -BinaryPathName "D:\totvs\tec\appserver01\appserver.exe" -StartupType Automatic -credential $cred 
New-Service -Name "appserver-secondary02" -DisplayName ".TOTVS | APPSERVER_SECONDARY02" -Description "Appserver 02 primary service" -BinaryPathName "D:\totvs\tec\appserver02\appserver.exe" -StartupType Automatic -credential $cred 

# Add-OdbcDsn -Name "handson_primary" -DriverName "SQL Server Native CLient 11.0" -DsnType "System" -SetPropertyValue @("Server=10.174.97.3", "Trusted_Connection=no", "Database=handson_primary")
Add-OdbcDsn -Name "handson_primaryvm" -DriverName "ODBC Driver 13 for SQL Server" -DsnType "System" -SetPropertyValue @("Server=10.2.0.5", "Trusted_Connection=no", "Database=handson_primaryvm")
Add-OdbcDsn -Name "handson_primary" -DriverName "ODBC Driver 13 for SQL Server" -DsnType "System" -SetPropertyValue @("Server=10.174.97.3", "Trusted_Connection=no", "Database=handson_primary")
Add-OdbcDsn -Name "handson_log" -DriverName "PostgreSQL ANSI(x64)" -DsnType "System" -SetPropertyValue @("Server=10.174.96.5", "Database=handson_log", "Port=5432")

# Para a GCP
# Baixa e Instala o Agent Cloud Monitoring 
# (New-Object Net.WebClient).DownloadFile("https://repo.stackdriver.com/windows/StackdriverMonitoring-GCM-46.exe", "${env:UserProfile}\StackdriverMonitoring-GCM-46.exe")
# & "${env:UserProfile}\StackdriverMonitoring-GCM-46.exe" /S

# Restart-Service -Name StackdriverMonitoring