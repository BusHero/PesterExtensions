param(
	[version]$Version
)

$GUID = 'ca565820-19b6-4420-b671-bbd6268b866c'
$releaseNotes = "$(Get-Content -Path '.\releaseNotes\release.md')"

New-ModuleManifest `
	-Guid $GUID `
	-Path "${PSScriptRoot}\src\PesterExtensions\PesterExtensions.psd1" `
	-Author 'Petru Cervac' `
	-Description 'Some description here and there' `
	-ProjectUri 'https://github.com/BusHero/pester.extenssions' `
	-LicenseUri 'https://github.com/BusHero/pester.extenssions/main/license' `
	-Tags Pester, Tests `
	-RootModule 'PesterExtensions.psm1' `
	-FunctionsToExport 'Get-ScriptPath', 'Get-ProjectRoot', 'Test-SemanticVersionUpdate', 'Mock-EnvironmentVariable' `
	-ReleaseNotes $releaseNotes `
	-HelpInfoUri 'https://raw.githubusercontent.com/BusHero/PesterExtensions/main/help' `
	-ModuleVersion ${Version}