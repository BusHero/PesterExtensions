BeforeAll {
	$ModulePath = $PSCommandPath.Replace('.Get-ProjectRoot.Tests.ps1', '.psd1').Replace('\tests', '\src')
	$script:ModuleInfo = Test-ModuleManifest -Path $ModulePath

	Import-Module $ModulePath
	$script:ImportedModule = Get-Module 'PesterExtensions'
}

Describe 'Parameters' {
	BeforeAll {
		$script:CommandName = 'Get-ProjectRoot'
		$script:Command = Get-Command $CommandName
	}
	Context 'Parameters' -ForEach @(
		@{Parameter = 'Path'; Mandatory = $true }
		@{Parameter = 'ProjectsRoot'; Mandatory = $false }
		@{Parameter = 'Name'; Mandatory = $false }
		@{Parameter = 'Markers'; Mandatory = $false }
	) {
		It '"<commandname>" should have parameter "<parameter>" ' {
			$Command | Should -HaveParameter $parameter -Mandatory:$mandatory
		} 
		It '<parameter> should be documented' {
			$help = Get-Help $CommandName -Parameter $parameter
			$help.Description | Should -Not -BeNullOrEmpty -Because "$parameter should have description"
		}
	}
}

AfterAll {
	Remove-Module `
		-Name $ImportedModule `
		-ErrorAction Ignore
}