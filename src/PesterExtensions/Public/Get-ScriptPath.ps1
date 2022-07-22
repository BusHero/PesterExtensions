. "${PSScriptRoot}\..\Private\PathUtilities.ps1"

enum FileType {
	Script
	Module
	Manifest
}

function Get-Extension {
	param (
		[parameter(ValueFromPipeline)]
		[FileType]
		$Extension
	)
	switch ($Extension) {
		Script { return 'ps1'; }
		Module { return 'psm1'; }
		Manifest { return 'psd1'; }
	}
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

function script:Format-ScriptName {
	param (
		[parameter(ValueFromPipeline)][string]$ScriptName,
		[FileType]$Extension
	)
	$StringExtension = Get-Extension -Extension $Extension
	$Name = (Split-Path $ScriptName -LeafBase) -replace '.Tests'
	return "${Name}.${StringExtension}"
}


function Get-ScriptPath {
	#.ExternalHelp ..\en-Us\PesterExtensions.psm1-help.xml
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