//%attributes = {}
/*
$applicationName: クライアントのアプリ名
$buildDestFolder: 出力先フォルダーパス
$signingIdentity: コード署名に使用するでベロッパー証明書（Macのみ）
$volumeDesktopFolder: 4D Volume Desktopの場所
$iconFile: カスタムアイコンファイルのパス
$versionString: 任意のバージョン識別子
*/

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

$buildApp.findLicenses(New collection:C1472("4DDP"; "4UUD"; "4DOE"; "4UOE"))

$buildApp.settings.ArrayExcludedComponentName.Item:=New collection:C1472("4D SVG"; "4D Progress"; "4D ViewPro"; "4D NetKit"; "4D WritePro Interface"; "4D Mobile App Server"; "4D Widgets")
$buildApp.settings.ArrayExcludedModuleName.Item:=New collection:C1472("CEF"; "MeCab"; "PHP"; "SpellChecker"; "4D Updater")
$buildApp.settings.ServerDataCollection:=False:C215
$buildApp.settings.HideRuntimeExplorerMenuItem:=True:C214
$buildApp.settings.HideDataExplorerMenuItem:=True:C214
$buildApp.settings.BuildApplicationName:=$applicationName
$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLIncludeIt:=True:C214
$buildApp.settings.BuildApplicationSerialized:=True:C214
$buildApp.settings.BuildCompiled:=False:C215
If (Is macOS:C1572)
	$buildApp.settings.BuildMacDestFolder:=$buildDestFolder
	$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLMacFolder:=$volumeDesktopFolder
	$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLIconMacPath:=$iconFile
Else 
	$buildApp.settings.BuildWinDestFolder:=$buildDestFolder
	$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLWinFolder:=$volumeDesktopFolder
	$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLIconWinPath:=$iconFile
End if 
$buildApp.settings.PackProject:=False:C215
$buildApp.settings.Versioning.RuntimeVL.RuntimeVLVersion:=$versionString
If (Is macOS:C1572)
	$buildApp.settings.SignApplication.MacSignature:=True:C214
	$buildApp.settings.SignApplication.MacCertificate:=$signingIdentity
	$buildApp.settings.SignApplication.AdHocSign:=False:C215
End if 

$status:=$buildApp.build()