BeforeAll {
	$ModulePath = $PSCommandPath.Replace('.Get-ScriptPath.Tests.ps1', '.psd1').Replace('\tests', '\src')
	$script:ModuleInfo = Test-ModuleManifest -Path $ModulePath

	Import-Module $ModulePath
	$script:ImportedModule = Get-Module 'PesterExtensions'
}

Describe 'Documentation' {
	BeforeAll {
		$script:help = Get-Help Get-ScriptPath
	}
	It '<property>' -TestCases @(
		@{ Property = 'returnValues' }
		@{ Property = 'synopsis' }
		@{ Property = 'examples' }
	) {
		$help."$property" | Should -Not -BeNullOrEmpty
	}
	It 'details' {
		$help.details.Verb | Should -Be 'Get'
	}
	It 'name' {
		$help.details.name | Should -Be 'Get-ScriptPath'
	}
	It 'noun' {
		$help.details.noun | Should -Be 'ScriptPath'
	}
	It 'description' {
		$help.details.description | Should -Not -BeNullOrEmpty
	}
}

AfterAll {
	Remove-Module `
		-Name $ImportedModule `
		-ErrorAction Ignore
}