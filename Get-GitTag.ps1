param (
	[string]
	$OutVariable
)

git fetch --prune
$tag = git describe --tags --abbrev=0 --match 'v*' --exclude '*-rc*'
return "::set-output name=${OutVariable}::${tag}"