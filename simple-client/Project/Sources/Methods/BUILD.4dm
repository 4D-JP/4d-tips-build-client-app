//%attributes = {}
/*

$startupProjectPath: スタートアッププロジェクトのパス
$applicationName: クライアントのアプリ名
$buildDestFolder: 出力先フォルダーパス
$signingIdentity: コード署名に使用するでベロッパー証明書（Macのみ）
$volumeDesktopFolder: 4D Volume Desktopの場所
$iconFile: カスタムアイコンファイルのパス
$versionString: 任意のバージョン識別子
*/

$startupProjectPath:=Folder:C1567(Folder:C1567(fk database folder:K87:14).platformPath; fk platform path:K87:2)\
.parent.folder("Compiled Database").folder("simple-startup-project").platformPath

$applicationName:="私のクライアント"
$buildDestFolder:=System folder:C487(Desktop:K41:16)
$signingIdentity:="Developer ID Application: keisuke miyako (Y69CWUC25B)"


If (Is macOS:C1572)
	$volumeDesktopFolder:=Folder:C1567(fk applications folder:K87:20).folder("4D v19 R8").folder("4D Volume Desktop.app").platformPath
	$iconFile:=Folder:C1567(fk resources folder:K87:11).file("4DClient.icns").platformPath
Else 
	$volumeDesktopFolder:=Folder:C1567(fk applications folder:K87:20).folder("4D v19 R8").folder("4D Volume Desktop").platformPath
	$iconFile:=Folder:C1567(fk resources folder:K87:11).file("4DClient.ico").platformPath
End if 

$versionString:="1.0.0"

//MARK: ビルド設定

$buildApp:=cs:C1710.BuildApp.new(New object:C1471)

$buildApp.findLicenses(New collection:C1472("4DDP"; "4DOE"))

$buildApp.settings.ArrayExcludedComponentName.Item:=New collection:C1472("4D SVG"; "4D Progress"; "4D ViewPro"; "4D NetKit"; "4D WritePro Interface"; "4D Mobile App Server"; "4D Widgets")
$buildApp.settings.ArrayExcludedModuleName.Item:=New collection:C1472("CEF"; "MeCab"; "PHP"; "SpellChecker"; "4D Updater")
$buildApp.settings.ServerDataCollection:=False:C215
$buildApp.settings.HideRuntimeExplorerMenuItem:=True:C214
$buildApp.settings.HideDataExplorerMenuItem:=True:C214
$buildApp.settings.BuildApplicationName:=$applicationName
If (Is macOS:C1572)
	$buildApp.settings.BuildMacDestFolder:=$buildDestFolder
	$buildApp.settings.SourcesFiles.CS.ClientMacIncludeIt:=True:C214
	$buildApp.settings.SourcesFiles.CS.ClientMacFolderToMac:=$volumeDesktopFolder
	$buildApp.settings.SourcesFiles.CS.ClientMacIconForMacPath:=$iconFile
	$buildApp.settings.SourcesFiles.CS.DatabaseToEmbedInClientMacFolder:=$startupProjectPath
Else 
	$buildApp.settings.BuildWinDestFolder:=$buildDestFolder
	$buildApp.settings.SourcesFiles.CS.ClientWinIncludeIt:=True:C214
	$buildApp.settings.SourcesFiles.CS.ClientWinFolderToWin:=$volumeDesktopFolder
	$buildApp.settings.SourcesFiles.CS.ClientWinIconForWinPath:=$iconFile
	$buildApp.settings.SourcesFiles.CS.DatabaseToEmbedInClientWinFolder:=$startupProjectPath
End if 
$buildApp.settings.SourcesFiles.CS.ServerIncludeIt:=False:C215
$buildApp.settings.SourcesFiles.CS.IsOEM:=False:C215
$buildApp.settings.CS.BuildServerApplication:=False:C215
$buildApp.settings.CS.LastDataPathLookup:="ByAppName"
$buildApp.settings.PackProject:=False:C215
$buildApp.settings.Versioning.Client.ClientVersion:=$versionString
$buildApp.settings.Versioning.Common.CommonVersion:=$versionString
$buildApp.settings.Versioning.RuntimeVL.RuntimeVLVersion:=$versionString
$buildApp.settings.Versioning.Server.ServerVersion:=$versionString
If (Is macOS:C1572)
	$buildApp.settings.SignApplication.MacSignature:=True:C214
	$buildApp.settings.SignApplication.MacCertificate:=$signingIdentity
	$buildApp.settings.SignApplication.AdHocSign:=False:C215
End if 

$status:=$buildApp.build()