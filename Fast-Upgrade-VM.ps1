######################################################################
# Created By @RicardoConzatti | September 2017
# www.Solutions4Crowds.com.br
######################################################################
$vCenter = "0" # Default = 0 | vCenter Server FQDN or IP
$vCuser = "0" # Default = 0 | vCenter Server User
######################################################################
######################### SELECT THE FEATURES ########################
######################################################################
$EnableFloppy = 0 # 0 = Disabled | 1 = Enabled ## Enable to remove Floppy Drive
$EnablevHardware = 0 # 0 = Disabled | 1 = Enabled ## Enable to Upgrade Virtual Hardware
$VMHardwareVersion = "v11" # Virtual Hardware Version to UPGRADE
$EnableCPUHotAdd = 0 # 0 = Disabled | 1 = Enabled ## Enable vCPU HotAdd
$EnableMemoryHotAdd = 0 # 0 = Disabled | 1 = Enabled ## Enable Memory HotAdd
######################################################################
if ($EnableFloppy -eq 1) {
	$MsgFloppy = "Enabled"
	$ColorFloppy = "green"
}
else {
	$MsgFloppy = "Disabled"
	$ColorFloppy = "red"
}

if ($EnablevHardware -eq 1) {
	$MsgvHardware = "Enabled"
	$ColorvHardware = "green"
}
else {
	$MsgvHardware = "Disabled"
	$ColorvHardware = "red"
}

if ($EnableCPUHotAdd -eq 1) {
	$MsgvCPUhotadd = "Enabled"
	$ColorvCPUhotadd = "green"
}
else {
	$MsgvCPUhotadd = "Disabled"
	$ColorvCPUhotadd = "red"
}

if ($EnableMemoryHotAdd -eq 1) {
	$MsgMemoryhotadd = "Enabled"
	$ColorMemoryhotadd = "green"
}
else {
	$MsgMemoryhotadd = "Disabled"
	$ColorMemoryhotadd = "red"
}
######################################################################
Function Enable-MemHotAdd($vm){ # FUNCTION ENABLE MEMORY HOTADD
	$vmview = Get-vm $vm | Get-View
	$vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
	$extra = New-Object VMware.Vim.optionvalue
	$extra.Key="mem.hotadd"
	$extra.Value="true"
	$vmConfigSpec.extraconfig += $extra
	$vmview.ReconfigVM($vmConfigSpec)
}
Function Enable-vCpuHotAdd($vm){ # FUNCTION ENABLE CPU HOTADD
	$vmview = Get-vm $vm | Get-View
	$vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
	$extra = New-Object VMware.Vim.optionvalue
	$extra.Key="vcpu.hotadd"
	$extra.Value="true"
	$vmConfigSpec.extraconfig += $extra
	$vmview.ReconfigVM($vmConfigSpec)
}
######################################################################
cls
$S4Ctitle = "Fast Upgrade VM v1.0"
$Body = 'www.Solutions4Crowds.com.br
=======================================================
'
write-host $S4Ctitle
write-host $Body
write-host "Connect to vCenter Server`n`n=======================================================`n"
if ($vCenter -eq 0) {
	$vCenter = read-host "vCenter Server (FQDN or IP)"
}
else {
	write-host "vCenter Server: $vCenter"
}
if ($vCuser -eq 0) {
	$vCuser = read-host "`nUsername"
}
else {
	write-host "`nUsername: $vCuser"
}
$vCpass = Read-Host -assecurestring "`nPassword"
$vCpass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($vCpass))
Connect-VIServer $vCenter -u $vCuser -password $vCpass | Out-Null
if ($global:DefaultVIServers[0].name -ne $null) {
	write-host "`nConnected to $vCenter`n" -foregroundcolor "green"
}
else {
	write-host "`nNot Connected to $vCenter. Try again!`n" -foregroundcolor "red"
	exit
}
pause
cls
write-host $S4Ctitle
write-host $Body
write-host "Fast Upgrade VM ($vCenter)`n`n=======================================================`n"
write-host "1 - Datacenter`n2 - Cluster`n3 - Resource Pool`n4 - Folder`n"
$QuestionLocation = read-host "Select Virtual Machines Location"

