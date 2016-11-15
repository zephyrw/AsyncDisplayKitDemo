# AsyncDisplayKitDemo
## 简介


在使用本Demo前可以参考我翻译的官网的部分指导教程：https://anye3210.github.io ，了解有关AsyncDisplayKit的要点。

本Demo参考了官方的gram的架构方式，为了综合使用各种node，在官方的基础上增加了布局的复杂度，界面外观参考的500px，数据请求也是使用的500px的Api；

本Demo主要是基于tableNode，与UIKit中的tableView类似。

在Demo中主要分为两部分：ASDK部分和UIKit部分，ASDK是基于AsyncDisplayKit框架，实现异步布局界面，UIKit使用的是主线程布局。
## 数据加载方式
### 相同点

为保证可以横向对比，数据的加载方式基本相同：首先在页面初始化时，加载4个cell的数据(实际展示的时候最多显示两个出来），4个cell数据加载完成再开始加载更多的数据(20个）。这个方式实现了下拉无限刷新，避免了下拉到底部等待刷新的操作。

### 不同点

AsyncDisplayKit 可以在 `willBeginBatchFetchWithContext` 方法中进行自定义预加载，在UIKit中为了实现类似效果，使用了ScrollView的代理监控滚动，实现数据的预加载。

注：
AsyncDisplayKit 中有 `ASNetworkImageNode` ，用于网络图片的管理，只需要给该 `node` 赋URL值即可，如果要对请求的图片进行更改后再显示，可以实现 `imageModificationBlock` 返回处理后的图片。 而且 `ASNetworkImageNode` 图片渐进式加载时会有模糊到清晰的效果，用户体验很好。

## 布局方式
### Stack布局方式
AsyncDisplayKit的ASStackLayoutRepect布局方式类似于CSS3的FlexBox布局，它存在以下的对应关系：

| FlexBox | AsyncDisplayKit | 作用 |
|---------|-----------------|------|
| Direction | ASStackLayoutDirection | 布局方向 | 
| Content-justify | ASStackLayoutJustifyConten | 水平布局方式
|Align-Items | ASStackLayoutAlignItems| 纵向布局方式 |

### 其他布局方式

ASDK不仅限于类似FlexBox的LayoutSpec，还有以下几种：

* ASRatioLayoutSpec 缩放
* ASInsetLayoutSpec 设置外边距
* ASCenterLayoutSpect 相对父控件居中
* ASStaticLayoutSpec 固定布局

在LayoutSpect中可以放另一个LayoutSpect，也可以放 node (ASDK中的基本单位，类似于UIView）。

### Demo架构

在UIKit中，所有的界面操作都是在主线程中进行，而 AsyncDisplayKit 对界面的布局，界面数据加载及界面渲染都是异步进行，所以进行项目驾构时有很大的差异。

在 ASyncDisplayKit 中有两个很重要的概念 `node` (节点) 和 `node container` (节点容器)，节点类似 UIKit 中的 UIView，节点容器类似于 UIViewController。 在需要性能优化的界面，一定要把 `node` 放在 `node container` 中，否则达不到预期的效果，反而会造成闪屏等不良影响。

#### 使用容器

本 Demo 中，`UINavigationController` 和 `UITabBarController` 使用的 UIKit ，因为在界面跳转不存在性能问题。而在主界面使用的是 `ASViewController` 容器（类似`UIViewController` ），其内部的 `node` 也是全部使用 AsyncDisplayKit 框架。

#### 容器内节点的使用

ASDK中的所有节点初始化都在 `-init` 方法中，节点初始化之后，如果设置了 `automaticallyManagesSubnodes` 属性为 YES ，就不需要再使用 `-addSubnode` 方法添加节点。

#### 各个节点的布局

类似UIKit 中的 `layoutSubviews` 方法，ASDK提供了 `layoutSpecThatFits` 方法，在这里可以对所有的子节点进行布局，并返回 `ASLayoutSpec`。

