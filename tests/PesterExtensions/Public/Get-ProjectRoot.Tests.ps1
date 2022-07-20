BeforeAll {
	. $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('\tests', '\src')
}



Describe 'Get project root' {
	It '|"<path>" ==> "<projectroot>"|' -TestCases @(
		@{ Path = 'C:\projects\project1\foo.ps1'; ProjectRoot = 'C:\projects\project1' }
		@{ Path = 'C:\projects\project2\foo.ps1'; ProjectRoot = 'C:\projects\project2' }
	) {
		Get-ProjectRoot -Path $Path | Should -Be $ProjectRoot
	}
}

Describe 'Specify projects root name' {
	It '|"<path>" ==> "<projectroot>"|' -TestCases @(
		@{ Path = 'C:\foo\project1\foo.ps1'; ProjectsRootName = 'foo'; ProjectRoot = 'C:\foo\project1' }
		@{ Path = 'C:\bar\project2\foo.ps1'; ProjectsRootName = 'bar'; ProjectRoot = 'C:\bar\project2' }
		@{ Path = 'C:\foo\project2\foo.ps1'; ProjectsRootName = 'foo', 'bar'; ProjectRoot = 'C:\foo\project2' }
		@{ Path = 'C:\bar\project2\foo.ps1'; ProjectsRootName = 'foo', 'bar'; ProjectRoot = 'C:\bar\project2' }
	) {
		Get-ProjectRoot -Path $Path -ProjectsRoot $ProjectsRootName | Should -Be $ProjectRoot
	}
}

AfterAll {

}