BeforeAll {
	Import-Module -Name PesterExtensions
	. Get-ScriptPath -Path $PSCommandPath
	Remove-Module -Name PesterExtensions
}