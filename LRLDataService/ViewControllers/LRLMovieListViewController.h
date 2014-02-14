//
//  LRLViewController.h
//  LRLDataService
//
//  Created by Lawrence Lomax on 30/01/2014.
//
//

#import <UIKit/UIKit.h>

@class LRLMovieService;

@interface LRLMovieListViewController : UITableViewController

+ (instancetype) viewControllerWithService:(LRLMovieService *)service;

@property (nonatomic, readonly) LRLMovieService *service;

@end
