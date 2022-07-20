param(
	[int]$RunNumber
)

$configuration = New-PesterConfiguration -Hashtable @{
	Run = @{
		Container = @(
			New-PesterContainer -Path 'PesterExtensions.Tests.ps1' -Data @{ Revision = $RunNumber };
			New-PesterContainer -Path '.\tests\*\Public';
			New-PesterContainer -Path 'PesterExtensions.*.Tests.ps1'
		)
	}
}

Invoke-Pester -Configuration $configuration