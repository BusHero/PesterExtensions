function Check-SemanticVersion {
	param (
		[parameter(Mandatory)]
		[version]
		$current,

		[Parameter(Mandatory)]
		[version]
		$Next
	)
	$major = $current.Major
	$minor = $current.Minor
	$build = $current.Build

	$ValidVersions = @(
		[version]"${major}.${minor}.$(${build} + 1)"
		[version]"${major}.$(${minor} + 1).0"
		[version]"$(${major} + 1).0.0"
	)
	return $ValidVersions -contains $Next
}