//
//  GalleryViewController.m
//  SocialMosaic
//
//  Created by Michael Hines on 11/25/15.
//  Copyright © 2015 SocialMosaic. All rights reserved.
//

#import "GalleryViewController.h"
#import "TilesViewController.h"
#import "ChooserImageCollectionViewCell.h"

@interface GalleryViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *galleryCollectionView;
@property (strong, nonatomic) NSArray *sampleImages;
@property (strong, nonatomic) UIImage *selectedImage;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sampleImages = @[@"sample", @"sample2"];
    self.galleryCollectionView.dataSource = self;
    self.galleryCollectionView.delegate = self;
    [self.galleryCollectionView registerNib:[UINib nibWithNibName:@"ChooserImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"chooserImage"];
    [self.galleryCollectionView selectItemAtIndexPath:[NSIndexPath indexPathWithIndex:0] animated:YES scrollPosition:UICollectionViewScrollPositionTop];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sampleImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChooserImageCollectionViewCell *cell = [self.galleryCollectionView dequeueReusableCellWithReuseIdentifier:@"chooserImage" forIndexPath:indexPath];
    [cell.chooserImageView setImage: [UIImage imageNamed:self.sampleImages[indexPath.item]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ChooserImageCollectionViewCell *cell = (ChooserImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.outlined = YES;
    self.selectedImage = cell.chooserImageView.image;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    ChooserImageCollectionViewCell *cell = (ChooserImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.outlined = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TilesViewController *vc = (TilesViewController *)[segue destinationViewController];
    NSLog(@"PREPARING FOR SEGUE");
    [vc setMosaicTemplateImage:self.selectedImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
