<powershell>
# Disable .Net Optimization Service
Get-ScheduledTask *ngen* | Disable-ScheduledTask

# Disable Windows Auto Updates
# https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/troubleshooting-windows-instances.html#high-cpu-issue
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 1 /f
net stop wuauserv
net start wuauserv

# Remove policies stopping us from enabling WinRM
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" /v AllowBasic /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" /v AllowUnencryptedTraffic /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" /v DisableRunAs /f

# Disable Windows Defender Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true

# Enable WinRM
Invoke-WebRequest -Uri https://raw.githubusercontent.com/ansible/ansible/stable-2.12/examples/scripts/ConfigureRemotingForAnsible.ps1 -OutFile C:\ConfigureRemotingForAnsible.ps1
C:\ConfigureRemotingForAnsible.ps1 -ForceNewSSLCert -EnableCredSSP

# add ec2-user
$Password = ConvertTo-SecureString 'R3dH4t123!' -AsPlainText -Force
New-LocalUser -Name "ec2-user" -Description "Ansible Service Account" -Password $Password
Add-LocalGroupMember -Group "Administrators" -Member "ec2-user"

</powershell>