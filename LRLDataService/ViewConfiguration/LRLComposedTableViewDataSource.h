//
//  LRLComposedTableViewDataSource.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 15/02/2014.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RACSignal;

extern NSString *const LRLComposedTableViewDataSourceReuseIdentifier;

@interface LRLComposedTableViewDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

+ (instancetype) dataSourceForTableView:(UITableView *)tableView;

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, readonly) UITableView *tableView;

@property (nonatomic, copy) void (^cellConfiguration)(id value, UITableViewCell *cell);
@property (nonatomic, readonly) RACSignal *cellPressed;

@end
