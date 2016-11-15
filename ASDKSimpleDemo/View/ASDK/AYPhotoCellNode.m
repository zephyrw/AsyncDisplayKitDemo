//
//  AYPhotoCellNode.m
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYPhotoCellNode.h"
#import "AYPhotoModel.h"
#import "AYCommentsNode.h"

#define avatarImageWH   30
#define AYFontSize   14
#define leftMargin  15
#define avatarLeftMargin -5
#define vertical_margin   5

@implementation AYPhotoCellNode
{
    AYPhotoModel *_photoModel;
    AYCommentsNode *_photoCommentsView;
    ASNetworkImageNode *_userAvatarImageView;
    ASNetworkImageNode *_photoImageView;
    ASButtonNode *_addToGalleryButton;
    ASButtonNode *_heartButton;
    ASButtonNode *_likePhotoButton;
    
    ASButtonNode *_detailsButton;
    ASButtonNode *_shareButton;
    ASTextNode *_userNameLabel;
    ASTextNode *_photoLocationLabel;
    ASTextNode *_photoTimeIntervalSincePostLabel;
    ASTextNode *_photoLikesLabel;
    ASTextNode *_photoDescriptionLabel;
}

- (instancetype)initWithPhotoObject:(AYPhotoModel *)photo {
    if (self = [super init]) {
        
        _photoModel = photo;
        // 图片
        _photoImageView = [ASNetworkImageNode new];
        _photoImageView.URL = photo.URL;
        _photoImageView.layerBacked = YES;
        // 头像
        _userAvatarImageView = [ASNetworkImageNode new];
        _userAvatarImageView.URL = photo.ownerUserProfile.userPicURL;
        _userAvatarImageView.imageModificationBlock = ^UIImage *(UIImage *image){
//            AYLog(@"avatar -> %@", image);
            CGSize avatarImageSize = CGSizeMake(avatarImageWH, avatarImageWH);
            return [image makeCircularImageWithSize:avatarImageSize];
        };
        // 用户名
        _userNameLabel = [ASTextNode new];
        _userNameLabel.attributedText = [NSAttributedString attributedStringWithString:photo.ownerUserProfile.username fontSize:AYFontSize color:AYLightBlueColor firstWordColor:nil];

        // 图片上传时间
        _photoTimeIntervalSincePostLabel = [ASTextNode new];
        _photoTimeIntervalSincePostLabel.layerBacked = YES;
        _photoTimeIntervalSincePostLabel.attributedText = [NSAttributedString attributedStringWithString:photo.uploadDateString fontSize:AYFontSize color:[UIColor lightGrayColor] firstWordColor:nil];
        // 添加到相册按钮
        _addToGalleryButton = [self buttonNodeWithTitle:nil imageName:@"btn-add-to-gallery" selImageName:nil selector:@selector(addToGalleryBtnClick)];
        // 心型按钮
        _heartButton = [self buttonNodeWithTitle:nil imageName:@"heart" selImageName:@"heart-filled" selector:@selector(hearBtnClick:)];
        // 喜欢照片数据按钮
        _likePhotoButton = [self buttonNodeWithTitle:[NSString stringWithFormat:@" %lu人喜欢了此照片", photo.likesCount] imageName:@"icon-like-photo" selImageName:nil selector:nil];
        
        // 评论列表
        _photoCommentsView = [[AYCommentsNode alloc] init];
        // 详情按钮
        _detailsButton = [self buttonNodeWithTitle:@" 详细" imageName:@"photo-card-details" selImageName:nil selector:@selector(detailBtnClick)];
        // 分享
        _shareButton = [self buttonNodeWithTitle:@" 分享" imageName:@"photo-card-share" selImageName:nil selector:@selector(shareBtnClick)];
        self.automaticallyManagesSubnodes = YES;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    
    // 图片
    ASRatioLayoutSpec *imageLayout = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1.0 child:_photoImageView];
    
    // 头像
    ASInsetLayoutSpec *avatarLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, avatarLeftMargin, 0, 0) child:[_userAvatarImageView styledWithBlock:^(__kindof ASLayoutElementStyle * _Nonnull style) {
        style.preferredSize = CGSizeMake(avatarImageWH, avatarImageWH);
    }]];
    // 名字和时间容器
    ASStackLayoutSpec *nameNTimeStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[_userNameLabel, _photoTimeIntervalSincePostLabel]];
    
    // 中间左边容器
    CGFloat centerInterSpacing = 5;
    ASStackLayoutSpec *centerLeftStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:centerInterSpacing justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[avatarLayout, nameNTimeStack]];
    
    // 中间右边容器
    ASStackLayoutSpec *centerRightStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:20 justifyContent:ASStackLayoutJustifyContentSpaceAround alignItems:ASStackLayoutAlignItemsCenter children:@[_addToGalleryButton, _heartButton]];
    
    // 中间容器
    ASStackLayoutSpec *centerStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsCenter children:@[centerLeftStack, centerRightStack]];

    // 细节按钮
    ASStackLayoutSpec *detailStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_detailsButton]];
    
    // 分享按钮
    ASStackLayoutSpec *shareStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_shareButton]];
    
    // 工具条容器
    CGFloat toolBarH = 40;
    ASStackLayoutSpec *toolBarStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStretch children:@[[detailStack styledWithBlock:^(__kindof ASLayoutElementStyle * _Nonnull style) {
        style.preferredSize = CGSizeMake(AYScreemWidth / 2 - leftMargin, toolBarH);
    }], [shareStack styledWithBlock:^(__kindof ASLayoutElementStyle * _Nonnull style) {
        style.preferredSize = CGSizeMake(AYScreemWidth / 2 - leftMargin, toolBarH);
    }]]];
    // 底部容器
    CGFloat centerH = 50;
    ASStackLayoutSpec *bottomStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:vertical_margin justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[[centerStack styledWithBlock:^(__kindof ASLayoutElementStyle * _Nonnull style) {
        style.preferredSize = CGSizeMake(AYScreemWidth - leftMargin * 2, centerH);
    }], _likePhotoButton, _photoCommentsView, toolBarStack]];
    ASInsetLayoutSpec *bottomInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(vertical_margin, leftMargin, vertical_margin, leftMargin) child:bottomStack];
    // 主容器
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:vertical_margin justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsStart children:@[imageLayout, bottomInset]];
    
    return mainStack;
}

