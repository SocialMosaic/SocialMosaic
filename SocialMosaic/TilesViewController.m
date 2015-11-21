//
//  ViewController.m
//  SocialMosaic
//
//  Created by Jesse Pinho on 11/19/15.
//  Copyright © 2015 SocialMosaic. All rights reserved.
//

#import "GridView.h"
#import "TilesViewController.h"

int const TilesPerRow = 5;

@interface TilesViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet GridView *gridView;
@property (strong, nonatomic) UIImagePickerController *camera;
@property (nonatomic) int tilesPerRow;
@end

@implementation TilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tilesPerRow = TilesPerRow;
    self.gridView.cellsAcross = self.tilesPerRow;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self initCamera];
}

- (void)initCamera {
    if ([self cameraIsAvailable]) {
        self.camera = [[UIImagePickerController alloc] init];
        self.camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.camera.allowsEditing = NO;
        self.camera.showsCameraControls = NO;
        [self initCameraViewTransform];
    }
}

- (BOOL)cameraIsAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
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
    if ([self cameraIsAvailable]) {
        [self.camera willMoveToParentViewController:self];
        [[collectionView cellForItemAtIndexPath:indexPath] addSubview:self.camera.view];
        [self.camera didMoveToParentViewController:self];
    }
}

- (void)initCameraViewTransform {
    CGFloat ratioOfCellToView = 1.0 / self.tilesPerRow;
    CGFloat inverseOfRatioOfCellToView = 1.0 - ratioOfCellToView;
    CGFloat correctionForScaledPixels = (float)self.tilesPerRow;
    CGFloat correctionForPhotoAspectRatio = 0.75;
    CGFloat leftOffset = self.view.frame.size.width * inverseOfRatioOfCellToView * 0.5;
    CGFloat topOffset = self.view.frame.size.height * inverseOfRatioOfCellToView * 0.5;
    CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(-(leftOffset * correctionForScaledPixels), -(topOffset * correctionForScaledPixels * correctionForPhotoAspectRatio));
    CGAffineTransform transformScale = CGAffineTransformMakeScale(ratioOfCellToView, ratioOfCellToView);
    self.camera.cameraViewTransform = CGAffineTransformConcat(transformTranslate, transformScale);
}
@end
