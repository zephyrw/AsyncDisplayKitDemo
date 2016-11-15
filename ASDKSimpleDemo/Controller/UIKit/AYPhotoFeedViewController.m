//
//  AYPhotoFeedViewController.m
//  ASDKSimpleDemo
//
//  Created by wpsd on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYPhotoFeedViewController.h"
#import "AYCommentView.h"
#import "AYPhotoFeedModel.h"
#import "AYPhotoTableViewCell.h"
#import "SVProgressHUD.h"

#define AUTO_TAIL_LOADING_NUM_SCREENFULS  2.5

@interface AYPhotoFeedViewController () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation AYPhotoFeedViewController
{
    AYPhotoFeedModel  *_photoFeed;
    UITableView  *_tableView;
    BOOL _isFirstLoad;
}

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.navigationItem.title = @"UIKit";
        [self.navigationController setNavigationBarHidden:YES];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _isFirstLoad = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _photoFeed = [[AYPhotoFeedModel alloc] initWithPhotoFeedModelType:PhotoFeedModelTypePopular imageSize:[self imageSizeForScreenWidth]];
    [self refreshFeed];

    [self.view addSubview:_tableView];
    
    _tableView.frame = self.view.bounds;
    _tableView.allowsSelection = NO;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[AYPhotoTableViewCell class] forCellReuseIdentifier:@"photoCell"];
    

}

#pragma mark - helper methods

- (void)refreshFeed
{
    [SVProgressHUD show];
    
    // 先加载少量数据
    [_photoFeed refreshFeedWithCompletionBlock:^(NSArray *newPhotos){
        
        [self insertNewRowsInTableView:newPhotos];
        [self requestCommentsForPhotos:newPhotos];
        
        // 少量数据加载完成后就开始大量数据的加载
        [self loadPage];
        [SVProgressHUD dismiss];
    } numResultsToReturn:4];
}

- (void)loadPage
{
    [_photoFeed requestPageWithCompletionBlock:^(NSArray *newPhotos){
        [self insertNewRowsInTableView:newPhotos];
        [self requestCommentsForPhotos:newPhotos];
    } numResultsToReturn:20];
}

- (void)requestCommentsForPhotos:(NSArray *)newPhotos
{
    for (AYPhotoModel *photo in newPhotos) {
        [photo.commentFeed refreshFeedWithCompletionBlock:^(NSArray *newComments) {
            
            NSInteger rowNum         = [_photoFeed indexOfPhotoModel:photo];
            NSIndexPath *cellPath    = [NSIndexPath indexPathForRow:rowNum inSection:0];
            AYPhotoTableViewCell *cell = [_tableView cellForRowAtIndexPath:cellPath];
            
            if (cell) {
                [cell loadCommentsForPhoto:photo];
                [_tableView beginUpdates];
                [_tableView endUpdates];
                
                // 在cell处在显示状态下添加评论需要重新设置contentOffset
                NSIndexPath *visibleCellPath = [_tableView indexPathForCell:_tableView.visibleCells.firstObject];
                if (cellPath.row < visibleCellPath.row) {
                    CGFloat commentViewHeight = [AYCommentView heightForCommentFeedModel:photo.commentFeed withWidth:self.view.bounds.size.width];
                    _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, _tableView.contentOffset.y + commentViewHeight);
                }
            }
        }];
    }
}

- (void)insertNewRowsInTableView:(NSArray *)newPhotos
{
    NSInteger section = 0;
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSInteger newTotalNumberOfPhotos = [_photoFeed numberOfItemsInFeed];
    for (NSInteger row = newTotalNumberOfPhotos - newPhotos.count; row < newTotalNumberOfPhotos; row++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
        [indexPaths addObject:path];
    }
    [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (CGSize)imageSizeForScreenWidth
{
    CGRect screenRect   = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    return CGSizeMake(screenRect.size.width * screenScale, screenRect.size.width * screenScale);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_photoFeed numberOfItemsInFeed];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AYPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    [cell updateCellWithPhotoObject:[_photoFeed objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    AYPhotoModel *photo = [_photoFeed objectAtIndex:indexPath.row];
    return [AYPhotoTableViewCell heightForPhotoModel:photo withWidth:self.view.bounds.size.width];
}

#pragma mark - UITableViewDelegate

// tableView 底部视图自动加载
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentOffSetY = scrollView.contentOffset.y;
    CGFloat contentHeight  = scrollView.contentSize.height;
    CGFloat screenHeight   = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat screenfullsBeforeBottom = (contentHeight - currentOffSetY) / screenHeight;
    if (screenfullsBeforeBottom < AUTO_TAIL_LOADING_NUM_SCREENFULS) {
        [self loadPage];
    }
}

#pragma mark - PhotoFeedViewControllerProtocol

- (void)resetAllData
{
    [_photoFeed clearFeed];
    [_tableView reloadData];
    [self refreshFeed];
}

@end
