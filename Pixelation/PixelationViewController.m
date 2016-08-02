//
//  PixelationViewController.m
//  Pixelation
//
//  Created by Jacky on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PixelationViewController.h"

#define ARC4RANDOM_MAX  0x100000000
#define ANIMATE_FPS 180.0

@interface PixelationViewController(private)

- (void)breakImageWithFileName:(NSString *)fileName andDivW:(int)divW andDivH:(int)divH withScale:(float)scale;

@end

@implementation PixelationViewController

@synthesize wSectionTF;
@synthesize hSectionTF;
@synthesize scaleSlider;
@synthesize carDisplayImgView;
@synthesize breakWarningLabel;
@synthesize divisibleWarningLabel;
@synthesize piecesImgViewMutArray;
@synthesize piecesImgViewMutArray_retainer;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [wSectionTF release];
    [hSectionTF release];
    [scaleSlider release];
    [carDisplayImgView release];
    [breakWarningLabel release];
    [divisibleWarningLabel release];  
    [piecesImgViewMutArray release];
    [piecesImgViewMutArray_retainer release];   
    
    [super dealloc];
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //=== init mutable arrays
    self.piecesImgViewMutArray = [NSMutableArray array];
    self.piecesImgViewMutArray_retainer = [NSMutableArray array];
    
    //=== show/hide views
    self.breakWarningLabel.hidden = YES;
    self.divisibleWarningLabel.hidden = YES;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Application logic

- (IBAction)onSliderChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    
    if(self.carDisplayImgView.subviews.count > 0)
    {
        for(UIView *v in self.carDisplayImgView.subviews)
        {
            v.transform = CGAffineTransformMakeScale(slider.value, slider.value);
        }
    }
}

- (IBAction)breakBtnTapped:(id)sender
{
    int divW = [self.wSectionTF.text intValue];
    int divH = [self.hSectionTF.text intValue];
    float scale = self.scaleSlider.value;
    
    self.breakWarningLabel.hidden = YES;
    self.divisibleWarningLabel.hidden = YES;
    
    
    [self breakImageWithFileName:@"bmw_i8.jpg" andDivW:divW andDivH:divH withScale:scale];
}

- (IBAction)animatePixelBtnTapped:(id)sender
{
    self.breakWarningLabel.hidden = YES;
    self.divisibleWarningLabel.hidden = YES;
    
    if(self.carDisplayImgView.subviews.count == 0)
    {
        self.breakWarningLabel.hidden = NO;
    }
    else if(self.carDisplayImgView.subviews.count > 0)
    {
        if([self.piecesImgViewMutArray count] == 0 && [self.piecesImgViewMutArray_retainer count] > 0)
        {
            //animation has been executed (at least once), so just grab the sliced images from the retainer array
            
            for(UIImageView *imgView in self.piecesImgViewMutArray_retainer)
            {
                //randomize the alpha again from the retainer array, so we got different alpha value on each run
                float alphaVal = ((float)arc4random() / ARC4RANDOM_MAX) * 0.5f;            
                imgView.alpha = alphaVal;
                
                [self.piecesImgViewMutArray addObject:imgView];
            }   
        }
        
        //clear the car display
        for(UIView *v in self.carDisplayImgView.subviews)
        {
            [v removeFromSuperview];
        }     
        
        [NSTimer scheduledTimerWithTimeInterval:1.0/ANIMATE_FPS target:self selector:@selector(animatePixelTimer:) userInfo:nil repeats:YES];
    }
}

- (IBAction)randomizeAlphaBtnTapped:(id)sender
{
    self.breakWarningLabel.hidden = YES;
    self.divisibleWarningLabel.hidden = YES;
    
    if(self.carDisplayImgView.subviews.count == 0)
    {
        self.breakWarningLabel.hidden = NO;
    }
    else if(self.carDisplayImgView.subviews.count > 0)
    {
        for(UIView *v in self.carDisplayImgView.subviews)
        {
            //generate a random alpha value
            float alphaVal = ((float)arc4random() / ARC4RANDOM_MAX) * 0.5f;            
            v.alpha = alphaVal;
        }
    }
}

