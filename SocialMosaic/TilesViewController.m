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

CGFloat const MinimumZoomScale = 1.0;
NSInteger const TilesPerRow = 5;

@interface TilesViewController () <FastttCameraDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *mosaicTemplateImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet GridView *gridView;
@property (weak, nonatomic) IBOutlet UISlider *gridSizeSlider;
@property (strong, nonatomic) FastttCamera *camera;
@property (weak, nonatomic) TileCell *cameraCell;
@property (readonly, nonatomic) CGFloat maximumZoomScale;
@property (nonatomic) CGFloat minimumZoomScale;
@property (nonatomic) NSInteger tilesPerRow;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *zoomableView;
@property (nonatomic) CGFloat cameraZoomScale;
@end

@implementation TilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tilesPerRow = TilesPerRow;
    self.minimumZoomScale = MinimumZoomScale;
    self.gridView.cellsAcross = self.tilesPerRow;
    [self.mosaicTemplateImageView setImage:self.mosaicTemplateImage];
    [self initGridSizeSlider];
    [self initCollectionView];
    [self initCamera];
    [self initScrollView];
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
    self.camera.handlesZoom = NO;
    [self.camera zoomToScale:self.minimumZoomScale];
    self.camera.maxZoomFactor = self.maximumZoomScale;
    [self.camera willMoveToParentViewController:self];
    [self addChildViewController:self.camera];
    [self.camera didMoveToParentViewController:self];
}

- (void)initScrollView {
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = self.minimumZoomScale;
//    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewWasPinched:)];
//    pinchGestureRecognizer.delegate = self;
//    [self.scrollView addGestureRecognizer:pinchGestureRecognizer];
    [self.scrollView.pinchGestureRecognizer addTarget:self action:@selector(scrollViewWasPinched:)];
}

- (void)setTilesPerRow:(NSInteger)tilesPerRow {
    _tilesPerRow = tilesPerRow;
    self.gridView.cellsAcross = tilesPerRow;
    self.cameraCell = nil;
    [self.collectionView reloadData];

    CGFloat newMaximumZoomScale = self.maximumZoomScale;
    if (self.scrollView.zoomScale > newMaximumZoomScale) {
        [self.scrollView setZoomScale:newMaximumZoomScale animated:YES];
    }
    self.scrollView.maximumZoomScale = newMaximumZoomScale;
}

- (void)setMosaicTemplateImage:(UIImage *)mosaicTemplateImage {
    _mosaicTemplateImage = mosaicTemplateImage;
    [self.mosaicTemplateImageView setImage:mosaicTemplateImage];
}

- (CGFloat)maximumZoomScale {
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

- (void)scrollViewWasPinched:(UIPinchGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateChanged: {
            NSLog(@"Changed w/ sender.scale %f", sender.scale);
            if (sender.scale > self.maximumZoomScale) {
                self.cameraZoomScale = [self updateCameraZoomScaleFromPinchGestureRecognizerScale:sender.scale];
            } else if (self.cameraZoomScale > 1.0) {

            }
//            if (self.scrollView.zoomScale == self.scrollView.maximumZoomScale) {
//                NSLog(@"reached max zoom");
//                [self.camera zoomToScale:(self.zoomScale * sender.scale)];
//            }
            break;
        }

        case UIGestureRecognizerStateEnded: {
//            if (sender.scale > self.maximumZoomScale) {
//                self.zoomScale = self.maximumZoomScale;
//            } else if (sender.scale < self.minimumZoomScale) {
//                self.zoomScale = self.minimumZoomScale;
//            } else {
//                self.zoomScale = sender.scale;
//            }
            break;
        }

        default:
            break;
    }
}

- (void)setCameraZoomScale:(CGFloat)cameraZoomScale {
    _cameraZoomScale = cameraZoomScale;
    [self.camera zoomToScale:cameraZoomScale];
}

- (CGFloat)updateCameraZoomScaleFromPinchGestureRecognizerScale:(CGFloat)scale {
    return scale - self.maximumZoomScale + 1.0;
}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
//    NSLog(@"shouldRecognize? %@", self.cameraZoomScale > 1.0 ? @"YES" : @"NO");
//    return self.cameraZoomScale > 1.0;
//}
@end
