$outdated = choco outdated
$start = ($outdated | sls "Output is package name").LineNumber
$end = ($outdated | sls "Chocolatey has determined").LineNumber

$outdated = $outdated | select -Index @(($start+1)..($end-3))
sc MOTD.txt $outdated
