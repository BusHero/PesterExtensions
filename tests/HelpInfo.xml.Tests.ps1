Describe 'asd' -Skip {
	BeforeAll {
		$HelpPath = 'C:\Users\petru.cervac\projects\powershell\pester.extenssions\helpinfo.xml'
		$SchemaPath = 'C:\Users\petru.cervac\projects\powershell\pester.extenssions\resources\schemas\HelpInfo.xsd'
	}
	It '<HelpPath> is a valid xml' {
		Test-Xml -Path $HelpPath -SchemaPath $SchemaPath | Should -BeTrue -Because 'File has the schema'
	}
}