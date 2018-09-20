
Invoke-WmiMethod -Class win32_process -Name create -ArgumentList 'powershell.exe -command "get-process"' -ComputerName $IP -Credential $Credential -ErrorAction Stop
#wmi action - it can do a script block
$guid = New-Guid
$scriptblock = {
	$pipe = new-object System.IO.Pipes.NamedPipeServerStream "DataTransport$($using:guid)", 'Out'
	$pipe.WaitForConnection()
	$sw = new-object System.IO.StreamWriter $pipe
	$sw.AutoFlush = $true
	$results = $psitem.tostring()
	$sw.WriteLine("$($results)")
	$sw.Dispose()
	$pipe.Dispose()
}
$expression = "Invoke-WmiMethod -ComputerName 'localhost' -Class win32_process -Name create -ArgumentList 'powershell.exe -command $scriptblock'"