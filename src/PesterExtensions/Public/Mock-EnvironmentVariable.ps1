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
	if (Test-Path -Path "env:${Variable}") {
		$OriginalValue = (Get-ChildItem -Path "env:${Variable}").Value
		if ($value) {
			Set-Item -Path "env:${Variable}" -Value $Value
		}
	}
	else {
		New-Item -Path "env:${Variable}" -Value $Value
	}
	try {
		Invoke-Command -ScriptBlock $Fixture
	}
	catch {
		throw $_
	}
	finally {
		if ($OriginalValue) {
			Set-Item -Path "env:${Variable}" -Value $OriginalValue
		}
		elseif (Test-Path -Path "env:${Variable}") {
			Remove-Item `
				-Path "env:${Variable}" `
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
	#>
}