BeforeAll {
	Import-Module "$PSScriptRoot\..\..\src\PesterExtensions\PesterExtensions.psm1"
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

Describe 'All the important fields are not empty' {
	BeforeAll {
		$ModuleInfo = Test-ModuleManifest -Path "${PSScriptRoot}\..\..\src\PesterExtensions\PesterExtensions.psd1"
	}
	It '<property>' -TestCases @(
		@{Property = 'Path' }
		@{Property = 'Description' }
		@{Property = 'Author' }
		@{Property = 'LicenseUri' }
		@{Property = 'Tags' }
		@{Property = 'Version' }
		@{Property = 'ExportedCmdlets' }
		@{Property = 'ExportedVariables' }
		@{Property = 'ExportedFunctions' }
		@{Property = 'ExportedAliases' }
		@{Property = 'Copyright' }
		@{Property = 'CompanyName' }
		@{Property = 'Guid' }
		@{Property = 'ProjectUri' }
	) {
		$ModuleInfo."$property" | Should -Not -Be $null
	}
}

