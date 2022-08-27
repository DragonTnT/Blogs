# Widget中的Key

widget中的key用于给组件添加标记，从而区分组件。常用于StatefulWidget保留状态，而StatelessWidget因为没有状态，所以不需要key去区分。

例如两个同类型的stateful组件在一个column中排列，都带有计数功能，上面的组件计数为1，下面的组件计数为2。如果直接调换上下两个组件的位置，热重载之后，上面的组件计数为依然为1，下面的组件计数依然为2。这是因为系统判断不出上下两个组件的区别，因此上下交换之后上面组件依然保留为1的状态，下面组件依然保留为2的状态。

要解决这个问题，可以为两个组件添加Key，那么Key与状态相绑定。上下交换并热重载之后，上面组件计数为2，下面组件计数为1。

---

Key由作用域分为LocalKey和GlobalKey，在同一层级进行对比，只需要LocalKey，而全局对比需要GlobalKey。当然，因为Key对比的范围小，所以LocalKey速度比GlobalKey快很多。因此LocalKey能满足需求的情况下，尽量使用LocalKey。



### LocalKey（局部键）: (用于同一层级的widget标识)

而LocalKey根据功能分为：

- ValueKey：通过Value值，进行key是否相等的验证
- ObjectKey：通过对对象的对比，进行key是否相等的验证
- UniqueKey：独一无二的key，它是肯定不和其他key相等的

### GlobalKey:（全局键）：（全局作用域下对Widget进行标识）

功能主要有以下两点：

1.在HotReload下保持状态

2.通过key来寻找该key绑定的widget,context(即element)，state。找到之后还需要通过as进行类型转换进而使用。

```dart
// 定义globalKey
final _globalKey = GlobalKey();
// 将key和widget绑定
Counter(_globalKey)   // Counter为statefulWidget，并且init参数需要传入key
// 通过key去寻找对应Widget的state
final state = (_globalKey.currentState as _CounterState);
```

