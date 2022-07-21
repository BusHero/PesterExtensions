param(
	[string]
	$current,

	[string]
	$next
)

. "${PSScriptRoot}\src\PesterExtensions\Public\Check-SemanticVersion.ps1"
$next = $next.Substring(1)
Check-SemanticVersion `
-Current $current `
-Next $next | Should -BeTrue