BeforeAll {
	Import-Module -Name PesterExtensions -DisableNameChecking
	. "$(Get-ScriptPath -Path $PSCommandPath -Extension Script)"
	Remove-Module -Name PesterExtensions
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