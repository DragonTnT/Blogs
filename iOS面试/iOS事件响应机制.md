# iOS事件响应机制

原理+实践

https://www.jianshu.com/p/2e074db792ba

https://www.jianshu.com/p/3e53d4d5f293

事件传递：

UIApplication -> UIWindow -> UIView -> initial view，从最底层到最上层。在子视图数组里倒叙遍历（子视图数组的末尾是最后添加的子视图，因此倒叙可以让最上层的响应者最先响应事件），找到合适的视图A，并继续遍历视图A的子视图寻找。直到找不到合适的子视图，那么该视图就是用来处理事件的视图。通过UIView的hitTest方法来传递事件，找到适合来处理事件的View。hitTest方法会调用pointInside来判断触摸点是否在该视图上。

事件响应：先看视图能否响应，不能响应则传递给父视图响应，若还不能响应，则一直往父视图找。如果视图是控制器的View，并且不能响应，则响应传递该视图的ViewController，因为UIViewController继承自UIResponder，也可以响应事件。   具体的响应则是通过UIResponder的TouchesBegin、TouchesMove等4个方法来实现。

