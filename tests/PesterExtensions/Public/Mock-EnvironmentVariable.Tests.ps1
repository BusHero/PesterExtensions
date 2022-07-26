BeforeAll {
	Import-Module -Name PesterExtensions
	. "$(Get-ScriptPath -Path $PSCommandPath)"
	Remove-Module -Name PesterExtensions
}

Describe 'Mock an environment variable' {
	Describe 'Code is called' {
		BeforeAll {
			$script:EnvironmentVariableName = "test$(New-Guid)"
			$script:InitialValue = 'Some value here and there'
		}
	
		It 'Code is called' {
			$script:called = $false
			Mock-EnvironmentVariable -Variable $environmentVariableName -Value $InitialValue {
				$script:called = $true
			}
			$script:called | Should -BeTrue
		}

		AfterAll {
			[Environment]::SetEnvironmentVariable($EnvironmentVariableName, $null)
		}
	}

	Describe 'Environment variable is set up' {
		BeforeAll {
			$script:environmentVariableName = "test$(New-Guid)"
			$script:InitialValue = 'Some value here and there'
		}
	
		It 'Environment variable is set up' {
			[Environment]::GetEnvironmentVariable($EnvironmentVariableName) | Should -Be $null -Because 'environment variable should be reset'
			Mock-EnvironmentVariable -Variable $environmentVariableName -Value $InitialValue {
				[Environment]::GetEnvironmentVariable($EnvironmentVariableName) | Should -Be $InitialValue
			}
			[Environment]::GetEnvironmentVariable($EnvironmentVariableName) | Should -Be $null -Because 'environment variable should be reset'
		}

		AfterAll {
			[Environment]::SetEnvironmentVariable($EnvironmentVariableName, $null)
		}
	}
		
	Describe 'Environment variable is set' {
		BeforeAll {
			$script:environmentVariableName = "test$(New-Guid)"
			$script:InitialValue = 'Some value here and there'
			$script:UpdatedValue = 'Some updated value'
			[Environment]::SetEnvironmentVariable($environmentVariableName, $InitialValue)
		}
		It 'Environment variable is set up' {
			Mock-EnvironmentVariable -Variable $environmentVariableName -Value $UpdatedValue {
				[Environment]::GetEnvironmentVariable($environmentVariableName) | Should -Be $UpdatedValue
			}
			[Environment]::GetEnvironmentVariable($environmentVariableName) | Should -Be $InitialValue
		}
		AfterAll {
			[Environment]::SetEnvironmentVariable($EnvironmentVariableName, $null)
		}
	}

	Describe 'Restore variable that got destroyed' {
		BeforeAll {
			$script:environmentVariableName = "test$(New-Guid)"
			$script:InitialValue = 'Some value here and there'
			$script:UpdatedValue = 'Some updated value'
			
			[Environment]::SetEnvironmentVariable($environmentVariableName, $InitialValue)
			Mock-EnvironmentVariable -Variable $environmentVariableName -Value $UpdatedValue {
				[Environment]::SetEnvironmentVariable($environmentVariableName, $null)
			}
		}
		It 'Environment variable is set up' {
			[Environment]::GetEnvironmentVariable($environmentVariableName) | Should -Be $InitialValue
		}
		AfterAll {
			[Environment]::SetEnvironmentVariable($EnvironmentVariableName, $null)
		}
	}

	Describe 'Use the original value if value is not set up' {
		BeforeAll {
			$script:environmentVariableName = "test$(New-Guid)"
			$script:environmentVariable = "env:${environmentVariableName}"
			$script:InitialValue = 'Some value here and there'

			[Environment]::SetEnvironmentVariable($environmentVariableName, $InitialValue)
		}
		It 'Test' {
			Mock-EnvironmentVariable -Variable $environmentVariableName {
				[Environment]::GetEnvironmentVariable($environmentVariableName) | Should -Be $InitialValue
			}
		}
		AfterAll {
			[Environment]::SetEnvironmentVariable($EnvironmentVariableName, $null)
		}
	}

	Describe 'Do not create the variable if no value is specified' {
		BeforeAll {
			$script:environmentVariableName = "test$(New-Guid)"
		}
		It 'Test' {
			Mock-EnvironmentVariable -Variable $environmentVariableName {
				[Environment]::GetEnvironmentVariable($environmentVariableName) | Should -Be $null
			}
		}
		AfterAll {
			[Environment]::SetEnvironmentVariable($EnvironmentVariableName, $null)
		}
	}

	Describe 'Initial value should be reasigned' {
		BeforeAll {
			$script:environmentVariableName = "test$(New-Guid)"
			$script:InitialValue = 'Some value here and there'
			$script:UpdatedValue = 'Some updated value'
			$script:Message = 'Some message here and there'
			[Environment]::SetEnvironmentVariable($environmentVariableName, $InitialValue)
		}
		It 'Throw' {
			{ Mock-EnvironmentVariable `
					-Variable $environmentVariableName `
					-Value $UpdatedValue { throw $Message } 
			} | Should -Throw -ExpectedMessage $Message
			[Environment]::GetEnvironmentVariable($environmentVariableName) | Should -Be $InitialValue
		}

		AfterAll {
			[Environment]::SetEnvironmentVariable($EnvironmentVariableName, $null)
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
			[Environment]::GetEnvironmentVariable($environmentVariableName) | Should -Be $null
		}

		AfterAll {
			[Environment]::SetEnvironmentVariable($EnvironmentVariableName, $null)
		}
	}

	Describe 'Set up environment variable is cleared up' {
		BeforeAll {
			$environmentVariableName = "test$(New-Guid)"
		}

		It 'Set up environment variable is cleared up' {
			Mock-EnvironmentVariable `
				-Variable $environmentVariableName { 
				New-Item -Path $environmentVariable -Value 'Some value'
			} 
			[Environment]::GetEnvironmentVariable($environmentVariableName) | Should -Be $null
		}

		AfterAll {
			[Environment]::SetEnvironmentVariable($EnvironmentVariableName, $null)
		}
	}
}