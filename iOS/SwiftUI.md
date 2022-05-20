### SwiftUI

关键字：

- @StateObject   用于包裹对象实例的关键字，该对象需要遵循ObservableObject协议
- .environmentObject()    在视图中引入环境对象
- @EnvironmentObject    在子视图中使用环境对象

```swift
@StateObject var model = DataModel()

ContentView()
    .environmentObject(model)	
```

ContentView和它的子节点都可以获取该model。例如在子节点中可以这样获取：

```swift
@EnvironmentObject var model: DataModel 
```

用$建立双向绑定，如：

```swift
Toggle("Enabled", isOn: $model.isEnabled)
```

- @Published

  ObservableObject实例中属性的关键字，被标记的属性发生变化时，使用它的SwiftUI也发生变化

- @State和 @Binding

  用该关键字来建立属性和视图之间的双向绑定关系,都需要用$来使用。区别在于@State只在定义它的body或method里使用，因此对其应该使用private修饰。@binding修饰的属性则来自于同一个信息源，这类似于引用类型，父视图和子视图均引用同一个属性。  @State仅在该视图内使用，@binding是对于多个视图之间共用一个属性。常用的方法是，用@State来赋初值并传递给子视图，子视图用@binding来接收;注意传递@State时，属性使用dolloar符号报告，@binding则不需要