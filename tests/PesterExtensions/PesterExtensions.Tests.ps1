BeforeDiscovery {
	$CommandNames = @(
		'Get-ScriptPath'
	)
	$Commands = foreach ($command in $CommandNames) { @{ Command = $command } }
	$Stupid = @( @{CommandNames = $CommandNames } )
}

BeforeAll {
	$ModulePath = $PSCommandPath.Replace('.Tests.ps1', '.psd1').Replace('\tests', '\src')
	$ModuleInfo = Test-ModuleManifest -Path $ModulePath

	Import-Module $ModulePath
	$ImportedModule = Get-Module 'PesterExtensions'
}

Describe 'All the important fields are not empty' {
	BeforeAll {
	}
	It '<property>' -TestCases @(
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
	) {
		$ModuleInfo."$property" | Should -Not -Be $null
	}
}



Describe 'Exported functions' {
	Context 'stupid' -Foreach $stupid {
		It 'Module manifest contains all the exported commands' {
			$ModuleInfo.ExportedCommands.Keys | Should -Be $CommandNames
		}
		It 'Imported Module contains all the exported commands' {
			$ImportedModule.ExportedCommands.Keys | Should -Be $CommandNames
		}

	}
	It 'asd' -TestCases $Commands {
		Get-Command -Name $command -ErrorAction Ignore | Should -Not -Be $null -Because "$command function should be exporeted"
	}
}

AfterAll {
	Remove-Module `
		-Name $ImportedModule `
		-ErrorAction Ignore
}