Write-Host Checking for outdated packages

$oldEncoding = [Console]::OutputEncoding
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# weird characters appear in $output if this is not set
# see https://stackoverflow.com/a/74297741/7011902
$output = winget update

[Console]::OutputEncoding = $oldEncoding

$start = ($output | Select-String "--------------").LineNumber
$end = ($output | Select-String "upgrades available").LineNumber

if ($end - 2 -lt $start)
{
	Set-Content $PSScriptRoot/MOTD.txt ""
} else
{
	$truncated = $output | Select-Object -Index @(($start - 2)..($end - 2))
	$id = ($output | Select-Object -Index ($start - 2)).IndexOf("Id")
	$version = ($output | Select-Object -Index ($start - 2)).IndexOf("Version")
	$source = ($output | Select-Object -Index ($start - 2)).IndexOf("Source")
	$packagesArray = ($truncated -split "\n" | ForEach-Object { ($_.Substring(0, $id) + $_.Substring($version, $source - $version)).TrimEnd() })
	Set-Content $PSScriptRoot/PREMOTD.txt ($packagesArray | Select-Object -First 2)
	Set-Content $PSScriptRoot/MOTD.txt ($packagesArray | Select-Object -Skip 2)
}
