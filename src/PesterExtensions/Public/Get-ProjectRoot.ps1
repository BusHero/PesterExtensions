. "${PSScriptRoot}\..\Private\PathUtilities.ps1"

function Get-ProjectRoot {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$Path,

		[Parameter(Mandatory = $false)]
		[string[]]
		$ProjectsRoot = 'projects'
	)
	$segments = Get-Segments -Path $Path
	for ($i = 0; $i -lt $segments.Count; $i++) {
		if ($ProjectsRoot -contains $segments[$i]) {
			return Join-Segments -Segments $segments[0..($i + 1)]
		}
	}
	<#
		.PARAMETER Path
		Some documentation here and there

		.PARAMETER ProjectsRoot
		Some documentation here and there
	#>
}