//
//  ViewController.m
//  SocialMosaic
//
//  Created by Jesse Pinho on 11/19/15.
//  Copyright © 2015 SocialMosaic. All rights reserved.
//

#import <FastttCamera.h>
#import "GridView.h"
#import "TilesViewController.h"

int const TilesPerRow = 5;

@interface TilesViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet GridView *gridView;
@property (strong, nonatomic) FastttCamera *camera;
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
    self.camera = [FastttCamera new];
    self.camera.delegate = self;
    [self.camera willMoveToParentViewController:self];
    [self addChildViewController:self.camera];
    [self.camera didMoveToParentViewController:self];
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
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell addSubview:self.camera.view];
    self.camera.view.frame = cell.bounds;
}

- (IBAction)onShutterButton:(id)sender {
    [self.camera takePicture];
}

- (void)cameraController:(id<FastttCameraInterface>)cameraController didFinishNormalizingCapturedImage:(FastttCapturedImage *)capturedImage {
    NSLog(@"didFinishNormalizingCapturedImage");
}
@end
