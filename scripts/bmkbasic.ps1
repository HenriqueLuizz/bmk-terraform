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

# Download do bundle na bucket
gsutil cp gs://bmkprotheus/odbc/sqlncli.msi d:\arte\odbc\
gsutil cp gs://bmkprotheus/odbc/psqlodbc_x64.msi d:\arte\odbc\
gsutil cp gs://bmkprotheus/util/jre-8u271-windows-x64.exe d:\arte\util\
gsutil cp gs://bmkprotheus/uitl/npp.7.9.Installer.x64.exe d:\arte\util\
gsutil cp gs://bmkprotheus/scripts/AddLogonAsService.ps1 d:\arte\

## Configurando o compartilhamento de diretorio
New-SmbShare -Name "arte" -Path "D:\arte" -FullAccess "Everyone" -ChangeAccess "Users" -Description "Arteifacts directory"

## Instalacao de ferramentas
Start-process -FilePath "D:\arte\util\npp.7.9.Installer.x64.exe" -ArgumentList '/S' -Verb runas -Wait
Start-process -FilePath "D:\arte\util\jre-8u271-windows-x64.exe" -ArgumentList '/s' -Wait

## Configuracao conexao com Banco de Dados
# Instalando ODBC SQL Server
Start-process msiexec.exe -Wait -ArgumentList '/i D:\arte\odbc\sqlncli.msi /quiet IACCEPTSQLNCLILICENSETERMS=YES ADDLOCAL=ALL' 
# Instalando ODBC PostgreSQL
Start-process msiexec.exe -Wait -ArgumentList '/i D:\arte\odbc\psqlodbc_x64.msi /quiet'

#Configura as ODBCs
Add-OdbcDsn -Name "handson_primary" -DriverName "SQL Server Native CLient 11.0" -DsnType "System" -SetPropertyValue @("Server=10.174.97.3", "Trusted_Connection=no", "Database=handson_primary")
Add-OdbcDsn -Name "handson_log" -DriverName "PostgreSQL ANSI(x64)" -DsnType "System" -SetPropertyValue @("Server=10.174.96.5", "Database=handson_log", "Port=5432")

# Desabilita o Firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

#Set High Performance
powercfg.exe /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# Adiciona o usuario HANDSON no Logon As Service
D:\arte\scripts\AddLogonAsService.ps1 handson
del D:\arte\scripts\AddLogonAsService.ps1