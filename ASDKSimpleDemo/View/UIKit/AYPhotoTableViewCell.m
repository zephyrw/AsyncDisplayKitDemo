//
//  AYPhotoTableViewCell.m
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/13.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYPhotoTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "PINImageView+PINRemoteImage.h"
#import "PINButton+PINRemoteImage.h"
#import "AYCommentView.h"
#import "UIImageView+WebCache.h"

#define avatarImageWH   30
#define AYFontSize   14
#define leftMargin  15
#define avatarLeftMargin 10
#define vertical_margin   5
#define horizontalMargin 10
#define toolBarH 30

@implementation AYPhotoTableViewCell
{
    AYPhotoModel   *_photoModel;
    AYCommentView  *_photoCommentsView;
    
    UIImageView  *_userAvatarImageView;
    UIImageView  *_photoImageView;
    UIButton     *_addToGalleryButton;
    UIButton     *_heartButton;
    UIButton     *_likePhotoButton;
    UIButton     *_detailButton;
    UIButton     *_shareButton;
    UIView       *_toolBarView;
    UILabel      *_userNameLabel;
    UILabel      *_photoTimeIntervalSincePostLabel;
    UILabel      *_photoLikesLabel;
    
    CGFloat _cellHeigth;
}

#pragma mark - Class Methods

+ (CGFloat)heightForPhotoModel:(AYPhotoModel *)photo withWidth:(CGFloat)width;
{
    CGFloat photoHeight = width;
    
    UIFont *font        = [UIFont systemFontOfSize:AYFontSize];
    CGFloat likesHeight = roundf([font lineHeight]);
    
    CGFloat availableWidth = (width - horizontalMargin * 2);
    
    CGFloat commentViewHeight = [AYCommentView heightForCommentFeedModel:photo.commentFeed withWidth:availableWidth];
    
    return photoHeight + avatarImageWH + likesHeight + commentViewHeight + toolBarH + (5 * vertical_margin);
}

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _photoCommentsView   =   [[AYCommentView alloc] init];
        _userAvatarImageView = [[UIImageView alloc] init];
        _photoImageView      = [[UIImageView alloc] init];
        _addToGalleryButton  = [self buttonWithTitle:nil imageName:@"btn-add-to-gallery" selImageName:nil selector:@selector(addToGalleryButtonClick)];
        _heartButton          = [self buttonWithTitle:nil imageName:@"heart" selImageName:@"heart-filled" selector:@selector(heartButtonClick:)];
        _likePhotoButton     = [self buttonWithTitle:nil imageName:@"icon-like-photo" selImageName:nil selector:@selector(likePhotoButtonClick)];
        _toolBarView         = [UIView new];
        _detailButton        = [self buttonWithTitle:@"    详细" imageName:@"photo-card-details" selImageName:nil selector:@selector(detailButtonClick)];
        _shareButton         = [self buttonWithTitle:@"    分享" imageName:@"photo-card-share" selImageName:nil selector:@selector(shareButtonClick)];
        _userNameLabel       = [[UILabel alloc] init];
        _photoTimeIntervalSincePostLabel = [[UILabel alloc] init];
        _photoLikesLabel     = [[UILabel alloc] init];
        
        [self addSubview:_photoCommentsView];
        [self addSubview:_userAvatarImageView];
        [self addSubview:_photoImageView];
        [self addSubview:_addToGalleryButton];
        [self addSubview:_heartButton];
        [self addSubview:_toolBarView];
        [_toolBarView addSubview:_detailButton];
        [_toolBarView addSubview: _shareButton];
        [self addSubview:_userNameLabel];
        [self addSubview:_photoTimeIntervalSincePostLabel];
        [self addSubview:_photoLikesLabel];

    }
    
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _photoImageView.frame = CGRectMake(0, 0, AYScreemWidth, AYScreemWidth);
    
    CGFloat avatarX = avatarLeftMargin;
    CGFloat avatarY = CGRectGetMaxY(_photoImageView.frame) + vertical_margin;
    _userAvatarImageView.frame = CGRectMake(avatarX, avatarY, avatarImageWH, avatarImageWH);
    
    CGFloat nameX = CGRectGetMaxX(_userAvatarImageView.frame) + horizontalMargin;
    CGFloat nameH = [[UIFont systemFontOfSize:AYFontSize] lineHeight];
    _userNameLabel.frame = CGRectMake(nameX, avatarY, _userNameLabel.frame.size.width, nameH);
    
    CGFloat timeY = CGRectGetMaxY(_userNameLabel.frame) + vertical_margin;
    _photoTimeIntervalSincePostLabel.frame = CGRectMake(nameX, timeY, 100, nameH);
    
    CGFloat heartX = AYScreemWidth - leftMargin - avatarImageWH;
    _heartButton.frame = CGRectMake(heartX, avatarY, avatarImageWH, avatarImageWH);
    
    CGFloat addX = heartX - horizontalMargin - avatarImageWH;
    _addToGalleryButton.frame = CGRectMake(addX, avatarY, avatarImageWH, avatarImageWH);
    
    CGFloat likeX = avatarLeftMargin + 5;
    CGFloat likeY = CGRectGetMaxY(_heartButton.frame) + vertical_margin;
    _likePhotoButton.frame = CGRectMake(likeX, likeY, AYScreemWidth - leftMargin * 2, nameH);
    
    CGFloat commentY = CGRectGetMaxY(_likePhotoButton.frame) + vertical_margin;
    CGFloat commentW = AYScreemWidth - leftMargin * 2;
    CGFloat commentH = _photoCommentsView.bounds.size.height;
    _photoCommentsView.frame = CGRectMake(likeX, commentY, commentW, commentH);
    
    CGFloat toolBarX = likeX;
    CGFloat toolBarY = commentH ? (CGRectGetMaxY(_photoCommentsView.frame) + vertical_margin) : commentY;
    CGFloat toolBarW = commentW;
    
    _detailButton.frame = CGRectMake(0, 0, _detailButton.frame.size.width, toolBarH);
    _shareButton.frame = CGRectMake(toolBarW / 2, 0, _shareButton.frame.size.width, toolBarH);
    _toolBarView.frame = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    
    _cellHeigth = CGRectGetMaxY(_toolBarView.frame) + vertical_margin;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _photoCommentsView.frame                        = CGRectZero;
    [_photoCommentsView updateWithCommentFeedModel:nil];
    _photoCommentsView.commentImageView.frame       = CGRectZero;
    _userAvatarImageView.image                      = nil;
    _photoImageView.image                           = nil;
    [_likePhotoButton setTitle:nil forState:UIControlStateNormal];
    _userNameLabel.attributedText                   = nil;
    _photoTimeIntervalSincePostLabel.attributedText = nil;
    _photoLikesLabel.attributedText                 = nil;
}

