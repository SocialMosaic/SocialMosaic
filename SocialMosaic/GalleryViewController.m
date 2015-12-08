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

@interface GalleryViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *galleryCollectionView;
@property (strong, nonatomic) NSArray *sampleImages;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sampleImages = @[@"sample", @"sample2"];
    self.galleryCollectionView.dataSource = self;
    self.galleryCollectionView.delegate = self;
    [self.galleryCollectionView registerNib:[UINib nibWithNibName:@"ChooserImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"chooserImage"];
    [self.galleryCollectionView selectItemAtIndexPath:[NSIndexPath indexPathWithIndex:0] animated:YES scrollPosition:UICollectionViewScrollPositionTop];
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

- (IBAction)onChooseFromLibrary:(id)sender {
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
}

- (IBAction)onTakePhoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.allowsEditing = NO;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"TilesViewController" sender:info];
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
    [self performSegueWithIdentifier:@"TilesViewController" sender:cell];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TilesViewController *vc = (TilesViewController *)[segue destinationViewController];
    if ([sender isKindOfClass:[ChooserImageCollectionViewCell class]]) {
        UIImage *image = ((ChooserImageCollectionViewCell *)sender).chooserImageView.image;
        vc.mosaicTemplateImage = image;
    } else if ([sender isKindOfClass:[NSDictionary class]]) { // TODO: Figure out a better way to determine this came from the image picker.
        UIImage *image = ((NSDictionary *)sender)[@"UIImagePickerControllerOriginalImage"];
        vc.mosaicTemplateImage = image;
    }
}
@end
