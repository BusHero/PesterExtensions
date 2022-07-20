# BeforeAll {
# 	$ModulePath = $PSCommandPath.Replace('.Get-ScriptPath.Tests.ps1', '.psd1').Replace('\tests', '\src')
# 	$script:ModuleInfo = Test-ModuleManifest -Path $ModulePath

# 	Import-Module $ModulePath
# 	$script:ImportedModule = Get-Module 'PesterExtensions'
# }

# Describe 'Parameters' {
# 	BeforeAll {
# 		$script:Command = Get-Command Get-ScriptPath
# 	}
# 	Context 'Parameters' -ForEach @(
# 		@{Parameter = 'Path'; Mandatory = $true }
# 	) {
# 		It '<parameter>' {
# 			$Command | Should -HaveParameter $parameter -Mandatory:$mandatory
# 		} 
# 		It '<parameter> should be documented' {
# 			$help = Get-Help 'Get-ScriptPath' -Parameter $parameter
# 			$help.Description | Should -Not -BeNullOrEmpty -Because "$parameter should have description"
# 		}
# 	}
# }

# AfterAll {
# 	Remove-Module `
# 		-Name $ImportedModule `
# 		-ErrorAction Ignore
# }