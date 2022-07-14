BeforeAll {
	. "${PSScriptRoot}\..\setup.ps1"
}

Describe 'All the important fields are not empty' {
	BeforeAll {
		$ModuleInfo = Test-ModuleManifest -Path "${PSScriptRoot}\..\src\Pester.Extenssions.psd1"
	}
	It '<property>' -TestCases @(
		@{Property = 'Path' }
		@{Property = 'Author' }
		@{Property = 'LicenseUri' }
		@{Property = 'Tags' }
		@{Property = 'Version' }
		@{Property = 'ExportedCmdlets' }
	) {
		$ModuleInfo."$property" | Should -Not -Be $null
	}
}