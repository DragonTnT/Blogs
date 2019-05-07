### Flutter的安装与使用

---

####先说下安装的顺序：

1.下载开发工具和编辑器：Android Studio，Xcode，VSCode

2.下载Flutter所需要的SDK[这里](<https://flutter.dev/docs/development/tools/sdk/releases#macos>)，我这里下载的是macOS的Stable channel：v1.2.1

3.安装的全部流程参照官方，[这里](<https://flutterchina.club/setup-macos/>)

---

#### 一些需要注意的点：

1.用VSCode打开你的项目，输入指令 Run Flutter Doctor（注：指令快捷键是cmd+shift+p），检查Flutter的配置情况，OUTPUT会输出需要你做的配置。

2.因为被墙的原因，需要配置下环境变量来下载Flutter里所需的工具。

```shell
export PUB_HOSTED_URL=https://pub.flutter-io.cn //国内用户需要设置
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn //国内用户需要设置
export PATH=PATH_TO_FLUTTER_GIT_DIRECTORY/flutter/bin:$PATH  //PATH_TO_FLUTTER_GIT_DIRECTORY为你flutter的路径
```

以上3句直接在Terminal执行的话，只是在当前会话添加了环境变量，关闭Terminal之后不再拥有。因此需要将它们加入到`.bash_profile`文件里作为永久配置。

```
1.cd $HOME    //到你的用户名目录下
2.ls -a  	    //查看是否有.bash_profile，如果没有，则 touch .bash_profile 创建
3.open .bash_profile   //打开文件
4.将前面的3句export加入文件里
5.source $HOME/.bash_profile  //刷新当前终端窗口.
6.env 查看当前所有环境变量，看以上3个环境变量是否被添加
```

3.VSCode打印的`Target of URI doesn't exist 'package:flutter/material.dart'`这一类问题是没有下载到Flutter所需的工具包，在Command Pallette里输入get package，获取工具包。（前提是2里的环境已经配置好了）

4.iOS真机调试时，记得去项目里把Provisioning Profile设置一下

5.出现`Error connecting to the service protocol: HttpException: , uri = http://127.0.0.1:1050/ws`这种错误时，重连真机设备

---

####最后谈谈Flutter

优点：

- 跨平台：已经是这几年移动应用的发展趋势了，并且flutter的布局不仅如此，未来也在PC端也会尝试。
- 热重载：开发者的福音，再也不用把过多的时间花在编译上了
- 自制控件：相比于RN的调用原生控件，Flutter的自制控件在UI的表现上更加顺滑
- Dart语言和Java很像，Android程序员所需要的语言学习成本很小

缺点（或者说是还可以更进一步的）：

- 无可视化布局，这点需要向原生开发看齐
- 不支持热更新，据说之前Flutter团队会在今年支持，可后来又放弃了，主要原因是在iOS上的整体表现比较差，所以Flutter可能还是暂时不会离开WebView。

目前来看，Flutter是谷歌官方力荐，同时开源社区发展迅猛，并且在跨平台上表现良好，有理由对它保持信心。不过鉴于目前还有很多坑未踩完，不建议立即在工作项目中使用它，可以先学习和储备。

------

#### 

