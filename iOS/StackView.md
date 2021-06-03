## StackView

```swift
lazy var stack: UIStackView = {
    let it = UIStackView(arrangedSubviews: [view,label,imageView])
    it.spacing = adapter(8)
    it.axis = .horizontal
    it.alignment = .center
    return it
}()

/// 横向排列。其中View这类视图需要确定宽高，label由文字撑开，不需要，imageView需要高度。
/// 如果stackView在水平方向上与其他宽度不确定的空间有约束（如label），则上面的视图都需要设置宽度.
```

