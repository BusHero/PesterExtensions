BeforeAll {
	Import-Module -Name PesterExtensions
	. "$(Get-ScriptPath -Path $PSCommandPath)"
	Remove-Module -Name PesterExtensions
}

Describe 'Mock an environment variable' {
	BeforeAll {
		$script:environmentVariable = "test$(New-Guid)"
		$script:InitialValue = 'Some value here and there'

	}
	It 'Code is called' {
		$script:environmentVariable = "test$(New-Guid)"
		$script:InitialValue = 'Some value here and there'
		$script:called = $false
		Mock-EnvironmentVariable -Variable $environmentVariable -Value $InitialValue {
			$script:called = $true
		}
		$script:called | Should -BeTrue
	}

	It 'Environment variable is set up' {
		$environmentVariable = "test$(New-Guid)"
		$InitialValue = 'Some value here and there'
		Test-Path -Path $environmentVariable | Should -BeFalse 
		Mock-EnvironmentVariable -Variable $environmentVariable -Value $InitialValue {
			(Get-ChildItem -Path "env:${environmentVariable}").Value | Should -Be $InitialValue
		}
		Test-Path -Path $environmentVariable | Should -BeFalse 
	}

	Describe 'Environment variable is set' {
		BeforeAll {
			$script:environmentVariableName = "test$(New-Guid)"
			$script:environmentVariable = "env:${environmentVariableName}"
			$script:InitialValue = 'Some value here and there'
			$script:UpdatedValue = 'Some updated value'
			New-Item -Path $environmentVariable -Value $InitialValue
		}
		It 'Environment variable is set up' {
			Mock-EnvironmentVariable -Variable $environmentVariableName -Value $UpdatedValue {
				(Get-ChildItem -Path $environmentVariable).Value | Should -Be $UpdatedValue
			}
			(Get-ChildItem -Path $environmentVariable).Value | Should -Be $InitialValue
		}
		AfterAll {
			Remove-Item `
				-Path $environmentVariable `
				-Force `
				-Recurse `
				-ErrorAction Ignore
		}
	}

	Describe 'Restore variable that got destroyed' {
		BeforeAll {
			$script:environmentVariableName = "test$(New-Guid)"
			$script:environmentVariable = "env:${environmentVariableName}"
			$script:InitialValue = 'Some value here and there'
			$script:UpdatedValue = 'Some updated value'
			New-Item -Path $environmentVariable -Value $InitialValue
			Mock-EnvironmentVariable -Variable $environmentVariableName -Value $UpdatedValue {
				Remove-Item -Path $environmentVariable -Recurse -Force -ErrorAction Ignore
			}
		}
		It 'Environment variable is set up' {
			(Get-ChildItem -Path $environmentVariable).Value | Should -Be $InitialValue
		}
		AfterAll {
			Remove-Item `
				-Path $environmentVariable `
				-Force `
				-Recurse `
				-ErrorAction Ignore
		}
	}

	Describe 'Use the original value if value is not set up' {
		BeforeAll {
			$script:environmentVariableName = "test$(New-Guid)"
			$script:environmentVariable = "env:${environmentVariableName}"
			$script:InitialValue = 'Some value here and there'
			New-Item -Path $environmentVariable -Value $InitialValue
		}
		It 'Test' {
			Mock-EnvironmentVariable -Variable $environmentVariableName {
				(Get-ChildItem -Path $environmentVariable).Value | Should -Be $InitialValue
			}
		}
		AfterAll {
			Remove-Item `
				-Path $environmentVariable `
				-Force `
				-Recurse `
				-ErrorAction Ignore
		}
	}

	Describe 'Do not create the variable if no value is specified' {
		BeforeAll {
			$script:environmentVariableName = "test$(New-Guid)"
			$script:environmentVariable = "env:${environmentVariableName}"
			$script:InitialValue = 'Some value here and there'
		}
		It 'Test' {
			Mock-EnvironmentVariable -Variable $environmentVariableName {
				Test-Path -Path $environmentVariable | Should -BeFalse
			}
		}
		AfterAll {
			Remove-Item `
				-Path $environmentVariable `
				-Force `
				-Recurse `
				-ErrorAction Ignore
		}
	}

	Describe 'Initial value should be reasigned' {
		BeforeAll {
			$script:environmentVariableName = "test$(New-Guid)"
			$script:environmentVariable = "env:${environmentVariableName}"
			$script:InitialValue = 'Some value here and there'
			$script:UpdatedValue = 'Some updated value'
			$script:Message = 'Some message here and there'
			New-Item -Path $environmentVariable -Value $InitialValue
		}
		It 'Throw' {
			{ Mock-EnvironmentVariable `
					-Variable $environmentVariableName `
					-Value $UpdatedValue { throw $Message } 
			} | Should -Throw -ExpectedMessage $Message
			(Get-ChildItem -Path $environmentVariable).Value | Should -Be $InitialValue
		}

		AfterAll {
			Remove-Item `
				-Path $environmentVariable `
				-Force `
				-Recurse `
				-ErrorAction Ignore
		}
	}

	Describe 'Created variable should be destroyed' {
		BeforeAll {
			$script:environmentVariableName = "test$(New-Guid)"
			$script:environmentVariable = "env:${environmentVariableName}"
			$script:InitialValue = 'Some value here and there'
			$script:UpdatedValue = 'Some updated value'
			$script:Message = 'Some message here and there'
		}
		It 'Throw' {
			{ Mock-EnvironmentVariable `
					-Variable $environmentVariableName `
					-Value $UpdatedValue { throw $Message } 
			} | Should -Throw -ExpectedMessage $Message
			Test-Path -Path $environmentVariable | Should -BeFalse 
		}

		AfterAll {
			Remove-Item `
				-Path $environmentVariable `
				-Force `
				-Recurse `
				-ErrorAction Ignore
		}
	}
}