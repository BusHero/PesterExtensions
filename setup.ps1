param(
	[int]$Revision
)

$GUID = 'ca565820-19b6-4420-b671-bbd6268b866c'
$Version = '0.4.0'
$releaseNotes = Get-Content -Path ".\releaseNotes\release_${Version}.md"

New-ModuleManifest `
	-Guid $GUID `
	-Path "${PSScriptRoot}\src\PesterExtensions\PesterExtensions.psd1" `
	-Author 'Petru Cervac' `
	-Description 'Some description here and there' `
	-ProjectUri 'https://github.com/BusHero/pester.extenssions' `
	-LicenseUri 'https://github.com/BusHero/pester.extenssions/blob/main/license' `
	-Tags Pester, Tests `
	-RootModule 'PesterExtensions.psm1' `
	-FunctionsToExport 'Get-ScriptPath' `
	-ReleaseNotes $releaseNotes `
	-HelpInfoUri 'https://github.com/BusHero/PesterExtensions/blob/main' `
	-ModuleVersion "${Version}.${Revision}"