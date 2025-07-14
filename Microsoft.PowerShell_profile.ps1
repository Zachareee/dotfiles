# configuraing profile vars
$PROFILEDIR = $PROFILE.Substring(0, $PROFILE.LastIndexOf('\'))
# shell enhancers
oh-my-posh init pwsh --config "$PROFILEDIR\omp\theme.yaml" | Invoke-Expression
Invoke-Expression (& { (zoxide init powershell | Out-String) })
# environment config
$env:EZA_CONFIG_DIR = "$PROFILEDIR/eza"

# command aliases
set-alias eza run-eza

# helper functions
function run-eza
{
	param([string]$dir = ".")
	eza.exe -ahl --git --git-repos --no-quotes --group-directories-first --icons=always $dir
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
# $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
# if (Test-Path($ChocolateyProfile)) {
#   Import-Module "$ChocolateyProfile"
# }
# $packages = @(Get-Content $env:USERPROFILE/Documents/WindowsPowershell/MOTD.txt)
# if (!$packages) {
# 	write-host "No outdated packages" -fore green
# } else {
# 	write-host "Outdated packages" -fore red
# 	echo $packages
# }
#
# $env:ChocoOutdated = ($packages | Measure-Object -line).lines

# function Upgrade {
# 	$dir = pwd
# 	start powershell -wait -verb runas "choco upgrade all -y"
# 	cd $env:USERPROFILE/Documents/WindowsPowerShell
# 	./MOTD.ps1
# 	$env:ChocoOutdated = (gc MOTD.txt | Measure-Object -line).lines
# 	cd $dir
# }
