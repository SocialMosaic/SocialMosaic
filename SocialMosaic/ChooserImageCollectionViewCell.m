//
//  ChooserImageCollectionViewCell.m
//  SocialMosaic
//
//  Created by Michael Hines on 11/25/15.
//  Copyright © 2015 SocialMosaic. All rights reserved.
//

#import "ChooserImageCollectionViewCell.h"

@implementation ChooserImageCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.chooserImageView.layer setCornerRadius:15.0f];
}

@end
