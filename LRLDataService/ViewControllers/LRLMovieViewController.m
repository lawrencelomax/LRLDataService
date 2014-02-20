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

@interface LRLMovieViewController ()

@property (nonatomic, strong) LRLMovieService *movieService;
@property (nonatomic, strong) id<LRLMovie> detailedMovie;

@end

@implementation LRLMovieViewController

+ (instancetype) viewControllerWithMovieService:(LRLMovieService *)service {
	LRLMovieViewController *viewController = [[self alloc] initWithNibName:Nil bundle:nil];
	viewController.movieService = service;;
	return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	@weakify(self)
	RAC(self, detailedMovie) = [[[RACObserve(self, movie)
		map:^(id<LRLMovie> movie) {
			@strongify(self)
			if(movie) {
				return [[[[[[[self.movieService
					detailedMovie:movie]
					initially:^{
						[SVProgressHUD showWithStatus:@"Loading..."];
				   	}]
					doNext:^(id x) {
					  	[SVProgressHUD showSuccessWithStatus:@"Done"];
					}]
					doCompleted:^(){
					  	[SVProgressHUD showSuccessWithStatus:@"Done"];
					}]
					doError:^(NSError *error) {
						[SVProgressHUD showErrorWithStatus:error.description];
					}]
					catchTo:RACSignal.empty]
					startWith:movie];
			}
			return RACSignal.empty;
		}]
		switchToLatest]
		distinctUntilChanged];
		
	RAC(self.trailerButton, enabled) = [RACObserve(self, detailedMovie) map:^(id<LRLMovie> movie) {
		return @(movie.trailer.link != nil);
	}];
	
	RAC(self, title) = [RACObserve(self, detailedMovie) map:^(id<LRLMovie> movie) {
		if(movie) {
			return [NSString stringWithFormat:@"%@ - (%@)",movie.title, movie.year];
		}
		return @"";
	}];
	
	RAC(self.plotLabel, text) = [RACObserve(self, detailedMovie) map:^(id<LRLMovie> movie) {
		return movie.plot;
	}];
	
	RAC(self.ratingLabel, text) = [RACObserve(self, detailedMovie) map:^(id<LRLMovie> movie) {
		if(movie.criticsRating) {
			return [NSString stringWithFormat:@"Rating: %@", movie.criticsRating];
		}
		return @"";
	}];
	
	RAC(self.countryLabel, text) = [RACObserve(self, detailedMovie) map:^(id<LRLMovie> movie) {
		return movie.country;
	}];
	
	[self.coverImageView rac_liftSelector:@selector(setImageWithURL:)
							  withSignals:self.coverImageURLSignal, nil];
}

- (RACSignal *) coverImageURLSignal {
	return [RACObserve(self, detailedMovie)
		map:^(id<LRLMovie> movie) {
			return movie.artworkURL;
		}];
}

@end
