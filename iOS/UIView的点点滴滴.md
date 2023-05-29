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



使用xib加载scrollView，取消掉ContentLayoutGuide选中，当往scrollView中添加View时候，因为scrollView的contentSize还不确定，所以除了View的约束外，还应该设置其他约束来得出contentSize。例如一个纵向滑动的scrollView，在上面添加一个视图View在第一行。首先设置View到上、左、右的距离为0，高度为50。这时，确定了View的frame，还需要确定contentSize。所以再为View设置水平居中，以此确定contentSize.width。contentSize.height则靠纵向视图确定，当添加完最后一个纵向视图时，将它和scrollView竖直距离确定，则约束不再报红。

在加入label这一类可能会换行导致高度不确定时，当label在四个方向约束确定，就可以撑开内容。







---

### UITableView

---

##### deleteRows(at:with:):

先将数据源改变，再执行删除动画。当数据源变为空时，使用该方法会报错，此时应使用`reloadData()`。

##### reloadRows(at:with:)

在iOS11以后，刷新列表可能会出现闪动的现象。这里需要将`estimatedRowHeight`,`estimatedSectionHeaderHeight`,`estimatedSectionFooterHeight`都设为0即可消除闪动

##### UITableView.Style

当style为group时，section的header和footer都不会在滑动时停留。此时的tableView会给默认的header和footer的视图和高度。若要设置header为空，则应在heightForHeader中返回0，并且在viewForHeader中返回nil。  

##### 在iOS15以上，UITableView有sectionHeader或sectionFooter时，顶部会出现空白区域

```swift
if #available(iOS 15, *) {
    tableView.sectionHeaderTopPadding = 0
}
```



##### Self-sizing cell

当cell里嵌套tableView这类没有实现`intrinsicContentSize`的视图时，除了需要设置tableView到上下距离，还要设置tableView的高度。可以监听tableView的contentSize，设置它的高度。

当cell因为布局复杂，导致自适应高度失败，可以尝试在cellForRow的方法里，返回cell之前，调用cell.layoutIfNeed。



##### tableHeaderView、tableFooterView

在tableView的tableHeaderView和tableFooterView的高度发生变化时，修改完高度后，还应该将该视图重新赋给tableView。如：

```swift
// mainView是tableView的tableHeaderView
mainView.contentHeightChanged = { [weak self] height in
    guard let self = self else { return }
    self.mainView.frame.size.height = height
    self.tableView.tableHeaderView = self.mainView
}
```



##### 代理heightForHeader、heightForFooter

在header和footer不显示时，应该返回高度赋值`CGFloat.leastNormalMagnitude`而不是0

##### 代理viewForHeader、viewForFooter

在header和footer不显示时，应该返回视图为nil



##### 滑动卡顿

注意是否给有给tableView设置预留的header和footer的高度，应该设为0，然后去代理里设置具体的值

```swift
tableView.estimatedSectionHeaderHeight = 0
tableView.estimatedSectionFooterHeight = 0
```





### UITextfiled

---

##### Text Input Traits

- Correction为No时，去掉联想。
- Spell Checking为No时，去掉拼写检查
- 当需要限制输入类型时，在代理方法`shouldChangeCharactersIn`中做判断
- 当需要限制输入长度时，为textfield添加editingChanged的监听，并对text做substring。
- 当需要以上两点同时发生作用时，KeyboardType应该转为ASCII。

##### 小写转大写

监听textfield的editingChanged

```swift
/// 输入小写转大写
@objc private func editingChanged(textfield: UITextField) {
    guard let text = textfield.text,
          let languague = textfield.textInputMode?.primaryLanguage,
          languague == englishLanguague
    else { return }
    searchTF.text = text.uppercased()
}
```

##### 限制输入长度

监听textfield的editingChanged

```swift
@objc private func textfiledEditingChanged() {
    let text = numberTF.text!
    if text.count > 3 {
        numberTF.text = text.substring(from: 0, to: 2)
    }
}
```

