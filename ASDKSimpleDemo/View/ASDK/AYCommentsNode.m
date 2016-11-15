//
//  AYCommentsNode.m
//  ASDKSimpleDemo
//
//  Created by Zephyr on 2016/11/13.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYCommentsNode.h"

#define num_comments_to_show 3
#define inter_comment_space 5

@implementation AYCommentsNode

{
    AYCommentFeedModel  *_commentFeed;
    NSMutableArray <ASTextNode *> *_commentNodes;
    ASImageNode *_commentImageView;
}

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        
        // 评论图片
        _commentImageView = [ASImageNode new];
        _commentImageView.image = [UIImage imageNamed:@"photo-card-comment"];
        
        _commentNodes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *commentStack = [ASStackLayoutSpec
            stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
            spacing:inter_comment_space
            justifyContent:ASStackLayoutJustifyContentStart
            alignItems:ASStackLayoutAlignItemsStretch
            children:[_commentNodes copy]];
    
    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:13 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_commentImageView, commentStack]];
}

#pragma mark - Instance Methods

- (void)updateWithCommentFeedModel:(AYCommentFeedModel *)feed
{
    _commentFeed = feed;
    [_commentNodes removeAllObjects];
    
    if (_commentFeed) {
        [self createCommentLabels];
        
        BOOL addViewAllCommentsLabel = [feed numberOfCommentsForPhotoExceedsInteger:num_comments_to_show];
        NSAttributedString *commentLabelString;

        int labelsIndex = 0;
        NSUInteger numCommentsInFeed = [_commentFeed numberOfItemsInFeed];
        for (NSUInteger feedIndex = 0; feedIndex < numCommentsInFeed; feedIndex++) {
            commentLabelString = [[_commentFeed objectAtIndex:feedIndex] commentAttributedString];
            [_commentNodes[labelsIndex] setAttributedText:commentLabelString];
            labelsIndex++;
        }
        if (addViewAllCommentsLabel) {
            commentLabelString = [_commentFeed viewAllCommentsAttributedString];
            [_commentNodes[labelsIndex] setAttributedText:commentLabelString];
            labelsIndex++;
        }
        
        [self setNeedsLayout];
    }
}


#pragma mark - Helper Methods

- (void)createCommentLabels
{
    BOOL addViewAllCommentsLabel = [_commentFeed numberOfCommentsForPhotoExceedsInteger:num_comments_to_show];
    NSUInteger numCommentsInFeed = [_commentFeed numberOfItemsInFeed];
    
    NSUInteger numLabelsToAdd = (addViewAllCommentsLabel) ? numCommentsInFeed + 1 : numCommentsInFeed;
    
    for (NSUInteger i = 0; i < numLabelsToAdd; i++) {
        
        ASTextNode *commentLabel   = [[ASTextNode alloc] init];
        commentLabel.maximumNumberOfLines = 3;
    
        [_commentNodes addObject:commentLabel];
    }
}

@end