#pragma mark - 实例方法

- (void)updateCellWithPhotoObject:(AYPhotoModel *)photo
{
    _photoModel = photo;
    _userNameLabel.attributedText = [photo.ownerUserProfile usernameAttributedStringWithFontSize:AYFontSize];
    _photoTimeIntervalSincePostLabel.attributedText = [photo uploadDateAttributedStringWithFontSize:AYFontSize];
    
    [_userNameLabel sizeToFit];
    [_photoTimeIntervalSincePostLabel sizeToFit];
    [_photoLikesLabel sizeToFit];
    
    [_photoImageView sd_setImageWithURL:photo.URL];
    
    [_likePhotoButton setTitle:[NSString stringWithFormat:@" %lu人喜欢了此照片", photo.likesCount] forState:UIControlStateNormal];
    UIImage *placeHoderImage = [[UIImage imageNamed:@"avatar-placeholder"] makeCircularImageWithSize:CGSizeMake(avatarImageWH, avatarImageWH)];
    [_userAvatarImageView sd_setImageWithURL:photo.ownerUserProfile.userPicURL placeholderImage:placeHoderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _userAvatarImageView.image = [image makeCircularImageWithSize:CGSizeMake(avatarImageWH, avatarImageWH)];
    }];
    [self loadCommentsForPhoto:photo];
}

- (void)loadCommentsForPhoto:(AYPhotoModel *)photo
{
    if (photo.commentFeed.numberOfItemsInFeed > 0) {
        [_photoCommentsView updateWithCommentFeedModel:photo.commentFeed];
        
        CGRect frame             = _photoCommentsView.frame;
        CGFloat availableWidth   = (self.bounds.size.width - horizontalMargin * 2);
        frame.size.width         = availableWidth;
        frame.size.height        = [AYCommentView heightForCommentFeedModel:photo.commentFeed withWidth:availableWidth];
        _photoCommentsView.frame = frame;
        
        [self setNeedsLayout];
    }
}

#pragma mark - 按钮点击事件

- (void)addToGalleryButtonClick {
    AYLog(@"");
}

- (void)heartButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    AYLog(@"");
}

- (void)detailButtonClick {
    AYLog(@"");
}

- (void)shareButtonClick {
    AYLog(@"");
}

- (void)likePhotoButtonClick {
    AYLog(@"");
}

#pragma mark - 辅助方法

- (UIButton *)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName selImageName:(NSString *)selImageName selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:AYDarkBlueColor forState:UIControlStateNormal];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (selImageName) {
        [button setImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
    }
    if (selector) {
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:AYFontSize];
    [button sizeToFit];
    return button;
}

@end
