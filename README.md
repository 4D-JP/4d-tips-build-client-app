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

しかしながら，v18で追加された新しいビルドキーとv15で追加された[OPEN DATABASE](https://doc.4d.com/4Dv19/4D/19.6/OPEN-DATABASE.301-6270040.ja.html)コマンドを活用すれば，ビルドしていないサーバーに接続する専用クライアントを作成することができます。

**参考**: [カスタムリモートコネクションダイアログの構築](https://blog.4d.com/ja/build-a-custom-remote-connection-dialog/)

## スタートアッププロジェクト

専用クライアントをビルドするためには，**スタートアッププロジェクト**を作成することが必要です。ビルドしたクライアントは，通常，起動後すぐにサーバーをIPアドレスまたは公開名で検索し，接続しようとしますが，スタートアッププロジェクトが組み込まれている場合，そのプロジェクトをローカルモードで開きます。原則的にデータファイルは使用しません。ただし，Unlimited Desktopライセンスを組み込めば，データファイルを使用することができます（クライアントとデスクトップの**ハイブリッドアプリ**）。

#### 通常のビルドクライアント

1. 起動
2. Database/EnginedServer.4DLinkを開く
3. 自動的に指定されたサーバーに接続する

#### スタートアッププロジェクトが組み込まれたビルドクライアント

1. 起動
2. Database/{スタートアッププロジェクト名}.4DZを開く
3. `OPEN DATABASE`コマンドで任意のサーバーに接続する

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
