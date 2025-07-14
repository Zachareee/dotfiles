# configuring profile vars
$PROFILEDIR = $PSScriptRoot

# shell enhancers
oh-my-posh init pwsh --config "$PROFILEDIR\omp\theme.yaml" | Invoke-Expression
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key Ctrl+n -Function NextHistory
Set-PSReadlineKeyHandler -Key Ctrl+p -Function PreviousHistory

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

function Setup-Cpp
{
	. "$(vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath)\Common7\Tools\Launch-VsDevShell.ps1" 
	# Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\Microsoft.VisualStudio.DevShell.dll";
	# Enter-VsDevShell fc5b9e21
}

function Get-OutdatedPackages
{
	@(Get-Content $PROFILEDIR/MOTD.txt)
}

function Set-NumOutdated
{
	param([array]$cache = (Get-OutdatedPackages))
	$env:OutdatedPackages = ($cache | Measure-Object -line).lines
}

function Upgrade-Winget
{
	. "$PROFILEDIR/winget/install-all.bat"
	. "$PROFILEDIR/MOTD.ps1"
	Set-NumOutdated
}

enum ConfigApplication
{
	nvim
	pwsh
}

function Edit-Config
{
	param(
		[Parameter(Mandatory)]
		[ConfigApplication]$app
	)
	$dir = switch($app)
	{
		nvim
		{
			"$env:LOCALAPPDATA/nvim" 
		}
		pwsh
		{
			$PROFILEDIR 
		}
	}
	$cwd = Get-Location
	Set-Location $dir
	nvim
	Set-Location $cwd
}

$outdated_packages = Get-OutdatedPackages
if (!$outdated_packages)
{
	Write-Host "No outdated packages" -fore green
} else
{
	Write-Host "Outdated packages" -fore red
	Get-Content $PROFILEDIR/PREMOTD.txt
	Write-Output $outdated_packages
}

Set-NumOutdated $outdated_packages

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
# $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
# if (Test-Path($ChocolateyProfile)) {
#   Import-Module "$ChocolateyProfile"
# }
