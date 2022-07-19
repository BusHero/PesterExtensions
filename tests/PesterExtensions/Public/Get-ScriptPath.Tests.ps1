
BeforeAll {
	$foo = $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('\tests', '\src')
	. $foo
}

Describe 'Can specify extension' {
	BeforeAll {
		$Command = Get-Command Get-ScriptPath
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

Describe 'Get segments' -ForEach @(
	@{Path = 'C:\foo\bar\baz'; Segments = @('C:\', 'foo', 'bar', 'baz' ) }
	@{Path = 'C:/foo/bar/baz'; Segments = @('C:\', 'foo', 'bar', 'baz' ) }
	@{Path = 'C:\foo\bar'; Segments = @('C:\', 'foo', 'bar') }
	@{Path = 'C:\foo\\bar'; Segments = @('C:\', 'foo', 'bar') }
	@{Path = 'C:\foo\bar\'; Segments = @('C:\', 'foo', 'bar') }
) {
	It 'Get Segments returns the right value' {
		Get-Segments -Path $path | Should -Be $Segments
	}
}

Describe 'Combine paths' -ForEach @(
	@{ Segments = @('foo', 'bar', 'baz'); Path = 'foo\bar\baz' }
	@{ Segments = @('foo\', 'bar', 'baz'); Path = 'foo\bar\baz' }
	@{ Segments = @('foo', 'bar\'); Path = 'foo\bar' }
	@{ Segments = @('foo/', 'bar'); Path = 'foo\bar' }
	@{ Segments = @('\foo', '/bar'); Path = 'foo\bar' }
	@{ Segments = @('\foo\', '/bar'); Path = 'foo\bar' }
	@{ Segments = @('\foo\\\', '/bar'); Path = 'foo\bar' }
	@{ Segments = @('\\\foo\\\', '/bar'); Path = 'foo\bar' }
) {
	It 'Path is formatted correctly' {
		Join-Segments -segments $segments | Should -Be $path
	}
}

Describe 'Sanitize segment' -ForEach @(
	@{ Segment = 'foo'; SanitizedSegment = 'foo' }
	@{ Segment = 'foo/'; SanitizedSegment = 'foo' }
	@{ Segment = '/foo'; SanitizedSegment = 'foo' }
	@{ Segment = '/foo/'; SanitizedSegment = 'foo' }
	@{ Segment = 'foo//'; SanitizedSegment = 'foo' }
	@{ Segment = '//foo'; SanitizedSegment = 'foo' }
	@{ Segment = '//foo//'; SanitizedSegment = 'foo' }
	@{ Segment = '\foo'; SanitizedSegment = 'foo' }
	@{ Segment = 'foo\'; SanitizedSegment = 'foo' }
	@{ Segment = '\foo\'; SanitizedSegment = 'foo' }
	@{ Segment = '\\foo'; SanitizedSegment = 'foo' }
	@{ Segment = 'foo\\'; SanitizedSegment = 'foo' }
	@{ Segment = '\\foo\\'; SanitizedSegment = 'foo' }
) {
	It 'Segment is sanitized' {
		Get-SanitizeSegment -Segment $segment | Should -Be $sanitizedSegment
	}
}

Describe 'Documentation' -ForEach @(
	@{ Property = 'Examples' }
) {
	It '<property> should exist' {

	}
}