if ($QuestionLocation -eq 1) { # Datacenter
	$GetDC = Get-Datacenter | Get-View
	$ListDCtotal = 0
	write-host "`n=======================================================`n"
	if ($GetDC.Name.count -eq 1) {
		$VMLocation = $GetDC.Name
		write-host "Datacenter: $VMLocation"
	}
	else {
		while ($GetDC.Name.count -ne $ListDCtotal) {
			write-host "$ListDCtotal -"$GetDC.Name[$ListDCtotal]
			$ListDCtotal++;
		}
		$MyDC = read-host "`nDatacenter Number"
		$VMLocation = $GetDC.Name[$MyDC]
	}
}
if ($QuestionLocation -eq 2) { # Cluster
	$GetCluster = Get-Cluster | Get-View
	$ListClustertotal = 0
	write-host "`n=======================================================`n"
	if ($GetCluster.Name.count -eq 1) {
		$VMLocation = $GetCluster.Name
		write-host "Cluster: $VMLocation"
	}
	else {
		while ($GetCluster.Name.count -ne $ListClustertotal) {
			write-host "$ListClustertotal -"$GetCluster.Name[$ListClustertotal]
			$ListClustertotal++;
		}
		$MyCluster = read-host "`nCluster Number"
		$VMLocation = $GetCluster.Name[$MyCluster]
	}
}
if ($QuestionLocation -eq 3) { # Resource Pool
	$GetResourcePool = Get-ResourcePool | Get-View
	$ListResourcePooltotal = 0
	write-host "`n=======================================================`n"
	if ($GetResourcePool.Name.count -eq 1) {
		$VMLocation = $GetResourcePool.Name
		write-host "Resource Pool: $VMLocation"
	}
	else {
		while ($GetResourcePool.Name.count -ne $ListResourcePooltotal) {
			write-host "$ListResourcePooltotal -"$GetResourcePool.Name[$ListResourcePooltotal]
			$ListResourcePooltotal++;
		}
		$MyResourcePool = read-host "`nResource Pool Number"
		$VMLocation = $GetResourcePool.Name[$MyResourcePool]
	}
}
if ($QuestionLocation -eq 4) { # Folder
	$GetFolder = Get-Folder -Type VM | Get-View
	$ListFoldertotal = 0
	write-host "`n=======================================================`n"
	if ($GetFolder.Name.count -eq 1) {
		$VMLocation = $GetFolder.Name
		write-host "Folder: $VMLocation"
	}
	else {
		while ($GetFolder.Name.count -ne $ListFoldertotal) {
			write-host "$ListFoldertotal -"$GetFolder.Name[$ListFoldertotal]
			$ListFoldertotal++;
		}
		$MyFolder = read-host "`nFolder Number"
		$VMLocation = $GetFolder.Name[$MyFolder]
	}
}
######################################################################
$VMtotal = Get-VM -Location $VMLocation
if ($VMtotal.Count -eq 0) { # Check if there are VMs in Location
	write-host "`nThere are no virtual machines in the $VMLocation`nSelect another Virtual Machines Location`n"
	Disconnect-VIServer -Server $vCenter -Confirm:$false
	exit
}
else {
	write-host "`n=======================================================`n$VMLocation - Total number of VM: "$VMtotal.Count"`n=======================================================`n"
	if ($VMtotal.Count -eq 1) {
		if ($VMtotal.PowerState -eq "PoweredOn") { # Verifies that the VM is turned on
			$VMStatus = "red" 
			$VMmsg = "Not ready"
			$VMon = 1
		}
		if ($VMtotal.PowerState -eq "PoweredOff") { # Verifies that the VM is turned off
			$VMStatus = "green"
			$VMmsg = "Ready"
			$VMoff = 1
		}
		write-host "-"$VMtotal.Name"$VMmsg" -foregroundcolor "$VMStatus"
	}
	else {
		$VMNumTotal = 0
		while ($VMtotal.Count -ne $VMNumTotal) { # List all VMs in the $VMLocation
			if ($VMtotal.PowerState[$VMNumTotal] -eq "PoweredOn") { # Verifies that the VM is turned on
				$VMStatus = "red" 
				$VMmsg = "Not ready"
				$VMontemp = 1;$VMon = $VMontemp + $VMon
			}
			if ($VMtotal.PowerState[$VMNumTotal] -eq "PoweredOff") { # Verifies that the VM is turned off
				$VMStatus = "green"
				$VMmsg = "Ready"
				$VMofftemp = 1;$VMoff = $VMofftemp + $VMoff
			}
			write-host "-"$VMtotal.Name[$VMNumTotal]"$VMmsg" -foregroundcolor "$VMStatus"
			$VMNumTotal++
		}
	}
	$VMpowerstate = $VMoff + $VMon
	write-host "`nTotal number of VM: $VMpowerstate"
	if ($VMoff -gt 0 -And $VMon -le 0) {
		write-host "VM ready: $VMoff"
		write-host "`n[ You can continue ]`n" -foregroundcolor "green"
	}
	else {
		write-host "VM must be turned off: $VMon"
		write-host "VM ready: $VMoff"
		write-host "`n[ You can not continue ]`n" -foregroundcolor "red"
		exit
	}
	write-host "`n=======================================================`n"
	write-host "# STATUS OF FEATURES`n"
	write-host "- Remove Floppy Drive: $MsgFloppy" -foregroundcolor "$ColorFloppy"
	write-host "- Upgrade vHardware Version: $MsgvHardware" -foregroundcolor "$ColorvHardware"
	write-host "- CPU HotAdd: $MsgvCPUhotadd" -foregroundcolor "$ColorvCPUhotadd"
	write-host "- Memory HotAdd: $MsgMemoryhotadd`n" -foregroundcolor "$ColorMemoryhotadd"
	if ($EnableFloppy -eq 0 -And $EnablevHardware -eq 0 -And $EnableCPUHotAdd -eq 0 -And $EnableMemoryHotAdd -eq 0) {
		write-host "You MUST enable at least one feature. Edit the script!`n"
		Disconnect-VIServer -Server $vCenter -Confirm:$false
		exit
	}
	$QuestionMigration = read-host "Do you want to continue? (Y or N)"
	if ($QuestionMigration -eq "Y") {
		$VMNumTotal = 0
		write-host		
		while ($VMtotal.Count -ne $VMNumTotal) {
			write-host "#"$VMtotal.Name[$VMNumTotal]
			if ($EnableFloppy -eq 1) { # FLOPPY DRIVE
				$VMfloppy = Get-FloppyDrive -VM $VMtotal.Name[$VMNumTotal] # Get VM with Floppy Drive
				if ($VMfloppy.Count -gt 0) {
					Remove-FloppyDrive -Floppy $VMfloppy -Confirm:$false | Out-Null # Remove floppy drive from VM
					write-host "Floppy drive from"$VMtotal.Name[$VMNumTotal]"was removed"
				}
				else {
					write-host "There is no floppy drive in"$VMtotal.Name[$VMNumTotal]
				}
			}
			if ($EnablevHardware -eq 1) { # VIRTUAL HARDWARE VERSION
				$VMversion = Get-VM -Name $VMtotal.Name[$VMNumTotal] # Get VM with Virtual Hardware Version
				if ($VMversion.Version -ne $VMHardwareVersion) {
					Set-VM -VM $VMtotal.Name[$VMNumTotal] -Version $VMHardwareVersion -confirm:$false | Out-Null # Upgrade Virtual Hardware Version
					write-host "Virtual Hardware Version from"$VMtotal.Name[$VMNumTotal]"was upgraded to $VMHardwareVersion"
				}
				else {
					write-host "The virtual hardware is in the correct version in"$VMtotal.Name[$VMNumTotal]
				}
			}
			if ($EnableCPUHotAdd -eq 1) { # CPU HOTADD
				#if ($VMtotal.NumCpu[$VMNumTotal] -lt 8) { # -le or -lt | uncomment if you want to enable cpu hotadd ONLY in VMs with minus 8 vCPU
					$VMCPUhotadd = Get-VM -Name $VMtotal[$VMNumTotal] | Get-View # Get VM
					if ($VMCPUhotadd.Config.CpuHotAddEnabled -ne "False") { # CPU HotAdd
						Enable-vCPUHotAdd $VMtotal.Name[$VMNumTotal]
						write-host "CPU hotadd from"$VMtotal.Name[$VMNumTotal]"was enabled"
					}
					else {
						write-host "CPU hotadd from"$VMtotal.Name[$VMNumTotal]"already enabled"
					}
				#} # uncomment if you want to enable cpu hotadd ONLY in VMs with minus 8 vCPU
			}
			if ($EnableMemoryHotAdd -eq 1) { # MEMORY HOTADD
				$VMMemoryhotadd = Get-VM -Name $VMtotal.Name[$VMNumTotal] | Get-View # Get VM
					if ($VMMemoryhotadd.Config.MemoryHotAddEnabled -ne "False") { # Memory HotAdd
						Enable-MemHotAdd $VMtotal.Name[$VMNumTotal]
						write-host "Memory hotadd from"$VMtotal.Name[$VMNumTotal]"was enabled"
					}
					else {
						write-host "Memory hotadd from"$VMtotal.Name[$VMNumTotal]"already enabled"
					}
				}
			write-host "`n"
			$VMNumTotal++;
			}
		}
	Disconnect-VIServer -Server $vCenter -Confirm:$false
	}