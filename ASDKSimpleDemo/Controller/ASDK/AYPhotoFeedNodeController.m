//
//  AYPhotoFeedNodeController.m
//  ASDKSimpleDemo
//
//  Created by wpsd on 2016/11/11.
//  Copyright © 2016年 wpsd. All rights reserved.
//

#import "AYPhotoFeedNodeController.h"
#import "AYPhotoCellNode.h"
#import "AYPhotoFeedModel.h"
#import "SVProgressHUD.h"

@interface AYPhotoFeedNodeController ()<ASTableDelegate, ASTableDataSource>

@property (strong, nonatomic) ASTableNode *tableNode;
@property (strong, nonatomic) AYPhotoFeedModel *photoFeed;
@property (assign, nonatomic, getter=isFirstLoad) BOOL firstLoad;

@end

@implementation AYPhotoFeedNodeController

#pragma mark - lifecycle

- (instancetype)init {
    
    _tableNode = [ASTableNode new];
    self = [super initWithNode:_tableNode];
    if (self == nil) { return self; }
    
    _tableNode.delegate = self;
    _tableNode.dataSource = self;

    [self.node addSubnode:_tableNode];
    
    _firstLoad = YES;
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.tableNode.view.allowsSelection = NO;
    self.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _photoFeed = [[AYPhotoFeedModel alloc] initWithPhotoFeedModelType:PhotoFeedModelTypePopular imageSize:[self imageSizeForScreenWidth]];
    
    [self refreshFeed];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)refreshFeed {
    AYLog(@"即将开始刷新");
    [SVProgressHUD show];
    [_photoFeed refreshFeedWithCompletionBlock:^(NSArray *newPhotos) {
//        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        [self insertNewRowsInTableNode:newPhotos];
        [self loadPageWithContext:nil];
        AYLog(@"成功加载了4条数据");
        [SVProgressHUD dismiss];
    } numResultsToReturn:4];
}

- (void)loadPageWithContext:(ASBatchContext *)context
{
    AYLog(@"开始进行loadPage操作");
    [_photoFeed requestPageWithCompletionBlock:^(NSArray *newPhotos) {
        [self insertNewRowsInTableNode:newPhotos];
        AYLog(@"后台加载了20条数据");
        if (context) {
            [context completeBatchFetching:YES];
        }
    } numResultsToReturn:20];
}
     
- (void)insertNewRowsInTableNode:(NSArray *)newPhotos
{
    NSInteger section = 0;
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSUInteger newTotalNumberOfPhotos = [_photoFeed numberOfItemsInFeed];
    AYLog(@"成功加载了%lu条数据，加载后的总数据为%lu", newPhotos.count, newTotalNumberOfPhotos);
    if (self.isFirstLoad && newPhotos.count == 20) {
        self.firstLoad = NO;
        return;
    }
    for (NSUInteger row = newTotalNumberOfPhotos - newPhotos.count; row < newTotalNumberOfPhotos; row++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
        [indexPaths addObject:path];
    }
    
    [_tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

/**
 根据屏幕尺寸和分辨率算出图片尺寸

 @return 图片尺寸
 */
- (CGSize)imageSizeForScreenWidth
{
    CGRect screenRect   = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    return CGSizeMake(screenRect.size.width * screenScale, screenRect.size.width * screenScale);
}

#pragma mark - ASTableDataSource

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return [_photoFeed numberOfItemsInFeed];
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *cellStr = [NSString stringWithFormat:@"cell indexPath -> row:%lu", indexPath.row];
    AYPhotoModel *photo = [_photoFeed objectAtIndex:indexPath.row];
    return ^{
        AYPhotoCellNode *cellNode = [[AYPhotoCellNode alloc] initWithPhotoObject:photo];
        return cellNode;
    };
}

#pragma mark - ASTableNodeDelegate

- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context {
    AYLog(@"开始进行Batch Fetch");
    [context beginBatchFetching];
    [self loadPageWithContext:context];

}

#pragma mark - PhotoFeedViewControllerProtocol

- (void)resetAllData
{
    [_photoFeed clearFeed];
    [_tableNode reloadData];
    [self refreshFeed];
}

@end
