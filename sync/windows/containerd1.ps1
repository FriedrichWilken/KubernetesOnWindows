<#
Copyright 2021 The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>
Write-Output "###############################"
Write-Output "STARTING with 'containerd1.ps1'"

Write-Output "# Creating C:\k"
mkdir C:\k\ -Force
#cp "C:/sync/bin/kubelet.exe" "C:/k/kubelet.exe"

$ProgressPreference = 'SilentlyContinue'

#Write-Output "### Enabling Hyper-V-PowerShell-Module"
#Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-PowerShell 


Set-Location 'C:\k'

Write-Output "#Curling 'Install-Containerd.ps1'"

curl.exe -LO 'https://github.com/kubernetes-sigs/sig-windows-tools/releases/latest/download/Install-Containerd.ps1'

Write-Output "# Running 'Install-Containerd.ps1'"

PowerShell "C:\k\Install-Containerd.ps1"


# To avoid the "crictl.exe not on the path error, we add containerd permanantly to the pathhhhh"
# TODO THIS might not be needed ...
$env:path += ";C:\Program Files\containerd"
[Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine)

# REBOOT AFTER THIS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# USED FOR OVS OR OTHER DEV SERVICES THAT WE WANT TO TEST THAT ARENT SIGNED
# NOTE THAT THIS ASSUMES WE ARE REBOOTING AFTER THIS SCRIPT RUNS !!!
#
Bcdedit.exe -set TESTSIGNING ON

Write-Output "DONE with 'containerd1.ps1'"
Write-Output "###############################"