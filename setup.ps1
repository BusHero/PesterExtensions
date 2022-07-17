param(
	[int]$Revision
)

$Version = '0.4.0'
$releaseNotes = Get-Content -Path ".\releaseNotes\release_${Version}.md"

New-ModuleManifest `
	-Path "${PSScriptRoot}\src\PesterExtensions\PesterExtensions.psd1" `
	-Author 'Petru Cervac' `
	-Description 'Some description here and there' `
	-ProjectUri 'https://github.com/BusHero/pester.extenssions' `
	-LicenseUri 'https://github.com/BusHero/pester.extenssions/blob/main/license' `
	-Tags Pester, Tests `
	-RootModule 'PesterExtensions.psm1' `
	-FunctionsToExport 'Get-ScriptPath' `
	-ReleaseNotes $releaseNotes `
	-ModuleVersion "${Version}.${Revision}"