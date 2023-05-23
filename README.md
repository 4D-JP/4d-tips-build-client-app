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

専用クライアントをビルドするためには，**スタートアッププロジェクト**を作成することが必要です。ビルドしたクライアントは，通常，起動後すぐにサーバーをIPアドレスまたは公開名で検索し，接続しようとしますが，スタートアッププロジェクトが組み込まれている場合，そのプロジェクトをローカルモードで開きます。データファイルは使用しません。Unlimited Desktopライセンスを組み込めば，データファイルを使用することができます。

#### 通常のビルドクライアント

1. 起動
2. Database/EnginedServer.4DLinkを開く
3. 自動的に指定されたサーバーに接続する

#### スタートアッププロジェクトが組み込まれたビルドクライアント

1. 起動
2. Database/{プロジェクト名}.4DZを開く
3. `OPEN DATABASE`コマンドで任意のサーバーに接続する
