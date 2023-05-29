# UIView约束相关

1.contentHuggingPriority  值越大，所占空间越缩紧，默认值为defaultLow

2.contentCompressionResistancePriority  值越小，越不能完整显示，默认值为defaultHigh

3.从xib中拉出的约束`NSLayoutConstraint`，默认为weak，可能会被释放，导致获取的时候出现问题，此时的解决办法为去掉weak

4.在xib中，如果某个视图的高度，需要通过frame.size.height设置，那么可以为视图拉一条高度的约束，并将该约束的`remove at build time`设为true

5.隐藏一个视图，并不会使该视图和其他视图之间的约束失效。因此在动态调整布局时，隐藏视图之后，可能也需要将和该视图关联的约束失效，才能达到想要的效果。

6.setNeedsLayout是在下一次循环调用layoutSubviews，layoutIfNeeded是立即调用layoutSubviews

7.当对视图的约束进行调整，并要得到调整后的frame，首要考虑在调整约束后，调用layoutIfNeeded，并将获得frame的代码写在layoutSubviews里