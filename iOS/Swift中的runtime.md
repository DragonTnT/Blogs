## Swift开发中关于runtime的使用

---

做过iOS开发的同学都知道，runtime是OC这门动态语言的一大特性。我们为分类添加属性，或者hook某个方法都会用到runtime。因为运行时特性，OC也被认为是一门`动态语言`。

而Swift作为一门`静态语言`，它的类型判断和函数调用在编译时已经决定。那么，本文将介绍为何要在Swift中使用runtime，以及如何使用。

---

#### 获取类的所有属性和方法

```swift
class RuntimeHelper {
    //获取所有属性
    class func getAllIvars<T>(from type: T.Type) {
        var count: UInt32 = 0
        let ivars = class_copyIvarList(type as? AnyClass, &count)
        for index in 0..<count {
            guard let ivar = ivars?[Int(index)] else { continue }
            guard let namePointer = ivar_getName(ivar) else { continue }
            guard let name = String.init(utf8String: namePointer) else { continue }
            print("ivar_name: \(name)")
        }
    }
    //获取所有方法
    class func getAllMethods<T>(from type: T.Type) {
        var count: UInt32 = 0
        let methods = class_copyMethodList(type as? AnyClass, &count)
        for index in 0..<count {
            guard let method = methods?[Int(index)] else { continue }
            let selector = method_getName(method)
            let name = NSStringFromSelector(selector)
            print("method_name: \(name)")
        }
    }
}
```

这里封装了两个类方法，用于获取一个类的所有属于和方法。

```swift
//获取UIView的所有属性
RuntimeHelper.getAllIvars(from: UIView.self)
```

---

#### 为类添加关联属性

为一个类增加方法，我们很容易想到在extension中添加。那么添加属性，我们自然也会想要在extension中实现。

但extension中是不能包含存储属性的，因此我们必须使用计算属性，那么为了避免在get方法里每次重新生成，我们需要使用到runtime。

例如为UIViewController增加一个名为loading的加载视图

```swift
extension UIViewController {
    
    private struct AssociateKeys {
        static var loadingKey = "UIViewController+Extension+Loading"
    }
    //动画视图
    var loading: LOTAnimationView? {
        get {
            return objc_getAssociatedObject(self, &AssociateKeys.loadingKey) as? LOTAnimationView
        }
        set {
            objc_setAssociatedObject(self, &AssociateKeys.loadingKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }  
      //显示动画
    func showUtimesLoading() {
        if self.loading == nil {
            loading = LOTAnimationView(name: "loading_bubble")
            loading!.frame.size = CGSize(width: 100, height: 100)
            loading!.center = self.view.center
        }
        self.view.addSubview(self.loading!)
        self.loading!.play()
    }
    
    //移除动画
    func hideUtimeLoading(){
        if let loading = self.loading {
            loading.removeFromSuperview()
        }
    }
}
```

我们定义一个指针指向loading,并通过objc_getAssociatedObject和objc_setAssociatedObject实现该关联属性的get和set方法。当在某一个控制器需要显示动画时，直接调用showUtimesLoading，当要移除动画时，调用hideUtimeLoading

------

再看一个例子，试想我们要给一个UIView添加点击事件，要做哪些步骤呢？

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    let myView = UIView()
    let ges = UITapGestureRecognizer(target: self, action: #selector(tapMyView))
    myView.addGestureRecognizer(ges)
}
@objc func tapMyView() {
    print("tap my view")
}
```

代码很简单，可如果每次都要定义手势，定义方法，添加手势，实在是有些麻烦。并且有时候在代码层面，我们只想关注点击myView，发生了什么，不想关注方法和手势的绑定。如果能用闭包的方式实现，例如下面这样最好不过

```swift
myView.setTapActionWithClosure {
    print("tap my view")
}
```

那么，这就需要runtime的使用了。

先直接上代码：(建议直接将下面一段扔到项目里实验)

```swift
extension UIView {
    // 定义手势和闭包关联的Key
    private struct AssociateKeys {
        static var gestureKey = "UIView+Extension+gestureKey"
        static var closureKey = "UIView+Extension+closureKey"
    }
    // 为view添加点击事件
    func setTapActionWithClosure(_ closure: @escaping ()->()) {
        var gesture = objc_getAssociatedObject(self, &AssociateKeys.gestureKey)
        if gesture == nil {
            gesture = UITapGestureRecognizer(target: self, action: #selector(handleActionForTapGesture(_:)))
            addGestureRecognizer(gesture as! UIGestureRecognizer)
            isUserInteractionEnabled = true
            objc_setAssociatedObject(self, &AssociateKeys.gestureKey, gesture, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        objc_setAssociatedObject(self, &AssociateKeys.closureKey, closure, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }
    // 点击手势实际调用的函数
    @objc private func handleActionForTapGesture(_ gesture: UITapGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.recognized {
            let obj = objc_getAssociatedObject(self, &AssociateKeys.closureKey)
            if let action = obj as? ()->() {
                action()
            }
        }
    }
}
```

在setTapActionWithClosure的实现中可以看到：

1.我们通过objc_getAssociatedObject获取与view相关联的手势

2.判断若手势为空，则新建手势，并绑定给view，手势的点击事件为handleActionForTapGesture。再通过objc_setAssociatedObject将该手势和该view关联起来

3.将事件闭包和该view关联起来

而从handleActionForTapGesture的实现可以看到，点击事件实际上是调用在3中和view关联的闭包

---

#### 和OC中使用有什么不同？

- 不需要导入#import <objc/runtime.h>，可直接调用objc_getAssociatedObject等方法
- 为类动态添加方法，OC在分类中实现，Swift在extension中实现(添加属性也是如此)
- OC对Key的定义多用常量或_cmd,而Swift常用私有结构体的静态变量

------

#### 还有那些使用方式？

runtime的另一大功能：method_swizzling。

如果想对系统的方法进行hook，例如替换掉系统viewwillappear，按照OC的做法，我们会在+load或+initialize进行方法的交换。因为Swift里无法调用+load或+initialize,因此建议method_swizzling的功能用OC完成。程序会在启动时，执行这些方法的交换。

### 结论：

Swift作为一门静态语言，拥有比OC更加安全的机制。但在很多时候，为了开发方便，更为了某些特殊功能(例如对于系统方法的替换)，我们需要用OC的特性，Runtime来实现。