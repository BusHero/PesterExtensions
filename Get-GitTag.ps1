param (
	[string]
	$Tag
)

git fetch --prune
$foo = git describe --tags --abbrev=0 --match 'v*' --exclude '*-rc*'
$foo = $foo.substring(1)
return "::set-output name=$Tag::$foo"