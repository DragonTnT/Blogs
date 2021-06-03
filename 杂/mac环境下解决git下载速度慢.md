# mac环境下解决git下载速度慢

1.进入[ip搜索](https://www.ipaddress.com/),分别搜索`github.com`和`github.global.ssl.fastly.net`获得它们对应的id地址`IP1`和`IP2`

2.在/etc/hosts里添加

`IP1` github.com

`IP2` github.global.ssl.fastly.net

3.sudo killall -HUP mDNSResponder     刷新本地DNS缓存

 