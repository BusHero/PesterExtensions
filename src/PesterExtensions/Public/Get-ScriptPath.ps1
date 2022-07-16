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

enum FileType {
	Script
	Module
	Manifest
}

function script:Format-ScriptName {
	param (
		[parameter(ValueFromPipeline)][string]$ScriptName,
		[FileType]$Extension
	)
	if ($Extension -eq [FileType]::Script) {
		$StringExtension = 'ps1'
	}
	elseif ($Extension -eq [FileType]::Module) {
		$StringExtension = 'psm1'
	}
	elseif ($Extension -eq [FileType]::Manifest) {
		$StringExtension = 'psd1'
	}
	# $Extension = switch ($Extension) {
	# 	[FileType]::Script { 'ps1' }
	# 	[FileType]::Module { 'psm1' }
	# 	[FileType]::Manifest { 'psd1' }
	# }
	$Name = (Split-Path $ScriptName -LeafBase) -replace '.Tests'
	return "${Name}.${StringExtension}"
}


function Get-ScriptPath {
	param (
		[parameter(Mandatory = $true)][string]$Path,
		[parameter(Mandatory = $false)][FileType]$Extension = [FileType]::Script,
		[parameter(Mandatory = $false)][string]$SourceDirectory = 'src',
		[parameter(Mandatory = $false)][string]$TestsDirectory = 'tests'
	)
	$Parent = Split-Path -Path $Path -Parent | Format-Parent -SourceDirectory $SourceDirectory -TestsDirectory $TestsDirectory
	$BaseName = Split-Path -Path $Path -Leaf | Format-ScriptName -Extension $Extension
	return Join-Path -Path $Parent -ChildPath $BaseName
}