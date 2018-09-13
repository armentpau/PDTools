function Remove-PDLogFile
{
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$ScriptName,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$Path
	)
	
	foreach ($item in Get-ChildItem "$($Path)\$($ScriptName)-[0-9]*.log")
	{
		Remove-Item $item.FullName -Force
	}
}