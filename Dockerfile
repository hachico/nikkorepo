# 1. ベースイメージの指定
# Cloud Runで推奨される軽量なPythonイメージを使用
FROM python:3.12-slim

# 中野さんご提供
# OS環境（rockerはdebianベース）に日本語ロケールを追加し切り替え
RUN apt-get update && apt-get install -y locales && \
    echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen ja_JP.UTF-8 && \
    update-locale LANG=ja_JP.UTF-8

# タイムゾーンを東京に設定
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


# 2. 環境変数の設定 (任意)
# APIキーなどの機密情報を環境変数で渡す
# ENV OPENAI_API_KEY="your_api_key_here"

# 3. 作業ディレクトリの設定
# コンテナ内の /app ディレクトリをアプリの作業場所とする(localhostアクセスするときの場所)
WORKDIR /app

# 4. 依存関係のインストール
# ホストマシンから requirements.txt をコピー
#COPY requirements.txt .  *****************************のちのちactivate

# pipキャッシュを使わずに依存関係をインストール
#RUN pip install --no-cache-dir -r requirements.txt  *****************************のちのちactivate

# 5. アプリケーションコードのコピー
# ホストマシンからすべてのソースコードをコンテナ内の /app にコピー
#COPY . .  *****************************のちのちactivate

# 6. コンテナの公開ポートを定義
# Cloud Runはデフォルトで8080ポートでリクエストを受け付ける
EXPOSE 8080

# 7. コンテナ起動コマンドの定義
# Gunicornを使ってFlaskアプリを起動
# flask_app:app は、flask_app.py ファイル内の app オブジェクトを指す
#CMD ["gunicorn", "--bind", "0.0.0.0:${PORT}", "app:app"]  *****************************本番公開用
# appディレクトリをWebサーバーとして公開
CMD ["python", "-m", "http.server", "8080"]