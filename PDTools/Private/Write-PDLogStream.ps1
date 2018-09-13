function Write-PDLogStream
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		$Message,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$Path,
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Information', 'Debug', 'Verbose', 'Error', 'Warning', IgnoreCase = $true)]
		$Level = 'Information',
		[ValidateRange(1, 10000)]
		[int]$MaxRetry = 100,
		[ValidateNotNullOrEmpty()]
		[string]$ComputerName = $($env:computername)
	)
	
	$retryCount = 0
	do
	{
		try
		{
			$outMessage = "[$(get-date -format 'G')]:$($level):$($computerName):`t$($Message)"
			$filestream = New-Object System.IO.FileStream $path, "Append", "Write", "Read" -ErrorAction Stop
			$stream = [System.IO.streamwriter]$filestream
			$stream.writelineasync("$($outmessage)")
			$retryCount = $MaxRetry + 1
		}
		catch
		{
			Write-Warning "There was an error writting to $($Path) with a message of $($Message)."
			$retryCount++
		}
		finally
		{
			$stream.close()
		}
	}
	while ($retryCount -lt $MaxRetry)
}