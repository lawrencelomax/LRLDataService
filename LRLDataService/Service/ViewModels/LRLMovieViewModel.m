//
//  LRLMovieViewModel.m
//  LRLDataService
//
//  Created by Lawrence Lomax on 26/02/2014.
//
//

#import "LRLMovieViewModel.h"

#import "LRLMovieService.h"
#import "LRLMovie.h"
#import "LRLTrailer.h"

@interface LRLMovieViewModel ()

@property (nonatomic, strong) LRLMovieService *movieService;
@property (nonatomic, strong) LRLMovie *movie;

@property (nonatomic, strong) NSURL *trailerLink;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *plotText;
@property (nonatomic, strong) NSString *ratingText;
@property (nonatomic, strong) NSString *countryText;

@property (nonatomic, strong) NSURL *coverImageURL;

@property (nonatomic, assign) LRLViewModelStatus status;

@end

@implementation LRLMovieViewModel

+ (instancetype) viewModelWithService:(LRLMovieService *)service {
	return [[self alloc] initWithService:service];
}

- (instancetype) initWithService:(LRLMovieService *)service {
	if( (self = [super init]) ) {
		self.movieService = service;
		
		[self setupMovieViewModelListeners];
	}
	return self;
}

- (void) setupMovieViewModelListeners {
	RAC(self, movie) = [self movieSignal];
	
	RAC(self, trailerLink) = [RACObserve(self, movie) map:^(LRLMovie *movie) {
		return movie.trailer.link;
	}];
	
	RAC(self, trailerAvailable) = [RACObserve(self, movie) map:^(LRLMovie *movie) {
		return @(movie.trailer.link != nil);
	}];
	
	RAC(self, titleText) = [RACObserve(self, movie) map:^(LRLMovie *movie) {
		if(movie) {
			return [NSString stringWithFormat:@"%@ - (%@)",movie.title, movie.year];
		}
		return @"";
	}];
	
	RAC(self, plotText) = [RACObserve(self, movie) map:^(LRLMovie *movie) {
		return movie.plot;
	}];
	
	RAC(self, ratingText) = [RACObserve(self, movie) map:^(LRLMovie *movie) {
		if(movie.criticsRating) {
			return [NSString stringWithFormat:@"Rating: %@", movie.criticsRating];
		}
		return @"";
	}];
	
	RAC(self, countryText) = [RACObserve(self, movie) map:^(LRLMovie *movie) {
		return movie.country;
	}];
	
	RAC(self, coverImageURL) = [RACObserve(self, movie) map:^(LRLMovie *movie){
		return movie.artworkURL;
	}];
}

- (RACSignal *) movieSignal {
	@weakify(self)
	return [[[[self rac_signalForSelector:@selector(configureWithMovie:)]
		reduceEach:^(LRLMovie *movie) {
			@strongify(self)
			if(!movie) {
				return RACSignal.empty;
			}
			
			return [[[[[[[self.movieService
				detailedMovie:movie]
				initially:^{
					self.status = LRLViewModelStatusLoading;
				}]
				doNext:^(id x) {
					self.status = LRLViewModelStatusDone;
				}]
				doCompleted:^(){
					self.status = LRLViewModelStatusDone;
				}]
				doError:^(NSError *error) {
					self.status = LRLViewModelStatusErrored;
				}]
				catchTo:RACSignal.empty]
				startWith:movie];
		}]
		switchToLatest]
		distinctUntilChanged];
}

- (void) configureWithMovie:(LRLMovie *)movie {
	
}

@end
