### NSLayoutAnchor生成NSLayoutConstraint

这里有两个Label，aLabel和bLabel。要求：

1.aLabel和bLabel都相对父视图view垂直居中

2.aLabel距父视图左边距为20，bLabel距父视图右边距为20

3.aLabel和bLabel内容间距至少为30

4.aLabel优先显示完整，b显示不完则用省略号

```swift
aLabel.translatesAutoresizingMaskIntoConstraints = false
bLabel.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(aLabel)
view.addSubview(bLabel)
//1.
aLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
bLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//2.
aLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
bLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//3.
bLabel.leadingAnchor.constraint(greaterThanOrEqualTo: aLabel.trailingAnchor, constant: 30).isActive = true
//4.
aLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
bLabel.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
```



- 注意在使用autolayout时，`translatesAutoresizingMaskIntoConstraints`应该设为false
- 在设置约束时，应先将控件加入父视图
- 在3中，至少或至多用`greaterThanOrEqualTo`或者`lessThanOrEqualTo`
- 在4中，aLabel的`ContentHuggingPriority`为252，大于默认的251，因此优先显示aLabel的内容
- 在4中，bLabel的`CompressionResistancePriority`为749，小于默认的750，则内容优先被压缩

---

### 直接生成NSLayoutConstraint

对比上面那种，这种较为麻烦，仅4个约束就如此多篇幅，不推荐使用

```swift
//给iconButton添加四个约束
let right = NSLayoutConstraint(item: iconButton!, attribute: .right, relatedBy: .equal, toItem: subView, attribute: .right, multiplier: 1, constant:
-25)
let centerY = NSLayoutConstraint(item: iconButton!, attribute: .centerY, relatedBy: .equal, toItem: largeTitleLabel, attribute: .centerY, multiplier:
1, constant: -5)
let width = NSLayoutConstraint(item: iconButton!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1,
constant: 35)
let height = NSLayoutConstraint(item: iconButton!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1,
constant: 35)
subView.addConstraints([right,centerY,width,height])
```

---



####以上是在手写约束的情况下。可以看到用了非常多的篇幅，使用Interface Builder或Snapkit能减少很多代码量。





## 