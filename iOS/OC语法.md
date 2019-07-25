# OC语法

---

### 一、关键字

####*static*

- 修饰局部变量时，变量只初始化一次，也仅指向同一份内存。常用于单例。
- 修饰全局变量时，变量仅在当前文件可见。常用于修饰仅在当前文件所使用的变量

####*extern*

- 用于访问全局变量

  ```objective-c
  // in .m
  int kScreenHeight = 100
  // in another .m
  extern int kScreenHeight;
  ```

  

- 用于定义全局变量

  ```objective-c
  //使用`UIKIT_EXTERN`，并将头文件导入pch。
  //in .h
  UIKIT_EXTERN NSString *const Userdefault_ServerStyle;
  //in .m
  NSString *const Userdefault_ServerStyle = @"utimes_server_style";
  ```

  

#### *__block*

- 修饰需要在block中修改的变量

