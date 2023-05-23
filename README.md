![version](https://img.shields.io/badge/version-19%2B-5682DF)

# 4d-tips-build-client-app
汎用クライアントアプリをビルドするには

## 概要

4D v11 SQL以降，各種ランタイムが整理され，公式ビルドは4Dと4D Serverだけになりました。

下記のアプリはいずれも「4D」に統合されています。

* 4D Runtime Interpreted
* 4D Client
* 4D Runtime Single User/4D Runtime Classic

通常，クライアント/サーバー版のアプリケーションは[ビルド](https://developer.4d.com/docs/ja/19/Desktop/building/)して配付します。ビルドは「エンジン組み込み」とも呼ばれます。ビルドには，コンパイルしたストラクチャファイルまたはプロジェクト（拡張子`.4DC`または`.4DZ`）を作成するだけではなく，4D Serverまたは4D Volume Desktop（「エンジン」）に組み込んで，独自のアイコンや著作権情報を持つダブルクリックで起動可能なオリジナルのアプリを作成することが含まれます。

ビルドはデザインモードの「アプリケーションビルド」メニュー，またはコマンドの[`BUILD APPLICATION`](https://doc.4d.com/4Dv19/4D/19.6/BUILD-APPLICATION.301-6270031.ja.html)で実現できます。当該プラットフォームの開発ライセンス（4D Developer Professionalまたは4D Team Developer Professional）があれば，クライアント/サーバー版のアプリケーションをビルドすることができます。

敢えてアプリケーションをビルドをせず，エンドユーザーに4D.comのダウンロードページから「4D」を入手してもらって，クライアントの代わりに使用することもできますが，そうする理由はほとんどありません。

v18で追加された新しいビルドキーとv15で追加された[OPEN DATABASE](https://doc.4d.com/4Dv19/4D/19.6/OPEN-DATABASE.301-6270040.ja.html)コマンドを活用すれば，起動後すぐにサーバーに接続するのではなく，任意のタイミングでサーバーに接続するようなクライアントをビルドすることができます。

**参考**: [カスタムリモートコネクションダイアログの構築](https://blog.4d.com/ja/build-a-custom-remote-connection-dialog/)

**注記** ビルドしていないサーバーに接続するクライアントをビルドすることはできません。ビルドしていない4D Serverに接続しようとした場合，エラーが返されます。

<img width="660" alt="" src="https://github.com/4D-JP/4d-tips-build-client-app/assets/10509075/3bbaea6d-99f0-477d-a5c3-b86d6910c6f5">

## スタートアッププロジェクト

専用クライアントをビルドするためには，**スタートアッププロジェクト**を作成することが必要です。ビルドしたクライアントは，通常，起動後すぐにサーバーをIPアドレスまたは公開名で検索し，接続しようとしますが，スタートアッププロジェクトが組み込まれている場合，そのプロジェクトをローカルモードで開きます。原則的にデータファイルは使用しません。ただし，Unlimited Desktopライセンスを組み込めば，データファイルを使用することができます（クライアントとデスクトップの**ハイブリッドアプリ**）。

#### 通常のビルドクライアント

1. 起動
2. Database/EnginedServer.4DLinkを開く
3. 自動的に指定されたサーバーに接続する

#### スタートアッププロジェクトが組み込まれたビルドクライアント

1. 起動
2. Database/{スタートアッププロジェクト名}.4DZを開く
3. 任意の処理をする（ファイルのダウンロードや環境のチェックなど）
4. `OPEN DATABASE`コマンドで任意のサーバーに接続する

## サーバーを公開する

新規プロジェクトを作成し，**公開名**や**ポート番号**を設定します。ポート番号を`19813`以外に変更した場合，アプリケーションを再起動します。

<img width="349" alt="" src="https://github.com/4D-JP/4d-tips-build-client-app/assets/10509075/923df586-f069-48e6-961b-1519409e712e">

## スタートアッププロジェクトを作成する

新規プロジェクトを作成し，目的のサーバーに接続するメソッドを *On Startup* に記述します。

```4d
$config:=New object
$config.name:="私のサーバー"
$config.addr:="127.0.0.1"
$config.port:=20000
	
$file:=Folder(fk resources folder).file("link.4dtag")
$link:=$file.getText()
PROCESS 4D TAGS($link; $link; $config)

$file:=Folder(Temporary folder; fk platform path).file("connect.4dlink")
$file.setText($link)
	
OPEN DATABASE($file.platformPath)
```

* link.4dtag

```xml
<?xml version="1.0" encoding="UTF-8"?>
<database_shortcut
  is_remote="true"
  server_database_name="$4dtext($1.name)"
  server_path="$4dtext($1.addr):$4dtext($1.port)" />
```

メソッドを実行して，目的のサーバーに接続できることを確認します。

## スタートアッププロジェクトをコンパイルする

目的のサーバーに接続できることが確認できたら，アプリケーションビルド画面を開き，**コンパイルされたストラクチャ**をビルドします。

<img width="704" alt="" src="https://github.com/4D-JP/4d-tips-build-client-app/assets/10509075/01978e92-e593-4adc-80bc-14add2653c14">

## クライアントをビルドする

ビルド設定には多数のオプションが存在します。処理を簡易にするため，今回は[miyako/4d-class-build-application](https://github.com/miyako/4d-class-build-application)を使用します。

* /SOURCES/Classes/BuildApp.4dm
* /RESOURCES/BuildApp-Template.4DSettings

をプロジェクトにコピーします。

**参考**: ビルド処理を簡易にする別のツールとして[`Build4D`](https://blog.4d.com/ja/build-your-compiled-structure-or-component-with-build4d/)が公開されています。

* ビルドコード

```4d
/*
	
	$startupProjectPath: スタートアッププロジェクトのパス
	$applicationName: クライアントのアプリ名
	$buildDestFolder: 出力先フォルダーパス
	$signingIdentity: コード署名に使用するでベロッパー証明書（Macのみ）
	$volumeDesktopFolder: 4D Volume Desktopの場所
	$iconFile: カスタムアイコンファイルのパス
	$versionString: 任意のバージョン識別子
*/

$startupProjectPath:=Folder(Folder(fk database folder).platformPath; fk platform path)\
.parent.folder("Compiled Database").folder("simple-startup-project").platformPath

$applicationName:="私のクライアント"
$buildDestFolder:=System folder(Desktop)
$signingIdentity:="Developer ID Application: keisuke miyako (Y69CWUC25B)"


If (Is macOS)
	$volumeDesktopFolder:=Folder(fk applications folder).folder("4D v19 R8").folder("4D Volume Desktop.app").platformPath
	$iconFile:=Folder(fk resources folder).file("4DClient.icns").platformPath
Else 
	$volumeDesktopFolder:=Folder(fk applications folder).folder("4D v19 R8").folder("4D Volume Desktop").platformPath
	$iconFile:=Folder(fk resources folder).file("4DClient.ico").platformPath
End if 

$versionString:="1.0.0"

//MARK: ビルド設定

$buildApp:=cs.BuildApp.new(New object)

$buildApp.findLicenses(New collection("4DDP"; "4DOE"))

$buildApp.settings.ArrayExcludedComponentName.Item:=New collection("4D SVG"; "4D Progress"; "4D ViewPro"; "4D NetKit"; "4D WritePro Interface"; "4D Mobile App Server"; "4D Widgets")
$buildApp.settings.ArrayExcludedModuleName.Item:=New collection("CEF"; "MeCab"; "PHP"; "SpellChecker"; "4D Updater")
$buildApp.settings.ServerDataCollection:=False
$buildApp.settings.HideRuntimeExplorerMenuItem:=True
$buildApp.settings.HideDataExplorerMenuItem:=True
$buildApp.settings.BuildApplicationName:=$applicationName
If (Is macOS)
	$buildApp.settings.BuildMacDestFolder:=$buildDestFolder
	$buildApp.settings.SourcesFiles.CS.ClientMacIncludeIt:=True
	$buildApp.settings.SourcesFiles.CS.ClientMacFolderToMac:=$volumeDesktopFolder
	$buildApp.settings.SourcesFiles.CS.ClientMacIconForMacPath:=$iconFile
	$buildApp.settings.SourcesFiles.CS.DatabaseToEmbedInClientMacFolder:=$startupProjectPath
Else 
	$buildApp.settings.BuildWinDestFolder:=$buildDestFolder
	$buildApp.settings.SourcesFiles.CS.ClientWinIncludeIt:=True
	$buildApp.settings.SourcesFiles.CS.ClientWinFolderToWin:=$volumeDesktopFolder
	$buildApp.settings.SourcesFiles.CS.ClientWinIconForWinPath:=$iconFile
	$buildApp.settings.SourcesFiles.CS.DatabaseToEmbedInClientWinFolder:=$startupProjectPath
End if 
$buildApp.settings.SourcesFiles.CS.ServerIncludeIt:=False
$buildApp.settings.SourcesFiles.CS.IsOEM:=False
$buildApp.settings.CS.BuildServerApplication:=False
$buildApp.settings.CS.LastDataPathLookup:="ByAppName"
$buildApp.settings.PackProject:=False
$buildApp.settings.Versioning.Client.ClientVersion:=$versionString
$buildApp.settings.Versioning.Common.CommonVersion:=$versionString
$buildApp.settings.Versioning.RuntimeVL.RuntimeVLVersion:=$versionString
$buildApp.settings.Versioning.Server.ServerVersion:=$versionString
If (Is macOS)
	$buildApp.settings.SignApplication.MacSignature:=True
	$buildApp.settings.SignApplication.MacCertificate:=$signingIdentity
	$buildApp.settings.SignApplication.AdHocSign:=False
End if 

$status:=$buildApp.build()
```

<img width="123" alt="" src="https://github.com/4D-JP/4d-tips-build-client-app/assets/10509075/e60f4d8e-60be-4977-9383-361eb1039245">

**注記** Mac版のクライアントアプリをインターネット経由で配付する場合，さらに公証が必要です。

## 結論

ビルドしたクライアントを起動すると，ビルドしたサーバー（あれば）に接続することが確認できます。この段階では，スタートアッププロジェクトを使用しない，通常のクライアントと変わらない動作ですが，ビルドクライアント起動後の動作を自由にカスタマイズできることがわかります。

## 補足

前述したように，ビルドしたクライアントは，ビルドしたサーバーにしか接続できません。では，ビルドしていないサーバーに接続する汎用的なクライアント（v2004の4D Clientみたいなもの）をビルドすることはできないのかというと，方法がないわけではありません。

スタートアッププロジェクトの項で述べたように，`OPEN DATABASE`コマンドで任意のサーバーに接続することができます。したがって，起動直後にコマンドを実行するようなデスクトップ版アプリをビルドすれば，クライアントのような動作になります。

まず，下記の場所に新規データファイルを作成します。

* /PROJECT/Default Data/Default.4DD

です。

ジャーナルファイルを作成するためにバックアップを実行するよう促されるので，画面の指示に従います。その後，データベース設定を開き，ログファイルの使用を解除します。

<img width="682" alt="" src="https://github.com/4D-JP/4d-tips-build-client-app/assets/10509075/5fba1914-8694-4415-9e16-b5a331cc420c">

ログファイルの有無は

* ストラクチャ定義（`.4DCatalog`）
* データファイル（`.4DD`）

のそれぞれに書き込まれています。ログファイルを使用せずに起動できるデータファイルを作成するためには，当該データファイルを開いているときにデータベース設定でログファイルの使用を解除する必要があります。

本来のデータファイルに戻し，デスクトップ版アプリをビルドします。

```4d
/*
	$applicationName: クライアントのアプリ名
	$buildDestFolder: 出力先フォルダーパス
	$signingIdentity: コード署名に使用するでベロッパー証明書（Macのみ）
	$volumeDesktopFolder: 4D Volume Desktopの場所
	$iconFile: カスタムアイコンファイルのパス
	$versionString: 任意のバージョン識別子
*/

$applicationName:="私のクライアント"
$buildDestFolder:=System folder(Desktop)
$signingIdentity:="Developer ID Application: keisuke miyako (Y69CWUC25B)"


If (Is macOS)
	$volumeDesktopFolder:=Folder(fk applications folder).folder("4D v19 R8").folder("4D Volume Desktop.app").platformPath
	$iconFile:=Folder(fk resources folder).file("4DClient.icns").platformPath
Else 
	$volumeDesktopFolder:=Folder(fk applications folder).folder("4D v19 R8").folder("4D Volume Desktop").platformPath
	$iconFile:=Folder(fk resources folder).file("4DClient.ico").platformPath
End if 

$versionString:="1.0.0"

//MARK: ビルド設定

$buildApp:=cs.BuildApp.new(New object)

$buildApp.findLicenses(New collection("4DDP"; "4UUD"; "4DOE"; "4UOE"))

$buildApp.settings.ArrayExcludedComponentName.Item:=New collection("4D SVG"; "4D Progress"; "4D ViewPro"; "4D NetKit"; "4D WritePro Interface"; "4D Mobile App Server"; "4D Widgets")
$buildApp.settings.ArrayExcludedModuleName.Item:=New collection("CEF"; "MeCab"; "PHP"; "SpellChecker"; "4D Updater")
$buildApp.settings.ServerDataCollection:=False
$buildApp.settings.HideRuntimeExplorerMenuItem:=True
$buildApp.settings.HideDataExplorerMenuItem:=True
$buildApp.settings.BuildApplicationName:=$applicationName
$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLIncludeIt:=True
$buildApp.settings.BuildApplicationSerialized:=True
$buildApp.settings.BuildCompiled:=False
If (Is macOS)
	$buildApp.settings.BuildMacDestFolder:=$buildDestFolder
	$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLMacFolder:=$volumeDesktopFolder
	$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLIconMacPath:=$iconFile
Else 
	$buildApp.settings.BuildWinDestFolder:=$buildDestFolder
	$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLWinFolder:=$volumeDesktopFolder
	$buildApp.settings.SourcesFiles.RuntimeVL.RuntimeVLIconWinPath:=$iconFile
End if 
$buildApp.settings.PackProject:=False
$buildApp.settings.Versioning.RuntimeVL.RuntimeVLVersion:=$versionString
If (Is macOS)
	$buildApp.settings.SignApplication.MacSignature:=True
	$buildApp.settings.SignApplication.MacCertificate:=$signingIdentity
	$buildApp.settings.SignApplication.AdHocSign:=False
End if 

$status:=$buildApp.build()
```

**注記**: デフォルトデータファイルをセットアップすることにより，初回の起動でデータファイルやログファイルの指定や作成を回避することができます。

* [プロジェクトパッケージのビルド > データファイルの管理](https://developer.4d.com/docs/ja/19/Desktop/building/#%E3%83%87%E3%83%BC%E3%82%BF%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%81%AE%E7%AE%A1%E7%90%86)
