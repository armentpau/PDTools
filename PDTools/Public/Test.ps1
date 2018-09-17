function test
{
	#start remote first then local
	#client
	$tempGuid = New-Guid
	$pipe = new-object System.IO.Pipes.NamedPipeClientStream '.', "PrinterData$($tempGuid)", 'In'
	$pipe.Connect()
	$sr = new-object System.IO.StreamReader $pipe
	while (($data = $sr.ReadLine()) -ne $null) { $temp = $data }
	$sr.dispose()
	$pipe.dispose()
	
	
	#remote
	$pipe = new-object System.IO.Pipes.NamedPipeServerStream "PrinterData$($object.guid)", 'Out'
	$pipe.WaitForConnection()
	$sw = new-object System.IO.StreamWriter $pipe
	$sw.AutoFlush = $true
	$sw.WriteLine("$($results)")
	$sw.Dispose()
	$pipe.Dispose()
}
