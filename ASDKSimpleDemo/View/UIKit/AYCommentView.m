//
//  AYCommentView.m
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/13.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYCommentView.h"

#define interCommentSpacing 5
#define numCommentsToShow  3
#define horizontal  15
#define commentImgWH 18

@implementation AYCommentView
{
    AYCommentFeedModel           *_commentFeed;
    NSMutableArray <UILabel *> *_commentLabels;
}

#pragma mark - Class Methods

+ (CGFloat)heightForCommentFeedModel:(AYCommentFeedModel *)feed withWidth:(CGFloat)width
{
    NSAttributedString *string;
    CGRect rect;
    CGFloat height = 0;
    
    BOOL addViewAllCommentsLabel = [feed numberOfCommentsForPhotoExceedsInteger:numCommentsToShow];
    if (addViewAllCommentsLabel) {
        string  = [feed viewAllCommentsAttributedString];
        rect    = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                       context:nil];
        height += rect.size.height;
    }
    
    NSUInteger numCommentsInFeed = [feed numberOfItemsInFeed];
    
    for (int i = 0; i < numCommentsInFeed; i++) {
        
        string  = [[feed objectAtIndex:i] commentAttributedString];
        rect    = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                       context:nil];
        height += rect.size.height + interCommentSpacing;
    }
    
    return roundf(height);
}

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _commentLabels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize boundsSize     = self.bounds.size;
    CGRect rect           = CGRectMake(horizontal + _commentImageView.width, 0, boundsSize.width, -interCommentSpacing);
    
    for (UILabel *commentsLabel in _commentLabels) {
        rect.origin.y       += rect.size.height + interCommentSpacing;
        rect.size           = [commentsLabel sizeThatFits:CGSizeMake(boundsSize.width, CGFLOAT_MAX)];
        commentsLabel.frame = rect;
    }
    _commentImageView.frame = CGRectMake(0, rect.origin.y / 2, _commentImageView.width, _commentImageView.height);
}

#pragma mark - Instance Methods

- (void)updateWithCommentFeedModel:(AYCommentFeedModel *)feed
{
    _commentFeed = feed;
    [self removeCommentLabels];
    
    if (_commentFeed) {
        [self createCommentLabels];
        
        BOOL addViewAllCommentsLabel = [feed numberOfCommentsForPhotoExceedsInteger:numCommentsToShow];
        NSAttributedString *commentLabelString;
        int labelsIndex = 0;
        
        if (addViewAllCommentsLabel) {
            commentLabelString        = [_commentFeed viewAllCommentsAttributedString];
            [[_commentLabels objectAtIndex:labelsIndex] setAttributedText:commentLabelString];
            labelsIndex++;
        }
        
        NSUInteger numCommentsInFeed = [_commentFeed numberOfItemsInFeed];
        
        for (int feedIndex = 0; feedIndex < numCommentsInFeed; feedIndex++) {
            commentLabelString         = [[_commentFeed objectAtIndex:feedIndex] commentAttributedString];
            [[_commentLabels objectAtIndex:labelsIndex] setAttributedText:commentLabelString];
            labelsIndex++;
        }
        
        [self setNeedsLayout];
    }
}

#pragma mark - Helper Methods

- (void)removeCommentLabels
{
    for (UILabel *commentLabel in _commentLabels) {
        [commentLabel removeFromSuperview];
    }
    
    [_commentLabels removeAllObjects];
}

- (void)createCommentLabels
{
    BOOL addViewAllCommentsLabel = [_commentFeed numberOfCommentsForPhotoExceedsInteger:numCommentsToShow];
    NSUInteger numCommentsInFeed = [_commentFeed numberOfItemsInFeed];
    
    NSUInteger numLabelsToAdd    = (addViewAllCommentsLabel) ? numCommentsInFeed + 1 : numCommentsInFeed;
    
    for (NSUInteger i = 0; i < numLabelsToAdd; i++) {
        
        UILabel *commentLabel      = [[UILabel alloc] init];
        commentLabel.numberOfLines = 3;
        
        [_commentLabels addObject:commentLabel];
        [self addSubview:commentLabel];
    }
    _commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-card-comment"]];
    [self addSubview:_commentImageView];
}

@end
