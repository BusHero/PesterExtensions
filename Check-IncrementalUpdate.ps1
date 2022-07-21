param(
	[string]
	$current,

	[string]
	$next
)

. "${PSScriptRoot}\src\PesterExtensions\Public\Check-SemanticVersion.ps1"
Check-SemanticVersion `
	-Current $current `
	-Next $next | Should -BeTrue