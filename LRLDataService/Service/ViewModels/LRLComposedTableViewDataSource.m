//
//  LRLComposedTableViewDataSource.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 15/02/2014.
//
//

#import "LRLComposedTableViewDataSource.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

NSString *const LRLComposedTableViewDataSourceReuseIdentifier = @"grumpypants";

@interface LRLComposedTableViewDataSource()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) RACSubject *cellPressedSubject;

@end

@implementation LRLComposedTableViewDataSource

+ (instancetype) dataSourceForTableView:(UITableView *)tableView {
	return [[self alloc] initWithTableView:tableView];
}

- (instancetype) initWithTableView:(UITableView *)tableView {
	if( (self = [super init]) ) {
		self.tableView = tableView;
		self.values = @[];
		tableView.dataSource = self;
		tableView.delegate = self;
		
		@weakify(self)
		[RACObserve(self, values) subscribeNext:^(id x) {
			@strongify(self)
			[self.tableView reloadData];
		}];
	}
	return self;
}

- (void) dealloc {
	return [self.cellPressedSubject sendCompleted];
}

- (RACSignal *) cellPressed {
	if(!self.cellPressedSubject) {
		self.cellPressedSubject = [RACSubject subject];
	}
	return self.cellPressedSubject;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.values.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:LRLComposedTableViewDataSourceReuseIdentifier];
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:LRLComposedTableViewDataSourceReuseIdentifier];
	}
	
	id value = self.values[indexPath.row];
	self.cellConfiguration(value, cell);
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	id value = self.values[indexPath.row];
	[self.cellPressedSubject sendNext:value];
}

@end
