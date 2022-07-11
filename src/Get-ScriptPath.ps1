function Get-ScriptPath {
	param (
		[string]$Path
	)
	$BaseName = Split-Path -Path $Path -Leaf
	$Parent = Split-Path -Path $Path -Parent
	$BaseName = $BaseName -replace '.Tests'
	$Parent = $Parent.replace('\tests', '\src')
	return "${Parent}\${BaseName}"
}