function Restore {
	param (
		[hashtable]
		$Backup
	)
	foreach ($variable in $Backup.Keys) {
		foreach ($target in $Backup.$variable.Keys) {
			[Environment]::SetEnvironmentVariable($variable, $Backup.$variable.$target, $target)
		}
	}
}

function Backup {
	param (
		[string[]]
		$Variables,
		
		[EnvironmentVariableTarget[]]
		$Targets,

		[string]
		$value
	)
	$Backup = @{}

	foreach ($variable in $Variables) {
		$VariableBackup = @{}
		foreach ($target in $Targets) {
			$OriginalValue = [Environment]::GetEnvironmentVariable($variable, $target)
			$VariableBackup.Add($target, $OriginalValue)
			if ($Value) {
				[Environment]::SetEnvironmentVariable($variable, $Value, $target)
			}
		}
		$Backup.Add($variable, $VariableBackup)
	}
	
	return $Backup
}


function Mock-EnvironmentVariable {
	param (
		[parameter(Mandatory = $true)]
		[string[]]
		$Variable,
		
		[Parameter(Mandatory = $true)]
		[ScriptBlock]
		$Fixture,

		[Parameter(Mandatory = $false)]
		[string]
		$Value,

		[Parameter(Mandatory = $false)]
		[EnvironmentVariableTarget[]]
		$Targets = @([EnvironmentVariableTarget]::Process)
	)

	$Backup = Backup -Variables $Variable -Targets $Targets -value $Value

	try { Invoke-Command -ScriptBlock $Fixture }
	finally { Restore -Backup $Backup }

	<#
	.PARAMETER Variable
	The environment variable to mock.

	.PARAMETER Value
	The initial value of the mocked environment variable.

	.PARAMETER Fixture
	The code to be executed.

	.PARAMETER Targets
	Specifies that user environment variable should also be managed.
	#>
}