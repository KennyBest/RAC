//
//  Created by Colin Eberhardt on 13/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchViewController.h"
#import "ReactiveObjC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BXGoods.h"
#import "BXGoodsSearchResults.h"

@interface RWTFlickrSearchViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *searchHistoryTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (weak, nonatomic) FlickrSearchViewModel *viewModel;

@property (strong, nonatomic) SearchResultViewModel *resultsViewModel;

@end

@implementation RWTFlickrSearchViewController

- (instancetype)initWithViewModel:(FlickrSearchViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

- (instancetype)initWithSearchResultViewModel:(SearchResultViewModel *)viewModel {
    if (self = [super init]) {
        _resultsViewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.searchHistoryTable.delegate = self;
    self.searchHistoryTable.dataSource = self;
    [self.searchHistoryTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"rac"];
    
    [self bindViewModel];
}

- (void)bindViewModel {
    self.title = self.viewModel.title;
    self.searchTextField.text = self.viewModel.searchText;
    //  -- 还是有疑问 -- 用searchTextField信号的next事件传递的值来更新viewModel的searchText属性
    RAC(self.viewModel, searchText) = self.searchTextField.rac_textSignal;
    
    [self.searchTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"---->%@", x);
        NSLog(@"ViewModel---->%@", self.viewModel.searchText);
    }];
    
    self.searchButton.rac_command = self.viewModel.executeSearch;
    
    RAC([UIApplication sharedApplication], networkActivityIndicatorVisible) = self.viewModel.executeSearch.executing;
    RAC(self.loadingIndicator, hidden) = [self.viewModel.executeSearch.executing not];
    [self.viewModel.executeSearch.executionSignals subscribeNext:^(id  _Nullable x) {
        [self.searchTextField resignFirstResponder];
    }];
    
    RACSignal *commondSignal = self.viewModel.executeSearch.executing;
    @weakify(self);
    [commondSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (![x boolValue]) {
            NSLog(@"---------------------- commond execute the signal block of initializtion");
            [self.searchHistoryTable reloadData];
        }
    }];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rac" forIndexPath:indexPath];
    BXGoods *goods = self.viewModel.goods[indexPath.row];
    cell.textLabel.text = goods.GoodsName;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:goods.GoodsImg]];
    return cell;
}

@end
