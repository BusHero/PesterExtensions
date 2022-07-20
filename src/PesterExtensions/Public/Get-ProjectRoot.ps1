. "${PSScriptRoot}\..\Private\PathUtilities.ps1"

function Get-ProjectRoot {
	[CmdletBinding()]
	param (
		[ValidateScript({ Test-Path $_ })]
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
	throw 'The project root could not be identified'
	<#
		.PARAMETER Path
		Some documentation here and there

		.PARAMETER ProjectsRoot
		Some documentation here and there
	#>
}