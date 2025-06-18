write-host Checking for outdated packages
$outdated = choco outdated
$start = ($outdated | sls "Output is package name").LineNumber
$end = ($outdated | sls "Chocolatey has determined").LineNumber

if ($end - 3 -lt $start + 1) {Set-Content MOTD.txt ""} else {
$outdated = $outdated | select -Index @(($start+1)..($end-3))
Set-Content MOTD.txt $outdated
}
