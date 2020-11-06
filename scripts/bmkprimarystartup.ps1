Set-ExecutionPolicy Unrestricted

# Mount new disk 
# TODO : Localizar o disco pelo nome e não pelo numero
# Get-Disk
Initialize-Disk -Number 1 -PartitionStyle MBR
New-Partition -DiskNumber 1 -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel dados
Get-Partition -DiskNumber 1 | Set-Partition -NewDriveLetter D

## Cria a estrutura do Protheus
mkdir d:\arte
# Download do bundle na bucket
gsutil cp gs://bmkprotheus/protheus_bundle_x64-12.1.27-win-top-bra.zip d:\arte
gsutil cp gs://bmkprotheus/sqlncli.msi d:\arte
gsutil cp gs://bmkprotheus/psqlodbc_x64.msi d:\arte
gsutil cp gs://bmkprotheus/jre-8u271-windows-x64.exe d:\arte
gsutil cp gs://bmkprotheus/npp.7.9.Installer.x64.exe d:\arte
gsutil cp gs://bmkprotheus/license-3.2.0.zip d:\arte
gsutil cp gs://bmkprotheus/baretail.exe d:\arte
gsutil cp gs://bmkprotheus/mRemoteNG-Installer-1.76.20.24615.msi d:\arte

# Descompacta o arquivo baixado
Expand-Archive -LiteralPath 'd:\arte\protheus_bundle_x64-12.1.27-win-top-bra.zip' -DestinationPath d:\

# Atualiza RPO
gsutil cp gs://bmkprotheus/tttp120.rpo d:\totvs\protheus\apo\

mkdir D:\totvs\logs

## Configuracao de um novo usuario
New-LocalUser "handson" -noPassword -FullName "TOTVS Benchmark Handson" -Description "User of benchmark test"
net user handson "Engpro#DBA2020"
Add-localGroupMember -Group "Administrators" -Member "handson"

## Configurando o compartilhamento de diretorio
New-SmbShare -Name "protheus_data" -Path "D:\totvs\protheus\protheus_data" -FullAccess "Everyone" -ChangeAccess "Users" -Description "Protheus_Data main directory"
New-SmbShare -Name "arte" -Path "D:\arte" -FullAccess "Everyone" -ChangeAccess "Users" -Description "Artifacts directory"

$pass = ConvertTo-SecureString "Engpro#DBA2020" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("$(hostname)\handson", $pass)

# New-Service -Name "licenseservervirtual" -DisplayName "...TOTVS | License Server Virtual" -Description "License Server Virtual service" -BinaryPathName "D:\totvs\licenseservervirtual\bin\appserver\appserver.exe" -StartupType Automatic -credential $cred
New-Service -Name "dbaccess-primary" -DisplayName "..TOTVS|DBACCESS_PRIMARY" -Description "DBAccess primary service" -BinaryPathName "D:\totvs\tec\dbaccess\dbaccess64.exe" -StartupType Automatic -credential $cred
New-Service -Name "dbaccess-secondary" -DisplayName "..TOTVS|DBACCESS_SECONDARY" -Description "DBAccess secondary service" -BinaryPathName "D:\totvs\tec\dbaccess-secondary\dbaccess64.exe" -StartupType Automatic -credential $cred
New-Service -Name "appserver-primary" -DisplayName ".TOTVS|APPSERVER_PRIMARY" -Description "Appserver primary service" -BinaryPathName "D:\totvs\tec\appserver\appserver.exe" -StartupType Automatic -credential $cred
New-Service -Name "appserver-compila" -DisplayName ".TOTVS|APPSERVER_COMPILA" -Description "Appserver compila service" -BinaryPathName "D:\totvs\tec\appserver-compila\appserver.exe" -StartupType Automatic -credential $cred

## Instalando o notepad++
Start-process -FilePath "D:\arte\npp.7.9.Installer.x64.exe" -ArgumentList '/S' -Verb runas -Wait

Start-process -FilePath "D:\arte\jre-8u271-windows-x64.exe" -ArgumentList '/s' -Wait

# Desabilita o Firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

## Configuracao conexao com Banco de Dados
# Instalando ODBC SQL Server
Start-process msiexec.exe -Wait -ArgumentList '/i D:\arte\sqlncli.msi /quiet IACCEPTSQLNCLILICENSETERMS=YES ADDLOCAL=ALL' 
# Instalando ODBC PostgreSQL
Start-process msiexec.exe -Wait -ArgumentList '/i D:\arte\psqlodbc_x64.msi /quiet'
Start-process msiexec.exe -Wait -ArgumentList '/i D:\arte\mRemoteNG-Installer-1.76.20.24615.msi /quiet'

Add-OdbcDsn -Name "handson_primary" -DriverName "SQL Server Native CLient 11.0" -DsnType "System" -SetPropertyValue @("Server=10.174.97.3", "Trusted_Connection=no", "Database=handson_primary")
Add-OdbcDsn -Name "handson_log" -DriverName "PostgreSQL ANSI(x64)" -DsnType "System" -SetPropertyValue @("Server=10.174.96.5", "Database=handson_log", "Port=5432")

#Set High Performance
powercfg.exe /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

$acl = Get-Acl -Path 'D:'
$permission = 'Everyone', 'FullControl', 'ContainerInherit, ObjectInherit', 'None', 'Allow'
$rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $permission
$acl.SetAccessRule($rule)
$acl | Set-Acl -Path 'D:'

cd D:\totvs\tec\appserver-broker
start  .\appserver.exe -BALANCE_SMART_CLIENT_DESKTOP -i
