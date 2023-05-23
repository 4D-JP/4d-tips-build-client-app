If (Application type:C494=4D Volume desktop:K5:2)
	
	$config:=New object:C1471
	$config.name:="私のサーバー"
	$config.addr:="127.0.0.1"
	$config.port:=20000
	
	$file:=Folder:C1567(fk resources folder:K87:11).file("link.4dtag")
	$link:=$file.getText()
	PROCESS 4D TAGS:C816($link; $link; $config)
	
	$file:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2).file("connect.4dlink")
	$file.setText($link)
	
	OPEN DATABASE:C1321($file.platformPath)
	
End if 