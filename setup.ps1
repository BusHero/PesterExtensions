New-ModuleManifest `
	-Path "${PSScriptRoot}\src\Pester.Extenssions.psd1" `
	-Author 'Petru Cervac' `
	-ProjectUri 'https://github.com/BusHero/pester.extenssions' `
	-LicenseUri 'https://github.com/BusHero/pester.extenssions/blob/main/license' `
	-CmdletsToExport .\src\Get-ScriptPath.ps1 `
	-Tags Pester, Tests `
	-ModuleVersion '0.1.0'