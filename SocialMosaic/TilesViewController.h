//
//  ViewController.h
//  SocialMosaic
//
//  Created by Jesse Pinho on 11/19/15.
//  Copyright © 2015 SocialMosaic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TilesViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (strong, nonatomic) UIImage *mosaicTemplateImage;
@end
