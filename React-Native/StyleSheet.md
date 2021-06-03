## StyleSheet

React-Native 编写的应用的样式不是靠css来实现的，而是依赖javascript来为你的应用来添加样式

1.定义

```javascript
import React, { StyleSheet } from "react-native";
const styles = StyleSheet.create({
    base: {
        width: 38,
        height: 38,
    },
    background: {
        backgroundColor: '#222222',
    },
    active: {
        borderWidth: 2,
        borderColor: ‘#ff00ff',
    },
});
```

2.使用

```javascript
<View style={styles.base}></View>
```



#### Flex:

- flex=0的项目占用空间仅为内容所需空间，flex=1的项目会占据其余所有空间；
- ABC3个子控件的flex分别为1，2，3；则他们在主轴的尺寸比为1：2：3

- RN的flex默认主轴为纵轴：**Column**，如果想变为横轴排列则***flexDirection***设为**row**;这与css相反，css默认主轴为横轴；justifyContent为主轴排列方式；alignItems为侧轴排列方式；

