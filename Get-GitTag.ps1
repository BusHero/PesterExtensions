param (
	[string]
	$Tag
)

git fetch --prune
$foo = git describe --tags --abbrev=0 --match 'v*' --exclude '*-rc*' 'HEAD~'
$foo = $foo.substring(1)
return "::set-output name=$Tag::$foo"