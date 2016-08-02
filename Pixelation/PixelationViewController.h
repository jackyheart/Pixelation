//
//  PixelationViewController.h
//  Pixelation
//
//  Created by Jacky on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PixelationViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *wSectionTF;
@property (nonatomic, retain) IBOutlet UITextField *hSectionTF;
@property (nonatomic, retain) IBOutlet UISlider *scaleSlider;
@property (nonatomic, retain) IBOutlet UIImageView *carDisplayImgView;
@property (nonatomic, retain) IBOutlet UILabel *breakWarningLabel;
@property (nonatomic, retain) IBOutlet UILabel *divisibleWarningLabel;
@property (nonatomic, retain) NSMutableArray *piecesImgViewMutArray;
@property (nonatomic, retain) NSMutableArray *piecesImgViewMutArray_retainer;//we need 2 mutable arrays for efficiency purpose

- (IBAction)onSliderChanged:(id)sender;
- (IBAction)breakBtnTapped:(id)sender;
- (IBAction)animatePixelBtnTapped:(id)sender;
- (IBAction)randomizeAlphaBtnTapped:(id)sender;


@end
