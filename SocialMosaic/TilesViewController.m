//
//  ViewController.m
//  SocialMosaic
//
//  Created by Jesse Pinho on 11/19/15.
//  Copyright © 2015 SocialMosaic. All rights reserved.
//

#import <FastttCamera.h>
#import "GridView.h"
#import "TileCell.h"
#import "TilesViewController.h"

int const TilesPerRow = 5;

@interface TilesViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet GridView *gridView;
@property (weak, nonatomic) IBOutlet UISlider *gridSizeSlider;
@property (strong, nonatomic) FastttCamera *camera;
@property (weak, nonatomic) TileCell *cameraCell;
@property (nonatomic) int tilesPerRow;
- (IBAction)changeGridSizeSlider:(UISlider *)sender;
@end

@implementation TilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tilesPerRow = TilesPerRow;
    self.gridView.cellsAcross = self.tilesPerRow;
    self.gridSizeSlider.value = self.tilesPerRow;
    [self initCollectionView];
    [self initCamera];
}

- (void)initCollectionView {
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"TileCell" bundle:nil] forCellWithReuseIdentifier:@"TileCell"];
}

- (void)initCamera {
    self.camera = [FastttCamera new];
    self.camera.delegate = self;
    [self.camera willMoveToParentViewController:self];
    [self addChildViewController:self.camera];
    [self.camera didMoveToParentViewController:self];
}

- (void)setTilesPerRow:(int)tilesPerRow {
    _tilesPerRow = tilesPerRow;
    self.gridView.cellsAcross = tilesPerRow;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"TileCell" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tilesPerRow * self.tilesPerRow;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellSize = self.collectionView.frame.size.width / self.tilesPerRow;
    return CGSizeMake(cellSize, cellSize);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.cameraCell = (TileCell *)[collectionView cellForItemAtIndexPath:indexPath];;
}

- (void)setCameraCell:(TileCell *)cameraCell {
    _cameraCell = cameraCell;
    [self.camera.view removeFromSuperview];
    if (cameraCell) {
        [cameraCell.cameraView addSubview:self.camera.view];
        self.camera.view.frame = cameraCell.bounds;
    }
}

- (IBAction)onShutterButton:(id)sender {
    if (self.cameraCell) {
        [self.camera takePicture];
    }
}

- (IBAction)onSaveButton:(id)sender {
    [self saveMosaic];
}

- (void)saveMosaic {
    UIGraphicsBeginImageContext(self.collectionView.frame.size);
    [self.collectionView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *mosaic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(mosaic, nil, nil, nil);
}

- (void)cameraController:(id<FastttCameraInterface>)cameraController didFinishCapturingImage:(FastttCapturedImage *)capturedImage {
    self.cameraCell.imageView.image = capturedImage.rotatedPreviewImage;
    self.cameraCell = nil;
}

- (IBAction)changeGridSizeSlider:(UISlider *)sender {
    self.tilesPerRow = roundf(sender.value);
}
@end
