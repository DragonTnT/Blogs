# UIView约束相关

1.contentHuggingPriority  值越大，所占空间越缩紧，默认值为defaultLow

2.contentCompressionResistancePriority  值越小，越不能完整显示，默认值为defaultHigh

3.从xib中拉出的约束`NSLayoutConstraint`，默认为weak，可能会被释放，导致获取的时候出现问题，此时的解决办法为去掉weak