# swift函数派发机制

派发类型：

1.直接派发 

2.函数表派发

3.消息机制派发

##### 先来看看这三种派发方式的原理：

### 直接派发：

直接派发又称为**静态调用**，调用速度最快；本质上是在编译过程中就把函数调用替换成函数实现的地址。

```c
static void just_print_hello(NSString *name) {
    NSLog(@"hello %@",name);
}

just_print_hello(@"bibiking");
```

定义一个C函数，然后直接调用就行了

实际上，无论哪种派发方式，最终都需要知道**函数实现的真正指针**，所以直接派发的速度是最快，但缺点是缺少动态性，无法override。C/C++就是采用的直接派发。

### 函数表派发：

函数表派发是编译型语言实现动态行为最常见的实现方式. 函数表使用了一个数组来存储类声明的每一个函数的指针. 大部分语言把这个称为 "virtual table"(虚函数表), Swift 里称为 "witness table". 每一个类都会维护一个函数表, 里面记录着类所有的函数, 如果父类函数被 override 的话, 表里面只会保存被 override 之后的函数. 一个子类新添加的函数, 都会被插入到这个数组的最后. 运行时会根据这一个表去决定实际要被调用的函数.

```swift
class ParentClass {
    func method1() {}
    func method2() {}
}
class ChildClass: ParentClass {
    override func method2() {}
    func method3() {}
}
```

在这个情况下, 编译器会创建两个函数表, 一个是 `ParentClass` 的, 另一个是 `ChildClass`的:

![函数表派发](/Users/fengbufang/Desktop/Blogs/iOS面试/Swift派发机制/函数表派发.png)

这张表展示了 ParentClass 和 ChildClass 虚数表里 method1, method2, method3 在内存里的布局.

当一个函数被调用时, 会经历下面的几个过程:

1. 读取对象 `0xB00` 的函数表.
2. 读取函数指针的索引. 在这里, `method2` 的索引是1(偏移量), 也就是 `0xB00 + 1`.
3. 跳到 `0x222` (函数指针指向 0x222)

查表是一种简单, 易实现, 而且性能可预知的方式. 然而, 这种派发方式比起直接派发还是慢一点. 从字节码角度来看, 多了两次读和一次跳转, 由此带来了性能的损耗. 另一个慢的原因在于编译器可能会由于函数内执行的任务导致无法优化. (如果函数带有副作用的话)

### 消息机制派发

参考OC消息机制派发。



那么Swift在何时会采用何种派发方式呢？

##### 1.根据类型和拓展决定的派发方式：

![派发方式](/Users/fengbufang/Desktop/Blogs/iOS面试/Swift派发机制/派发方式.png)

- 值类型总是会使用直接派发, 简单易懂
- 而协议和类的 extension 都会使用直接派发
- `NSObject` 的 extension 会使用消息机制进行派发

- `NSObject` 声明作用域里的函数都会使用函数表进行派发.
- 协议里声明的, 并且带有默认实现的函数会使用函数表进行派发

##### 2.关键字指定派发方式：

- `final`：允许类里面的函数使用直接派发. 这个修饰符会让函数失去动态性. 任何函数都可以使用这个修饰符, 就算是 extension 里本来就是直接派发的函数. 这也会让 Objective-C 的运行时获取不到这个函数, 不会生成相应的 selector.
- `dynamic`：`dynamic` 可以让类里面的函数使用消息机制派发. 使用 `dynamic`, 必须导入 `Foundation` 框架, 里面包括了 `NSObject` 和 Objective-C 的运行时. `dynamic` 可以让声明在 extension 里面的函数能够被 override. `dynamic` 可以用在所有 `NSObject` 的子类和 Swift 的原声类.
- `@objc和@nonobjc`:`@objc` 和 `@nonobjc` 显式地声明了一个函数是否能被 Objective-C 的运行时捕获到. 使用 `@objc` 的典型例子就是给 selector 一个命名空间 `@objc(abc_methodName)`, 让这个函数可以被 Objective-C 的运行时调用. `@nonobjc` 会改变派发的方式, 可以用来禁止消息机制派发这个函数, 不让这个函数注册到 Objective-C 的运行时里. 