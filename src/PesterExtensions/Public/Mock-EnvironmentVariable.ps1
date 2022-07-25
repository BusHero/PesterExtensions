function Mock-EnvironmentVariable {
	param (
		[parameter(Mandatory = $true, Position = 0)]
		[string]
		$Variable,

		
		[Parameter(Mandatory = $false)]
		[string]
		$Value,


		[Parameter(Mandatory = $true, Position = 1)]
		[ScriptBlock]
		$Fixture
	)

	<#
	.PARAMETER Variable
	The environment variable to mock.

	.PARAMETER Value
	The initial value of the mocked environment variable.

	.PARAMETER Fixture
	The code to be executed.
	#>
}