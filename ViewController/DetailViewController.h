//
//  DetailViewController.h
//  HYLFileManager
//
//  Created by HeYilei on 12/07/2015.
//  Copyright (c) 2015 HeYilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

