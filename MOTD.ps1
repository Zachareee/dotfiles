$outdated = choco outdated | select -skip 4
$outdated = $outdated | select -SkipLast $(if ($outdated -match "Enjoy using Chocolatey") {5} else {2})
sc MOTD.txt $outdated
