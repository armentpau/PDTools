function Rename-PDLog
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[int]$MaxLogs,
		[Parameter(Mandatory = $true)]
		[string]$ScriptName,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$Path
	)
	
	if ((Test-Path -Path "$($Path)\$($ScriptName)-$($MaxLogs).log"))
	{
		Remove-Item "$($Path)\$($ScriptName)-1.log" -Force
		2 .. $($maxlogs) | foreach-object{
			Rename-Item -path "$($Path)\$($ScriptName)-$($_).log" -NewName "$($Path)\$($ScriptName)-$(([int]$_) - 1).log"
		}
	}
}