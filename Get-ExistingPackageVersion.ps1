param (
	[string]
	$OutVariable
)

$Module = Find-Module -Name PesterExtensions
$Version = $Module.Version

return "::set-output name=${OutVariable}::${Version}"