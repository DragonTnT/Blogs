### UIStoryboard

---

##### 设置static cells:

SB里若直接将视图控制器(非UITableViewController)里的tableView设置`static cells`时，会报错。这里有折中的办法，使用ContainerView。

###### 1.在Storyboard里拖出，UIViewController和UITableViewController

###### 2.在UIViewController里添加ContainerView,并将它的约束设为tableView想要的约束

###### 3.ctrl+点击ContainerView并拖动到UITableViewController上

###### 4.将UITableViewController中的tableView设为static cells

//若想对ContainerView中的视图添加IBOutlet,则需要为ContainerView创建控制器A，并通过原控制器的子控制器获取到A

---

##### SB中的UIScrollView上添加视图时，显示约束冲突

这里的解决方式是不要直接在UIScrollView上添加视图，而是增加一个中间层。

###### 1.先在ScrollView上添加一个UIView

###### 2.将UIView到ScrollView的各边距都设为0

###### 3.把UIView的水平中心和垂直中心约束都设为和父视图相等

###### 4.约束已消失，现在可以在UIView上添加视图了

---

##### 常见错误

invalid mode 'kCFRunLoopCommonModes' provided to CFRunLoopRunSpecific

这一类错误经常是由于Outlet的重命名，或者已删除而没有在代码里删除导致，同时，也可能在代码里已经删除，而在storyboard里未删除。也可能是`open func instantiateViewController(withIdentifier identifier: String) -> UIViewController`中的`indetifier`传错导致

##### 解决方法：

###### 1.在代码里看是否有已删除outlet的残留部分

###### 2.在storyboard里controller的show the connections inspector(即右上角方向按钮)里查看

###### 3.查看手动跳转时，identifier是否填写有误














