. "${PSScriptRoot}\..\Private\PathUtilities.ps1"

function Get-ProjectRoot {
	[CmdletBinding()]
	param (
		# Some documentation here and there
		[Parameter()]
		[string]
		$Path
	)
	$segments = Get-Segments -Path $Path
	for ($i = 0; $i -lt $segments.Count; $i++) {
		if ($segments[$i] -eq 'projects') {
			return Join-Segments -Segments $segments[0..($i + 1)]
		}
	}
}