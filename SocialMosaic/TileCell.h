//
//  TileCell.h
//  SocialMosaic
//
//  Created by Jesse Pinho on 11/20/15.
//  Copyright © 2015 SocialMosaic. All rights reserved.
//

#import <FastttCamera.h>
#import <UIKit/UIKit.h>

@interface TileCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
