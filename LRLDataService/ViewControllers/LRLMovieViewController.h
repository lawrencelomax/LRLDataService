//
//  LRLMovieViewController.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 15/02/2014.
//
//

#import <UIKit/UIKit.h>

@class LRLMovie;
@class LRLMovieService;
@class LRLTrailer;

@interface LRLMovieViewController : UIViewController

+ (instancetype) viewControllerWithMovieService:(LRLMovieService *)service;

@property (nonatomic, readonly) LRLMovieService *movieService;
@property (nonatomic, strong) LRLMovie *movie;

@property (nonatomic, strong) IBOutlet UIImageView *coverImageView;

@property (nonatomic, strong) IBOutlet UILabel *ratingLabel;
@property (nonatomic, strong) IBOutlet UILabel *plotLabel;
@property (nonatomic, strong) IBOutlet UILabel *countryLabel;

@property (nonatomic, strong) IBOutlet UIButton *trailerButton;

@end
