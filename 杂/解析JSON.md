# JSON相关

###解析JSON：

1.用Alamofire的以下方法，是可以打印出JSON字符串，并直接在网站上解析的

```
.responseString(completionHandler: { (string) in
    print(string)
})
```

2.正确的JSON格式：

- 不能由=
- key必须要有""
- key-value之间用 , 分隔，而不能用 ;



###制作JSON:

在调试阶段，如果想运行直接定位到该页面，那么要提供该页面需要的假数据，因此需要制作JSON。

1.首先将需要的数据通过请求打印出来

2.在json网站里转义为json格式

3.加上双引号，即可在代码里使用

4.可直接通过Handyjson将字符串转化为对象模型