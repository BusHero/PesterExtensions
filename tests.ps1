param(
	[int]$RunNumber
)

$container = New-PesterContainer `
	-Path . `
	-Data @{ Revision = $RunNumber }

Invoke-Pester -Container $container