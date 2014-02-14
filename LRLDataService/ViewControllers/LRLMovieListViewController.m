//
//  LRLViewController.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 30/01/2014.
//
//

#import "LRLMovieListViewController.h"

#import "LRLMovie.h"
#import "LRLMovieService.h"
#import "LRLComposedTableViewDataSource.h"
#import "LRLMovieViewController.h"
#import "LRLIMDBService.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LRLMovieListViewController ()

@property (nonatomic, strong) LRLMovieService *service;

@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) LRLComposedTableViewDataSource *dataSource;

@end

@implementation LRLMovieListViewController

+ (instancetype) viewControllerWithService:(LRLMovieService *)service {
	LRLMovieListViewController *viewController = [[self alloc] initWithStyle:UITableViewStylePlain];
	viewController.service = service;
	return viewController;
}

- (void) viewDidLoad {
    [super viewDidLoad];
	
	self.dataSource = [LRLComposedTableViewDataSource dataSourceForTableView:self.tableView];
	self.dataSource.cellConfiguration = ^(LRLMovie *movie, UITableViewCell *cell) {
		cell.textLabel.text = movie.title;
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", movie.type, movie.imdbID];
	};
	
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:NULL];
	self.navigationItem.rightBarButtonItem = barButton;

	RAC(self, title) = [RACObserve(self, searchString) map:^(NSString *string) {
		return string && string.length > 0 ? string : @"Movies";
	}];
	RAC(self, searchString) = [self searchString:barButton];
	RAC(self.dataSource, values) = [self moviesSignal];
	
	[self.navigationController rac_liftSelector:@selector(pushViewController:animated:)
									withSignals:self.presentation, [RACSignal return:@YES], nil];
}

- (RACSignal *) presentation {
	@weakify(self)
	return [self.dataSource.cellPressed map:^(LRLMovie *movie) {
		@strongify(self)
		LRLMovieViewController *viewController = [LRLMovieViewController viewControllerWithMovieService:self.service];
		viewController.movie = movie;
		return viewController;
	}];
}

- (RACSignal *) searchString:(UIBarButtonItem *)barButton {
	barButton.rac_command = [[RACCommand alloc]
		initWithEnabled:[RACSignal return:@YES]
		signalBlock:^(UIBarButtonItem *item) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Can has Movie" message:@"Plz." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
			alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
			[alertView show];
			
			return [[alertView.rac_buttonClickedSignal
				take:1]
				flattenMap:^(NSNumber *buttonClicked){
					barButton.enabled = YES;
					
					if(buttonClicked.integerValue == 0) {
						return [RACSignal return:[[alertView textFieldAtIndex:0] text]];
					}
					return RACSignal.empty;
				}];
		}];
	
	return [[barButton.rac_command executionSignals] flatten];
}

- (RACSignal *) moviesSignal {
	@weakify(self)
	
	return [[RACObserve(self, searchString)
		map:^(NSString *searchString) {
			@strongify(self)
			if(searchString) {
				return [[[[[[[[self.service.imdbService moviesWithSearch:searchString]
					distinctUntilChanged]
					initially:^{
						[SVProgressHUD showWithStatus:@"Loading.."];
					}]
					doNext:^(id x) {
						[SVProgressHUD dismiss];
					}]
					finally:^{
						[SVProgressHUD dismiss];
					}]
					doError:^(NSError *error) {
						[SVProgressHUD showErrorWithStatus:error.description];
					}]
					catchTo:RACSignal.empty]
					startWith:@[]];
			}
			return [RACSignal return:@[]];
		}]
		switchToLatest];
}

@end
