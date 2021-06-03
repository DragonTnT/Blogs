### Git代理

开启：

git config --global http.proxy http://127.0.0.1:1087   //（具体代理地址取决于代理设置）
git config --global https.proxy https://127.0.0.1:1087

git config --global http.sslVerify false



关闭：

git config --global --unset http.proxy
git config --global --unset https.proxy



