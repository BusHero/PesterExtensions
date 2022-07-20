BeforeAll {
	$ModulePath = $PSCommandPath.Replace('.Get-ScriptPath.Tests.ps1', '.psd1').Replace('\tests', '\src')
	$script:ModuleInfo = Test-ModuleManifest -Path $ModulePath

	Import-Module $ModulePath
	$script:ImportedModule = Get-Module 'PesterExtensions'
}

Describe 'Parameters' {
	BeforeAll {
		$script:Command = Get-Command Get-ScriptPath
	}
	Context 'Parameters' -ForEach @(
		@{Parameter = 'Path'; Mandatory = $true }
		@{Parameter = 'Extension'; Mandatory = $false }
		@{Parameter = 'SourceDirectory'; Mandatory = $false }
		@{Parameter = 'TestsDirectory'; Mandatory = $false }
	) {
		It '<parameter>' {
			$Command | Should -HaveParameter $parameter -Mandatory:$mandatory
		} 
		It '<parameter> should be documented' {
			$help = Get-Help 'Get-ScriptPath' -Parameter $parameter
			$help.Description | Should -Not -BeNullOrEmpty -Because "$parameter should have description"
		}
	}
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