#pragma mark - timer handler

- (void)animatePixelTimer:(NSTimer *)timer
{
    //keep animating until 'piecesImgViewMutArray' array runs out of pieces
    
    if([self.piecesImgViewMutArray count] == 0)
    {
        [timer invalidate];
        timer = nil;       
    }
    else if([self.piecesImgViewMutArray count] > 0)
    {
        //get random position in the mutable array
        int idx = arc4random() % [self.piecesImgViewMutArray count];
        
        //fetch the piece
        UIImageView *imgView = (UIImageView *)[self.piecesImgViewMutArray objectAtIndex:idx];
        
        //generate a random alpha value
        float alphaVal = ((float)arc4random() / ARC4RANDOM_MAX) * 0.5f;            
        imgView.alpha = alphaVal;
        
        [self.carDisplayImgView addSubview:imgView];
        
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction  animations:^(void) {
            
            imgView.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
            
        }];
        
        //remove the piece from the array
        [self.piecesImgViewMutArray removeObjectAtIndex:idx];       
    }
}

#pragma mark - private methods implementation

- (void)breakImageWithFileName:(NSString *)fileName andDivW:(int)divW andDivH:(int)divH withScale:(float)scale
{
    UIImage *fullImage = [UIImage imageNamed:fileName];
        
    if(fullImage)//sanity check
    {
        //NSLog(@"image w: %f", fullImage.size.width);
        //NSLog(@"image h: %f", fullImage.size.height); 
        
        int modW = (int)fullImage.size.width % divW;
        int modY = (int)fullImage.size.height % divH;
        
        if(modW == 0 && modY == 0)
        {
            //breaking new slices, clear all arrays
            [self.piecesImgViewMutArray removeAllObjects];
            [self.piecesImgViewMutArray_retainer removeAllObjects];
            
            int blockW = (int)fullImage.size.width / divW;
            int blockH = (int)fullImage.size.height / divH;
            
            for(int i=0; i < divH; i++)
            {
                for(int j=0; j < divW; j++)
                {
                    CGRect cropRect = CGRectMake(j * blockW, i * blockH, blockW, blockH);
                    CGImageRef imageRef = CGImageCreateWithImageInRect(fullImage.CGImage, cropRect);//do cropping
                    UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:fullImage.imageOrientation];
                    
                    //create a new UIImageView
                    UIImageView *anImageView = [[UIImageView alloc] initWithImage:newImage];
                    
                    //set frame
                    anImageView.frame = CGRectMake(j * (anImageView.frame.size.width), 
                                                   i * (anImageView.frame.size.height), 
                                                   anImageView.frame.size.width, 
                                                   anImageView.frame.size.height);       
                    
                    anImageView.transform = CGAffineTransformMakeScale(scale, scale);
                    
                    //generate a random alpha value
                    //float alphaVal = ((float)arc4random() / ARC4RANDOM_MAX) * 0.5f;            
                    //anImageView.alpha = alphaVal;
                    
                    [self.piecesImgViewMutArray addObject:anImageView];
                    [self.piecesImgViewMutArray_retainer addObject:anImageView];
                    
                    
                    [anImageView release];//release the UIImageView immediately (we have stored it in the mutable arrays)
                    
                    CGImageRelease(imageRef);
                }
            } 
            
            
            
            //==== display the pieces
            
            //clears the display
            for(UIView *v in self.carDisplayImgView.subviews)
            {
                [v removeFromSuperview];
            }
            
            //add the pieces to the display
            for(UIImageView *imgView in self.piecesImgViewMutArray)
            {
                [self.carDisplayImgView addSubview:imgView];
            }
        }
        else
        {
            if(modW != 0)
            {
                self.divisibleWarningLabel.hidden = NO;
                self.divisibleWarningLabel.text = NSLocalizedString(@"width not divisible", @"");
            }
            else if(modY != 0)
            {
                self.divisibleWarningLabel.hidden = NO;
                self.divisibleWarningLabel.text = NSLocalizedString(@"height not divisible", @"");
            }
        }      
    }
}

@end
