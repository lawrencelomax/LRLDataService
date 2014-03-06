//
//  LRLMovieViewModel.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 26/02/2014.
//
//

#import <Foundation/Foundation.h>

#import "LRLViewModel.h"

@class LRLMovieService;
@class LRLMovie;

@interface LRLMovieViewModel : NSObject

+ (instancetype) viewModelWithService:(LRLMovieService *)service;

@property (nonatomic, readonly) LRLMovieService *movieService;
@property (nonatomic, readonly) LRLMovie *movie;

@property (nonatomic, readonly) NSURL *trailerLink;
@property (nonatomic, readonly) BOOL trailerAvailable;

@property (nonatomic, readonly) NSString *titleText;
@property (nonatomic, readonly) NSString *plotText;
@property (nonatomic, readonly) NSString *ratingText;
@property (nonatomic, readonly) NSString *countryText;

@property (nonatomic, readonly) NSURL *coverImageURL;

@property (nonatomic, readonly) LRLViewModelStatus status;

- (void) configureWithMovie:(LRLMovie *)movie;

@end