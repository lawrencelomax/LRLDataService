//
//  LRLMovieViewController.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 15/02/2014.
//
//

#import "LRLMovieViewController.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

#import "LRLTrailerAddictService.h"
#import "LRLRottenTomatoesService.h"
#import "LRLMovieService.h"
#import "LRLMovie.h"
#import "LRLTrailer.h"
#import "LRLMovieViewModel.h"

@interface LRLMovieViewController ()

@property (nonatomic, strong) LRLMovieViewModel *movieViewModel;

@end

@implementation LRLMovieViewController

+ (instancetype) viewControllerWithViewModel:(LRLMovieViewModel *)viewModel {
	LRLMovieViewController *viewController = [[self alloc] initWithNibName:nil bundle:nil];
	viewController.movieViewModel = viewModel;
	return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	RAC(self.trailerButton, enabled) = RACObserve(self.movieViewModel, trailerAvailable);
	RAC(self, title) = RACObserve(self.movieViewModel, titleText);
	RAC(self.plotLabel, text) = RACObserve(self.movieViewModel, plotText);
	RAC(self.ratingLabel, text) = RACObserve(self.movieViewModel, ratingText);
	RAC(self.countryLabel, text) = RACObserve(self.movieViewModel, countryText);
	
	[self.coverImageView rac_liftSelector:@selector(setImageWithURL:)
							  withSignals:RACObserve(self.movieViewModel, coverImageURL), nil];
	
	[RACObserve(self.movieViewModel, status) subscribeNext:^(NSNumber *statusNumber) {
		switch (statusNumber.integerValue) {
			case LRLViewModelStatusErrored:
				[SVProgressHUD showErrorWithStatus:@"Error"];
				break;
			case LRLViewModelStatusLoading:
				[SVProgressHUD showWithStatus:@"Loading..."];
				break;
			case LRLViewModelStatusDone:
				[SVProgressHUD showSuccessWithStatus:@"Done"];
				break;
			default:
				break;
		}
	}];
}

@end
