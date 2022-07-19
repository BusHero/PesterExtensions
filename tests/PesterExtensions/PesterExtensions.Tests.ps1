param(
	[parameter(Mandatory)]
	[int]
	$Revision
)


BeforeDiscovery {
	$CommandNames = @(
		'Get-ScriptPath',
		'Get-ProjectRoot'
	) | Sort-Object
	$script:Commands = foreach ($command in $CommandNames) { @{ Command = $command } } 
	$script:Stupid = @( @{CommandNames = $CommandNames } )
}

BeforeAll {
	$ModulePath = $PSCommandPath.Replace('.Tests.ps1', '.psd1').Replace('\tests', '\src')
	$script:ModuleInfo = Test-ModuleManifest -Path $ModulePath

	Import-Module $ModulePath
	$script:ImportedModule = Get-Module 'PesterExtensions'
}

Describe 'All the important fields are not empty' {
	BeforeAll {
	}
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
	It 'Major should be 0' {
		$ModuleInfo.Version.Major | Should -Be 0
	}
	It 'Minor should be 5' {
		$ModuleInfo.Version.Minor | Should -Be 5
	}
	It 'Build should be 0' {
		$ModuleInfo.Version.Build | Should -Be 0
	}
	It 'Revision should be <revision>' {
		$ModuleInfo.Version.Revision | Should -Be $revision
	}
}

Describe 'Exported functions' {
	Context 'stupid' -ForEach $stupid {
		It 'Module manifest contains all the exported commands' {
			$ModuleInfo.ExportedCommands.Keys | Sort-Object | Should -Be $CommandNames
		}
		It 'Imported Module contains all the exported commands' {
			$ImportedModule.ExportedCommands.Keys | Sort-Object | Should -Be $CommandNames
		}
	}
	It '<command> is exported' -TestCases $Commands {
		Get-Command -Name $command -ErrorAction Ignore | Should -Not -Be $null -Because "$command function should be exporeted"
	}
}

AfterAll {
	Remove-Module `
		-Name $ImportedModule `
		-ErrorAction Ignore
}