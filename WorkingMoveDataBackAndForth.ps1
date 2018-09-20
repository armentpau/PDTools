###OUTPUT (CALLED DEVICE)
#Invoke-WmiMethod -Class win32_process -Name create -ArgumentList 'powershell.exe -command "get-process"' -ComputerName $IP -Credential $Credential -ErrorAction Stop
#wmi action - it can do a script block
$guid = New-Guid
$scriptblock = [scriptblock]{
	function ConvertTo-Base64StringFromObject
	{
		[CmdletBinding()]
		param
		(
			[Parameter(Mandatory = $true,
					   Position = 0)]
			[ValidateNotNullOrEmpty()]
			[object]$object
		)
		return [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes([management.automation.psserializer]::Serialize($object)))
	}
	$pipe = new-object System.IO.Pipes.NamedPipeServerStream "PDDataTransport", 'Out'
	$pipe.WaitForConnection()
	$sw = new-object System.IO.StreamWriter $pipe
	$sw.AutoFlush = $true
	$tempData = Get-Process
	Write-Host $tempData
	$results = ConvertTo-Base64StringFromObject -object $tempData
	Write-Host $results
	$sw.WriteLine("$($results)")
	$sw.Dispose()
	$pipe.Dispose()
}
$byteCommand = [System.Text.Encoding]::Unicode.GetBytes($scriptblock)
$encoded = [convert]::ToBase64String($byteCommand)
$expression = "Invoke-WmiMethod -ComputerName 'localhost' -Class win32_process -Name create -ArgumentList 'powershell.exe -encodedcommand $encoded'"
Invoke-Expression $expression


###CALLING
$pipe = new-object System.IO.Pipes.NamedPipeClientStream '.', "PDDataTransport", 'In'
$pipe.Connect()
$sr = new-object System.IO.StreamReader $pipe
while (($data = $sr.ReadLine()) -ne $null)
{
	Write-Progress -Activity "Reading The Pipeline data"
	$temp = $data
}
$sr.dispose()
$pipe.dispose()

