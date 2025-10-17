function Enable-Cpp
{
  $cwd = Get-Location
  . "$(vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath)\Common7\Tools\Launch-VsDevShell.ps1" 
  Set-Location $cwd
  # Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\Microsoft.VisualStudio.DevShell.dll";
  # Enter-VsDevShell fc5b9e21
}

function Clear-ShaDa
{
  Remove-Item -Force -Recurse "$env:LOCALAPPDATA\nvim-data\shada"
}

function Compress-Docker
{
  if (!(docker desktop status 2> $null))
  {
    diskpart.exe /s $PROFILEDIR\compressdocker.txt
  } else
  {
    Write-Output "Docker must be stopped before compressing"
    Write-Output "Use docker desktop stop"
  }
}

function Update-Winget
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
