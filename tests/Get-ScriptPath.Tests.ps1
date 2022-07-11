BeforeAll {
	. "$PSScriptRoot\..\src\Get-ScriptPath.ps1"
}

Describe 'Format Test file' -Tag 'Pester' -ForEach @(
	@{ Path = 'C:\.config\File.Tests.ps1'; Expected = 'C:\.config\File.ps1' }
	@{ Path = 'C:\.config\File1.Tests.ps1'; Expected = 'C:\.config\File1.ps1' }
	@{ Path = 'C:\.config\tests\File.Tests.ps1'; Expected = 'C:\.config\src\File.ps1' }
	@{ Path = 'C:\.config\tests\subdir\File.Tests.ps1'; Expected = 'C:\.config\src\subdir\File.ps1' }
) {
	It 'Get Right Path' {
		Get-ScriptPath -Path $path | Should -Be $expected
	}
}