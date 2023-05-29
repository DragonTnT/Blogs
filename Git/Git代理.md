### Git代理

开启：

// 127.0.0.1为本地主机IP地址，7890为代理所使用的端口号，具体端口号可在classX的帮助中查询
git config --global http.proxy http://127.0.0.1:7890   //（）
git config --global https.proxy https://127.0.0.1:7890

git config --global http.sslVerify false



关闭：

git config --global --unset http.proxy
git config --global --unset https.proxy



