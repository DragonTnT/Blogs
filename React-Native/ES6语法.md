## ES6语法

1.箭头函数：

```javascript
var f = v => v;
//等价于
var f = function(a){
 return a;
}
f(1);  //1
```

2.this

- 箭头函数体中的 this 对象，是定义函数时的对象，而不是使用函数时的对象;

- 在回调函数中，当需要维护一个this上下文的时候，就可以使用箭头函数;

