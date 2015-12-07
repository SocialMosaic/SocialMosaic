//
//  ViewController.m
//  SocialMosaic
//
//  Created by Jesse Pinho on 11/19/15.
//  Copyright © 2015 SocialMosaic. All rights reserved.
//

#import <FastttCamera.h>
#import "GridView.h"
#import "JPMultiScaleZoom.h"
#import "TileCell.h"
#import "TilesViewController.h"

int const TilesPerRow = 5;

@interface TilesViewController () <FastttCameraDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mosaicTemplateImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet GridView *gridView;
@property (weak, nonatomic) IBOutlet UISlider *gridSizeSlider;
@property (strong, nonatomic) FastttCamera *camera;
@property (weak, nonatomic) TileCell *cameraCell;
@property (readonly, nonatomic) CGFloat maximumZoomableViewScale;
@property (strong, nonatomic) JPMultiScaleZoom *multiScaleZoom;
@property (nonatomic) int tilesPerRow;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *zoomableView;
@end

@implementation TilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tilesPerRow = TilesPerRow;
    self.gridView.cellsAcross = self.tilesPerRow;
    [self.mosaicTemplateImageView setImage:self.mosaicTemplateImage];
    [self initGridSizeSlider];
    [self initCollectionView];
    [self initCamera];
    [self initScrollView];
    [self initMultiScaleZoom];
}

- (void)initGridSizeSlider {
    self.gridSizeSlider.value = self.tilesPerRow;
    [self.gridSizeSlider addTarget:self
                            action:@selector(gridSizeSliderDidChange:)
                  forControlEvents:UIControlEventValueChanged];
    [self.gridSizeSlider addTarget:self
                            action:@selector(gridSizeSliderDidFinishChanging:)
                  forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
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

- (void)initScrollView {
    self.scrollView.delegate = self;
}

- (void)setTilesPerRow:(int)tilesPerRow {
    _tilesPerRow = tilesPerRow;
    self.gridView.cellsAcross = tilesPerRow;
    self.cameraCell = nil;
    [self.collectionView reloadData];

    CGFloat newMaximumZoomScale = (float)self.tilesPerRow / 2.0;
    if (self.scrollView.zoomScale > newMaximumZoomScale) {
        [self.scrollView setZoomScale:newMaximumZoomScale animated:YES];
    }
//    self.scrollView.maximumZoomScale = newMaximumZoomScale;
}

- (void)setMosaicTemplateImage:(UIImage *)mosaicTemplateImage {
    _mosaicTemplateImage = mosaicTemplateImage;
    [self.mosaicTemplateImageView setImage:mosaicTemplateImage];
}

- (CGFloat)maximumZoomableViewScale {
    return (CGFloat)self.tilesPerRow / 2.0;
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

- (void)gridSizeSliderDidChange:(UISlider *)sender {
    self.gridView.cellsAcross = roundf(sender.value);
}

- (void)gridSizeSliderDidFinishChanging:(UISlider *)sender {
    self.tilesPerRow = roundf(sender.value);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.zoomableView;
}

- (void)initMultiScaleZoom {
    self.multiScaleZoom = [[JPMultiScaleZoom alloc] init];
    [self.multiScaleZoom addThresholdWithObject:self.zoomableView scaleStart:1.0 scaleEnd:self.maximumZoomableViewScale];
    [self.multiScaleZoom addThresholdWithObject:self.camera scaleStart:1.0 scaleEnd:4.0];
    self.multiScaleZoom.delegate = self;
}

- (void)multiScaleZoom:(JPMultiScaleZoom *)multiScaleZoom didUpdateZoomTo:(CGFloat)zoomLevel forObject:(NSObject *)object {
    if (object == self.zoomableView) {
        self.zoomableView.transform = CGAffineTransformMakeScale(zoomLevel, zoomLevel);
    } else if (object == self.camera) {
        [self.camera zoomToScale:zoomLevel];
    }
}

- (IBAction)zoomableViewWasPinched:(UIPinchGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateChanged:
            NSLog(@"%f", sender.scale);
            self.multiScaleZoom.scale = sender.scale;
            break;

        default:
            break;
    }
}
@end
