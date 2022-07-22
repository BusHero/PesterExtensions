BeforeAll {
	Import-Module -Name PesterExtensions
	. "$(Get-ScriptPath -Path $PSCommandPath -Extension Script)"
	Remove-Module -Name PesterExtensions
}

Describe 'Extensions' -ForEach @(
	@{ Path = 'C:\.config\File.Tests.ps1'; Extension = 'Script'; Expected = 'C:\.config\File.ps1' }
	@{ Path = 'C:\.config\File.Tests.ps1'; Extension = 'Manifest'; Expected = 'C:\.config\File.psd1' }
	@{ Path = 'C:\.config\File.Tests.ps1'; Extension = 'Manifest'; Expected = 'C:\.config\File.psd1' }
	@{ Path = 'C:\.config\File1.Tests.ps1'; Extension = 'Module'; Expected = 'C:\.config\File1.psm1' }
	@{ Path = 'C:\.config\tests\File.Tests.ps1'; Extension = 'Manifest'; Expected = 'C:\.config\src\File.psd1' }
	@{ Path = 'C:\.config\tests\subdir\File.Tests.ps1'; Extension = 'Manifest'; Expected = 'C:\.config\src\subdir\File.psd1' }
) {
	It '"Get-ScriptPath -Path <path> -Extension <extension> ==> <expected>"' {
		Get-ScriptPath -Path $path -Extension $extension | Should -Be $expected
	}
}

Describe 'SourceDirectory' -ForEach @(
	@{ Path = 'C:\.config\tests\File.Tests.ps1'; SourceDirectory = 'srcs'; Expected = 'C:\.config\srcs\File.ps1' }
	@{ Path = 'C:\.config\tests\File.Tests.ps1'; SourceDirectory = 'source'; Expected = 'C:\.config\source\File.ps1' }
	@{ Path = 'C:\.config\File.Tests.ps1'; SourceDirectory = 'source'; Expected = 'C:\.config\File.ps1' }
) {
	It 'Get-ScriptPath -Path <path> -SourceDirectory <SourceDirectory> ==> <expected>' {
		Get-ScriptPath -Path $path -SourceDirectory $SourceDirectory | Should -Be $expected
	}
}

Describe 'TestsDirectory' -ForEach @(
	@{ Path = 'C:\.config\tst\File.Tests.ps1'; TestsDirectory = 'tst'; Expected = 'C:\.config\src\File.ps1' }
	@{ Path = 'C:\.config\foo\File.Tests.ps1'; TestsDirectory = 'foo'; Expected = 'C:\.config\src\File.ps1' }
) {
	It 'Get-ScriptPath -Path <path> -TestsDirectory <SourceDirectory> ==> <expected>' {
		Get-ScriptPath -Path $path -TestsDirectory $TestsDirectory | Should -Be $expected
	}
}

Describe 'Format Test file' -Tag 'Pester' -ForEach @(
	@{ Path = 'C:\.config\File.Tests.ps1'; Expected = 'C:\.config\File.ps1' }
	@{ Path = 'C:/.config/File.Tests.ps1'; Expected = 'C:\.config\File.ps1' }
	@{ Path = 'C:\.config\File1.Tests.ps1'; Expected = 'C:\.config\File1.ps1' }
	@{ Path = 'C:\.config\tests\File.Tests.ps1'; Expected = 'C:\.config\src\File.ps1' }
	@{ Path = 'C:\.config\tests\subdir\File.Tests.ps1'; Expected = 'C:\.config\src\subdir\File.ps1' }
	@{ Path = 'C:\.config\\\\\tests\subdir\File.Tests.ps1'; Expected = 'C:\.config\src\subdir\File.ps1' }
	@{ Path = 'C:////.config////tests////subdir\File.Tests.ps1'; Expected = 'C:\.config\src\subdir\File.ps1' }
	@{ Path = 'C:////.config////tests////subdir\tests\File.Tests.ps1'; Expected = 'C:\.config\src\subdir\tests\File.ps1' }
) {
	It 'Get Right Path' {
		Get-ScriptPath -Path $path | Should -Be $expected
	}
}
