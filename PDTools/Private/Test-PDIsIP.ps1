function Test-PDIsIP
{
	[OutputType([Boolean])]
	param ([string]$IP)
	#Regular Express
	return $IP -match "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
}