BeforeAll {
	. $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('\tests', '\src')
}



Describe 'Get project root' {
	It 'Project 1' -TestCases @(
		@{ Path = 'C:\projects\project\foo.ps1'; ProjectRoot = 'C:\projects\project' }
		@{ Path = 'C:\projects\project2\foo.ps1'; ProjectRoot = 'C:\projects\project2' }
	) {
		Get-ProjectRoot -Path $Path | Should -Be $ProjectRoot
	}
}

AfterAll {

}