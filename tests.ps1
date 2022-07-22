param(
	[version]$Version
)

$configuration = New-PesterConfiguration -Hashtable @{
	Run = @{
		Container = @(
			New-PesterContainer -Path 'PesterExtensions.Tests.ps1' -Data @{ Version = $Version };
			New-PesterContainer -Path '.\tests\*\Public';
			New-PesterContainer -Path '.\tests\*\Private';
			New-PesterContainer -Path 'PesterExtensions.*.Tests.ps1'
		)
	}
}

Invoke-Pester -Configuration $configuration