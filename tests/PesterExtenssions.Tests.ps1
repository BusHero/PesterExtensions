BeforeAll {
	. "${PSScriptRoot}\..\setup.ps1"
}

Describe 'All the important fields are not empty' {
	BeforeAll {
		$ModuleInfo = Test-ModuleManifest -Path "${PSScriptRoot}\..\src\PesterExtensions.psd1"
	}
	It '<property>' -TestCases @(
		@{Property = 'Path' }
		@{Property = 'Author' }
		@{Property = 'LicenseUri' }
		@{Property = 'Tags' }
		@{Property = 'Version' }
		@{Property = 'ExportedCmdlets' }
		@{Property = 'ExportedVariables' }
		@{Property = 'ExportedFunctions' }
		@{Property = 'ExportedAliases' }
		@{Property = 'Copyright' }
		@{Property = 'CompanyName' }
		@{Property = 'Guid' }
		@{Property = 'ProjectUri' }
	) {
		$ModuleInfo."$property" | Should -Not -Be $null
	}
}