#pragma mark - 对象方法

- (void)fetchData
{
    [super fetchData];
    
    [_photoModel.commentFeed refreshFeedWithCompletionBlock:^(NSArray *newComments) {
        [self loadCommentsForPhoto:_photoModel];
    }];
}

#pragma mark - 点击事件

- (void)addToGalleryBtnClick {
    AYLog(@"添加到相册按钮点击");
}

- (void)hearBtnClick:(ASButtonNode *)sender {
    sender.selected = !sender.selected;
    AYLog(@"心型按钮点击");
}
            
- (void)detailBtnClick {
    AYLog(@"详情按钮点击");
}

- (void)shareBtnClick {
    AYLog(@"分享按钮点击");
}

#pragma mark - 辅助方法

- (ASButtonNode *)buttonNodeWithTitle:(NSString *)title imageName:(NSString *)imageName selImageName:(NSString *)selImageName selector:(SEL)selector {
    ASButtonNode *buttonNode = [ASButtonNode new];
    if (title) {
        [buttonNode setTitle:title withFont:[UIFont systemFontOfSize:AYFontSize] withColor:AYDarkBlueColor forState:ASControlStateNormal];
    }
    if (imageName) {
        [buttonNode setImage:[UIImage imageNamed:imageName] forState:ASControlStateNormal];
    }
    if (selImageName) {
        [buttonNode setImage:[UIImage imageNamed:selImageName] forState:ASControlStateSelected];
    }
    if (selector) {
        [buttonNode addTarget:self action:selector forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return buttonNode;
}

- (ASTextNode *)createLayerBackedTextNodeWithString:(NSString *)string
{
    ASTextNode *textNode      = [[ASTextNode alloc] init];
    textNode.layerBacked      = YES;
    textNode.attributedText = [self attributedStringWithString:string];
    return textNode;
}

- (NSAttributedString *)attributedStringWithString:(NSString *)string {
    return [NSAttributedString attributedStringWithString:string fontSize:AYFontSize color:AYDarkBlueColor firstWordColor:nil];
}

- (void)loadCommentsForPhoto:(AYPhotoModel *)photo
{
    if (photo.commentFeed.numberOfItemsInFeed > 0) {
        [_photoCommentsView updateWithCommentFeedModel:photo.commentFeed];
        
        [self setNeedsLayout];
    }
}

@end
