param(
	[version]$Version
)

BeforeAll {
	Import-Module -Name PesterExtensions
	$ModulePath = "$(Get-ScriptPath -Path $PSCommandPath -Extension Manifest)"
	Remove-Module -Name PesterExtensions

	$script:ModuleInfo = Test-ModuleManifest -Path $ModulePath

	Import-Module $ModulePath
	$script:ImportedModule = Get-Module 'PesterExtensions'
}

Describe 'All the important fields are not empty' {
	It '<property> should not be null' -TestCases @(
		@{ Property = 'Path' }
		@{ Property = 'Description' }
		@{ Property = 'Author' }
		@{ Property = 'LicenseUri' }
		@{ Property = 'Tags' }
		@{ Property = 'Version' }
		@{ Property = 'ExportedCmdlets' }
		@{ Property = 'ExportedVariables' }
		@{ Property = 'ExportedFunctions' }
		@{ Property = 'ExportedAliases' }
		@{ Property = 'Copyright' }
		@{ Property = 'CompanyName' }
		@{ Property = 'Guid' }
		@{ Property = 'ProjectUri' }
		@{ Property = 'ReleaseNotes' }
		@{ Property = 'HelpInfoURI' }
	) {
		$ModuleInfo."$property" | Should -Not -Be $null -Because "$property should be set up"
	}
}

Describe 'Validate the version' {
	It 'Module should have the right version' {
		$ModuleInfo.Version | Should -Be $Version
	}
}

Describe 'Check functions' -ForEach @(
	@{ 
		CommandName = 'Get-ScriptPath';
		Parameters  = @(
			@{ Parameter = 'Path'; Mandatory = $true }
			@{ Parameter = 'Extension'; Mandatory = $false }
			@{ Parameter = 'SourceDirectory'; Mandatory = $false }
			@{ Parameter = 'TestsDirectory'; Mandatory = $false }
		)
	}
	@{ 
		CommandName = 'Get-ProjectRoot';
		Parameters  = @(
			@{ Parameter = 'Path'; Mandatory = $true }
			@{ Parameter = 'ProjectsRoot'; Mandatory = $false }
			@{ Parameter = 'Name'; Mandatory = $false }
			@{ Parameter = 'Markers'; Mandatory = $false }
		)
	}
	@{
		CommandName = 'Test-SemanticVersionUpdate';
		Parameters  = @(
			@{ Parameter = 'Current'; Mandatory = $true }
			@{ Parameter = 'Next'; Mandatory = $true }
		)
	}
	@{
		CommandName = 'Mock-EnvironmentVariable';
		Parameters  = @(
			@{ Parameter = 'Variable'; Mandatory = $true }
			@{ Parameter = 'Value'; Mandatory = $false }
			@{ Parameter = 'Fixture'; Mandatory = $true }
		)
	}
) {
	BeforeAll {
		$script:Command = Get-Command $CommandName
	}
	It 'Module manifest contains <commandName>' {
		$ModuleInfo.ExportedCommands.Keys | Should -Contain $CommandName
	}
	It 'Imported Module contains <commandName>' {
		$ImportedModule.ExportedCommands.Keys | Should -Contain $CommandName
	}
	Describe '<parameter>' -ForEach $Parameters {
		It '<CommandName> contains <parameter>' {
			$command | Should -HaveParameter $parameter -Mandatory:$mandatory
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