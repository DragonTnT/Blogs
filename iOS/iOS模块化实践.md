# iOS模块化实践

1.本地工程模块化：

- 新建Project，并选择类型为Framework，弹窗中指向原有的workspace
- 在原有workspace中的Link Binary With Libraries中导入新建的Framework
- 注意framework中输出的类如果想被访问，需要加Public或Open关键字
- 在原项目中import该framework，即可使用