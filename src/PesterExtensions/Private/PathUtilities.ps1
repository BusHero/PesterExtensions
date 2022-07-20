function Get-Segments {
	param (
		[parameter(ValueFromPipeline)][string]$Path
	)
	if (!$path) {
		return;
	}
	$parent = @(Split-Path -Path $Path -Parent | Get-Segments)
	$leaf = Split-Path -Path $Path -Leaf
	return $parent + $leaf
}

function Join-Segments {
	param (
		[parameter(ValueFromPipeline)][string[]]$segments
	)
	$segments = foreach ($segment in $segments) {
		Get-SanitizeSegment -Segment $segment
	}
	return $segments -join [System.IO.Path]::DirectorySeparatorChar
}

function Get-SanitizeSegment {
	param (
		[parameter(ValueFromPipeline)][string]$Segment
	)
	return $segment -replace '/|\\'
}

function script:Format-Parent {
	param (
		[parameter(ValueFromPipeline)][string]$Parent,
		[string]$SourceDirectory,
		[string]$TestsDirectory
	)
	$segments = Get-Segments -Path $Parent
	$index = $segments.IndexOf($TestsDirectory)
	if ($index -ne -1) {
		$segments[$index] = $SourceDirectory
	}
	$Parent = Join-Segments -segments $segments
	return $Parent
}