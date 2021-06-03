### UIView

---

### required init?(coder aDecoder: NSCoder)

在我们重写一个UIView或者UIViewController的init方法时,Xcode总会提醒我们重写上面这个方法。原因是以下两个：

- 直接原因：父类的该init方法带有required关键字，该关键字会要求子类在重写父类init方法时，必须要重写该方法

- 根本原因：为什么必须要重写该方法？因为UIView和UIViewController实例化有两种方法。1.代码 2.storyboard或xib

  。在使用storyboard/xib构建，将outlet/outaction拖入代码中时，Interface Builder需要对它们进行序列化,并缓存在磁盘上，当需要使用时，再进行反序列化，那么我们需要对其传入序列化和反序列化所需要的`NSCoder`。因此，如果不确定initWithFrame和initWithCoder哪个会被调用(即不清楚会使用代码实例化还是通过Interface Builder实例化)，这两个方法都应该重写。



##### 坐标转换：

```swift
func convert(_ point: CGPoint, to view: UIView?) -> CGPoint
```

将调用者视图的里的point坐标，转化为toView视图里的坐标。比较常用的如，获取TableView中cell在控制器视图里的坐标。

##### 显示模式：contentMode

- `scaleAspectFill`：等比例填满(最常用，配合`layer.maskToBounds` )可使得UIImageView填满，且不被拉伸。
- `scaleToFill`：拉伸填满
- `scaleAspectFit`：等比例显示全图``
- `center`，`top` 等显示了位置

##### 部分圆角：

```swift
let view = UIView()
        view.backgroundColor = .blue
        view.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
let maskPath = UIBezierPath(roundedRect: view.bounds,
                                    byRoundingCorners: [.topLeft,.topRight],
                                    cornerRadii: CGSize(width: 8.0, height: 0.0))
let maskLayer = CAShapeLayer()
maskLayer.path = maskPath.cgPath        
view.layer.mask = maskLayer
```

用贝塞尔曲线画出view的轨迹

---



### UIScrollView

---

##### contentSize:

该属性比frame大时，scrollView才能滑动。通过IB或Storyboard布局时，注意在controller的`viewDidLayoutSubviews`里对`contentSize`赋值。



##### 去掉屏幕顶部为scrollView预留的空间

```swift
if #available(iOS 11.0, *) {
    scrollView.contentInsetAdjustmentBehavior = .never
} else {
    automaticallyAdjustsScrollViewInsets = false
}
```



---

### UITableView

---

##### deleteRows(at:with:):

先将数据源改变，再执行删除动画。当数据源变为空时，使用该方法会报错，此时应使用`reloadData()`。

##### reloadRows(at:with:)

在iOS11以后，刷新列表可能会出现闪动的现象。这里需要将`estimatedRowHeight`,`estimatedSectionHeaderHeight`,`estimatedSectionFooterHeight`都设为0即可消除闪动

##### UITableView.Style

当style为group时，section的header和footer都不会在滑动时停留。此时的tableView会给默认的header和footer的视图和高度。若要设置header为空，则应在heightForHeader中返回0，并且在viewForHeader中返回nil

##### Self-sizing cell

当cell里嵌套tableView这类没有实现`intrinsicContentSize`的视图时，除了需要设置tableView到上下距离，还要设置tableView的高度。可以监听tableView的contentSize，设置它的高度。

当cell因为布局复杂，导致自适应高度失败，可以尝试在cellForRow的方法里，返回cell之前，调用cell.layoutIfNeed。

### UITextfiled

---

##### Text Input Traits

- Correction为No时，去掉联想。
- Spell Checking为No时，去掉拼写检查
- 当需要限制输入类型时，在代理方法`shouldChangeCharactersIn`中做判断
- 当需要限制输入长度时，为textfield添加editingChanged的监听，并对text做substring。
- 当需要以上两点同时发生作用时，KeyboardType应该转为ASCII。



### UIButton

---

btn.semanticContentAttribute = .forceRightToLeft  可用以文字和图片的左右位置对调

