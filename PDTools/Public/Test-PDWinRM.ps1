function Test-PDWinRM
{
	[CmdletBinding(DefaultParameterSetName = 'Credential')]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[Alias('name', 'computer')]
		[string]$ComputerName,
		[Parameter(ParameterSetName = 'Credential')]
		[pscredential]$Credential
	)
	
	Begin
	{
		try
		{
			Test-Connection -ComputerName $ComputerName -ErrorAction Stop -Quiet -Count 4
		}
		catch
		{
			throw "Unable to communicate with $($ComputerName)"
		}
	}
	Process
	{
		switch ($PsCmdlet.ParameterSetName)
		{
			'Credential' {
				try
				{
					Invoke-Command -ComputerName $ComputerName -ScriptBlock { get-process } -ErrorAction Stop
					$results = $true
				}
				catch
				{
					$results = $false
				}
			}
			default
			{
				if (Test-PDIsIP -IP $computername)
				{
					throw "The computername $($ComputerName) is an IP address and you must pass a credential to test for WINRM when using an IP address."
				}
				catch
				{
					try
					{
						Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock { get-process } -ErrorAction Stop
						$results = $true
					}
					catch
					{
						$results = $false
					}
				}
			}
		}
	}
	End
	{
		#returns true or false if winrm is available.
		return $results
	}
}