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
	param (
		[parameter(Mandatory = $true)][string]$Path,
		[parameter(Mandatory = $false)][FileType]$Extension = [FileType]::Script,
		[parameter(Mandatory = $false)][string]$SourceDirectory = 'src',
		[parameter(Mandatory = $false)][string]$TestsDirectory = 'tests'
	)
	$Parent = Split-Path -Path $Path -Parent | Format-Parent -SourceDirectory $SourceDirectory -TestsDirectory $TestsDirectory
	$BaseName = Split-Path -Path $Path -Leaf | Format-ScriptName -Extension $Extension
	return Join-Path -Path $Parent -ChildPath $BaseName
	<#
		.SYNOPSIS
		Get-ScriptPath gets the path to the script coresponding to the test file.
		
		.OUTPUTS
		System.String. Get-ScriptPath returns the path to the script that is tested.
		
		.PARAMETER Path
		The path to the test script

		.PARAMETER Extension
		The type of the script to be generated. Depending on the type of the script, a different extension will be used. 
		The default value is script 

		.PARAMETER SourceDirectory
		The name of the directory where the source files are located. The default value is src

		.PARAMETER TestsDirectory
		The name of the directory where the tests files are located. The default value is tests

		.EXAMPLE
		PS> Get-ScriptPath -Path C:\project\tests\Foo.Tests.ps1
		C:\project\src\Foo.ps1
		
		.EXAMPLE
		PS> Get-ScriptPath -Path C:\project\tests\Foo.Tests.ps1 -SourceDirector source
		C:\project\source\Foo.ps1
	#>
}