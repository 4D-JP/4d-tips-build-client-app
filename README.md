# 4d-tips-build-client-app
汎用クライアントアプリをビルドするには

## Synopsis

4D v11 SQL以降，各種ランタイムが整理され，公式ビルドは4Dと4D Serverだけになりました。

下記のアプリはいずれも「4D」に統合されています。

* 4D Runtime Interpreted
* 4D Client
* 4D Runtime Single User/4D Runtime Classic

通常，クライアント/サーバー版のアプリケーションは[ビルド](https://developer.4d.com/docs/ja/19/Desktop/building/)して配付します。ビルドは「エンジン組み込み」とも呼ばれます。ビルドには，コンパイルしたストラクチャファイルまたはプロジェクト（拡張子`.4DC`または`.4DZ`）を作成するだけではなく，4D Serverまたは4D Volume Desktop（「エンジン」）に組み込んで，独自のアイコンや著作権情報を持つダブルクリックで起動可能なオリジナルのアプリを作成することが含まれます。
