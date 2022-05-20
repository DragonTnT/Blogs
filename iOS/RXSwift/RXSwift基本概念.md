# RXSwift



### Observable:

事件序列，可通过订阅它，接受到`next`,`error`,`complete`事件，常用的init参数有`just`,`of`,`from`。

```swift
let bag = DisposeBag()
let obr = Observable.of(1,2,3)

/// 这里有两种订阅方式
//1.处理事件
obr
	.subscribe { event in
    print(event)
	}
	.disposed(by: bag)
//2.处理事件的具体类型
observable
  .subscribe(onNext: { element in
      print(element)
  }, onCompleted: { 
      print("completed")
  }, onDisposed: { 
      print("disposed")
  }).disposed(by: bag)

///打印得到：
next(1)
next(2)
next(3)
completed

```



### Subject:

Subject和Observable的区别在于，

1.Obervable只提供可以被订阅的序列，将事件发送给订阅者；而Subject除此之外还可以主动接收事件，再发送给订阅者。

2.Observable将序列元素发送完成后，会触发complete事件。而Subject需要主动发送`onCompleted()`事件。



这里先做一些基础定义，在后面的代码片段中不再重复引入

```swift
enum MyError: Error {
    case anError
}

func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event)
}

let bag = DisposeBag()
```



### （subject的主要表现是针对元素而不是事件，以下所说的元素都是next()事件中的元素，不包含complete事件和error事件。一旦出现complete或error事件导致它们终结，它们的行为也会变得不一样）

- #### PublishSubject

  可以不需要初始值来进行初始化（也就是可以为空），并且它只会向订阅者发送在订阅之后才接收到的元素。

```swift
let subject = PublishSubject<Int>()
subject.onNext(1)

subject.subscribe { print(label: "PS)", event: $0) }
    .disposed(by: bag)

subject.onNext(2)
subject.subscribe { print(label: "PS2)", event: $0) }
    .disposed(by: bag)

subject.onNext(3)

/// 打印如下：
PS) 2
PS) 3
PS2) 3
```



- #### behaviorSubject

  一个会向每次订阅发出最近接收到的一个元素的观察者，所以初始化一个`BehaviorSubject`一定要有一个初始值，以便订阅者能接受到最近的一个元素。

```swift
subject
    .subscribe { print(label: "BS)", event: $0) }            //BS) 1
    .disposed(by: bag)

subject.onNext(2)                                            //BS) 2

subject
    .subscribe { print(label: "BS2)", event: $0) }           //BS2) 2
    .disposed(by: bag)

subject.onNext(3)

/// 打印如下
BS) 1
BS) 2
BS2) 2
BS) 3
BS2) 3
```



- #### ReplaySubject

   会向每次订阅发送一系列最近元素的观察者。`ReplaySubject`会自带一个缓冲区，所以每次初始化的时候需要赋给它一个缓冲区大小。每次它接收到新的元素，都会先存放到自己的缓冲区里，按缓冲区大小来存放指定数量的元素（实际上`BehaviorSubject`就是一个缓冲区大小为1的`ReplaySubject`），然后在每次订阅发生的时候，则向订阅者发送缓冲区内的所有元素，然后才发送新接收到的元素。给出一个缓冲区大小为2的`ReplaySubject`的示意图：

```swift
let subject = ReplaySubject<Int>.create(bufferSize: 2)

subject.onNext(1)
subject.onNext(2)

subject
    .subscribe { print(label: "RS)", event: $0) }      //RS) 1
    .disposed(by: bag)                     //RS) 2

subject.onNext(3)                                     //RS) 3

subject
    .subscribe { print(label: "RS2)", event: $0) }    //RS2) 2
    .disposed(by: bag)   
    
/// 打印结果
RS) 1
RS) 2
RS) 3
RS2) 2
RS2) 3
```



- ### AsyncSubject

**AsyncSubject** 将在源 `Observable` 产生完成事件后，发出最后一个元素（仅仅只有最后一个元素），如果源 `Observable` 没有发出任何元素，只有一个完成事件。那 **AsyncSubject** 也只有一个完成事件。

```swift
let subject = AsyncSubject<String>()

subject
  .subscribe { print(label: "Subscription: 1 Event:", event: $0) }
  .disposed(by: bag)

subject.onNext("🐶")
subject.onNext("🐱")
subject.onNext("🐹")
subject.onCompleted()

/// 打印结果
Subscription: 1 Event: 🐹
Subscription: 1 Event: Optional(completed)
```







- ### Variable （已弃用）

通过设置value值，来发送next事件





### Subjects是如何面对`completed`和`error`事件的？那`dispose()`呢？

详情见第二篇参考文章。



#### Subject使用场景：

`PublishSubject`：总是发出最新的信息，你可以在你仅仅需要用到新数据的地方使用它，并且在你订阅的时候，如果没有新的信息，它将不会回调，在利用它来和界面绑定的时候，你得有一个默认的字段放在你界面上，以免界面上什么都没有。

`BehaviorSubject`：除了发出新的信息，还会首先发出最近接收到的最后一个元素。这里我们可以以微信（没有收广告费的）举个例子，譬如微信首页的tableview的cell里会显示最近的一条信息，而在这你就可以通过`BehaviorSubject`来订阅，从而用这条最近的信息作展示，而不需要等到新的信息到来，才做展示。

`ReplaySubject`：可是如果你现在订阅，却要获取最近的一批数据——譬如朋友圈，那该怎么办？显然只能依赖于`ReplaySubject`了吧？



### DisposeBag

用于回收订阅，释放资源。可以将其定义类的属性，使用`.disposed(by: bag)`，当类释放时，该属性里包含的资源也会被释放。当调用`.dispose`时候，则是直接回收资源。



### 参考文章：

1.https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/rxswift_core/observable_and_observer/async_subject.html

2.https://www.jianshu.com/p/6ce9cae4f410

