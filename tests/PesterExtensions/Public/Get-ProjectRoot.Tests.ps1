BeforeAll {
	$foo = $PSCommandPath.Replace('.Tests.ps1', '.ps1').Replace('\tests', '\src')
	. $foo
}



Describe 'Get project root' {
	It 'Projects' {
		Get-ProjectRoot -Path 'C:\projects\project\foo.ps1' | Should -Be 'C:\projects\project'
	}
}

AfterAll {

}