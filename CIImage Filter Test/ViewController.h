//
//  ViewController.h
//  CIImage Filter Test
//
//  Created by Kamal Uddin on 7/12/18.
//  Copyright © 2018 Kamal Uddin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "<AVFoundation/AVFoundation.h>"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationBarDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *filterNameLabel;

- (IBAction)imagePickerAction:(id)sender;
- (IBAction)filterValueChangeAction:(UISlider *)sender;
- (IBAction)originalImageAction:(UIButton *)sender;
- (IBAction)setFilterAction:(UIButton *)sender;
- (IBAction)ciFileter:(UIButton *)sender;

@end

