//
//  Created by Colin Eberhardt on 13/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

@import UIKit;
#import "FlickrSearchViewModel.h"
#import "SearchResultViewModel.h"

@interface RWTFlickrSearchViewController : UIViewController

- (instancetype)initWithViewModel:(FlickrSearchViewModel *)viewModel;
- (instancetype)initWithSearchResultViewModel:(SearchResultViewModel *)viewModel;
@end
