# RXSwift常用地方

1.对UI进行绑定，获取UI的变化

如对UISwitch、UITextField、UITextView

```
distributeSwitch.rx.isOn
  .subscribe { [weak self] isOn in
      guard let self = self else { return }
      self.msgDetail.isCron = !isOn
}
  .disposed(by: disposeBag)
```

需要注意的几点：

1.闭包里使用弱引用来规避循环引用

2.对UI控件程序赋值，是不会触发next事件的。例如switch.isOn = true或textfield.text = "123"

因此不要寄希望于通过直接给UI赋值，来触发subscribe中的逻辑