##### attributePlaceholder显示异常

当设置了font，但font显示不正常时，在layoutSubviews里设置就可以了

##### 限制中文的输入长度，但不想输入拼音被截断时用`markedTextRange == nil`来判断

```
merchantNameTF.rx.text
    .subscribe { [weak self] text in
    guard let self = self,
          self.merchantNameTF.markedTextRange == nil,
          var text = text
        else { return }
        if text.count > 6 {
            text = text.substring(from: 0, to: 5)
        }
        self.merchantNameTF.text = text
}
.disposed(by: disposeBag)
```



##### 完成及时搜索功能，及输入文本就开始搜索，但在文字还是拼音的时候，不搜索

```swift
@objc private func textFieldEditingChanged(tf: UITextField) {
      guard let text = tf.text,
            tf.markedTextRange == nil
      else { return }
      if text.isEmpty {
          searchStr = ""
          tableView.reloadData()
      } else {
          searchStr = text
          searchNetwork()
      }
  }
```







### UIButton

---

btn.semanticContentAttribute = .forceRightToLeft  可用以文字和图片的左右位置对调



### UICollectionView

---

1.reloadData不执行cellforitem: 

考虑是否有viewDidLoad未完成的情况下，调用了reloadData，这会导致后续的reloadData无法调用cellforitem。考虑使用：

```
if isViewLoad {
	 collectionView.reloadData()
}
```

2.reloadData后header、footer不更新：

```swift
collectionView.reloadData()
collectionView.collectionViewLayout.invalidateLayout()
```

3.使用selfSizingCell，如果返回的宽高不对，可以在cell中实现

```swift
override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
  self.setNeedsLayout()
  self.layoutIfNeeded()
  let size = self.contentView.systemLayoutSizeFitting(layoutAttributes.size)
  var cellFrame = layoutAttributes.frame
  cellFrame.size.height = size.height
  // 此处的需求为宽度固定为150，高度随内容而撑开
  cellFrame.size.width = 150 
  layoutAttributes.frame = cellFrame
  return layoutAttributes
}
```



### Xib

---

1.直接为xib加载的视图设置frame,可能会出现frame不准确的情况。此时需要将.xib文件中的Autoresizing中的flexiableWidth和flexiableHeight取消选中。即取消弹性视图中的宽高两条线。

2.如果xib加载控制器，需要注意file's owner的customClass需要指定为控制器类型

### instrinsicSize

UILabel、UIImageView、UIButton此类控件会根据本身的内容，而拥有一个内在的size，不设置frame或约束，也能够显示。可对其重写来完成某些功能，例如带有边距的label

### UILabel

1.遇到宽度偏差很小，导致文字显示省略号的情况，直接更改`lineBreakMode`为`byClipping`



### UImageView

UIImageView可以根据本地图片的内容而撑开size，在snapkit中，不用定义对size的约束，而在xib中，可以对UIImageView在设置完位置约束后，会出现instrinsicSize，将其改为placeHolder，设置任意值，就不用再设置宽高的约束，在runtime中，UIImageView会拿到它内容的宽高



### 虚线圆角

1.在给CAShapeLayer设置path的时候，注意用

`UIBezierPath(roundedRect: bounds, cornerRadius: adapter(5))`的方式

2.如果出现layer圆角附近颜色加深，注意设置

```
layer.fillColor = UIColor.clear.cgColor
layer.backgroundColor = UIColor.clear.cgColor
```



### 键盘：

用于TextField，TextView的keyboardType:

- UIKeyboardTypeDecimalPad：数字和小数，常用于输入金额
- UIKeyboardTypeNumberPad：只有数字
- UIKeyboardTypeASCIICapable：字母和数字，常用于输入密码

### UITextView:

textView的高度随内容变化，参考AutoLineBreakTextView
