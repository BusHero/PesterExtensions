function Mock-EnvironmentVariable {
	param (
		[parameter(Mandatory = $true, Position = 0)]
		[string]
		$Variable,
		
		[Parameter(Mandatory = $false)]
		[string]
		$Value,

		[Parameter(Mandatory = $false)]
		[System.EnvironmentVariableTarget]
		$Target = [System.EnvironmentVariableTarget]::Process,

		[Parameter(Mandatory = $true, Position = 1)]
		[ScriptBlock]
		$Fixture

	)
	$EnvironmentVariable = "env:${Variable}"

	if (Test-Path -Path $EnvironmentVariable) {
		$OriginalValue = (Get-ChildItem -Path $EnvironmentVariable).Value
		if ($value) {
			Set-Item -Path $EnvironmentVariable -Value $Value
		}
	}
	else {
		New-Item -Path $EnvironmentVariable -Value $Value | Out-Null
	}
	try {
		Invoke-Command -ScriptBlock $Fixture
	}

	catch {
		throw $_
	}

	finally {
		if ($OriginalValue) {
			Set-Item -Path $EnvironmentVariable -Value $OriginalValue
		}
		elseif (Test-Path -Path $EnvironmentVariable) {
			Remove-Item `
				-Path $EnvironmentVariable `
				-Recurse `
				-Force `
				-ErrorAction Stop
		}
	}

	<#
	.PARAMETER Variable
	The environment variable to mock.

	.PARAMETER Value
	The initial value of the mocked environment variable.

	.PARAMETER Fixture
	The code to be executed.

	.PARAMETER Target
	Specifies that user environment variable should also be managed.
	#>
}