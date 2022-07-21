param (
	[string]
	$Tag
)

git fetch --prune
$foo = git describe --tags --abbrev=0 --match 'v*' --exclude '*-rc*'
return "::set-output name=$Tag::$foo"