oh-my-posh init pwsh --config $env:userprofile/Documents/WindowsPowerShell/theme.json | iex
Invoke-Expression (& { (zoxide init powershell | Out-String) })
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
$packages = @(gc $env:USERPROFILE/Documents/WindowsPowershell/MOTD.txt)
if (!$packages) {
	write-host "No outdated packages" -fore green
} else {
	write-host "Outdated packages" -fore red
	echo $packages
}

$env:ChocoOutdated = ($packages | Measure-Object -line).lines

function Update-Choco {
	$dir = pwd
	start powershell -wait -verb runas "choco upgrade all -y"
	cd $env:USERPROFILE/Documents/WindowsPowerShell
	./MOTD.ps1
	$env:ChocoOutdated = (gc MOTD.txt | Measure-Object -line).lines
	cd $dir
}
