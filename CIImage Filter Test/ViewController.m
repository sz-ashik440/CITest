//
//  ViewController.m
//  CIImage Filter Test
//
//  Created by Kamal Uddin on 7/12/18.
//  Copyright © 2018 Kamal Uddin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(weak, nonatomic) UIImage *snappedImage;
@property UIView *blurView;
@property NSArray *filterList;
@property UIImageView *filteredImageView;
@property BOOL isBlurOn;
@property BOOL isFilterOn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)imagePickerAction:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Pick Image" message:@"Pick an image for editing." preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate: self];
    
    picker.allowsEditing = YES;
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Photo Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}


- (IBAction)filterValueChangeAction:(UISlider *)sender {
    if (self.blurView != nil) {
        self.blurView.alpha = sender.value;
    }
}

- (IBAction)originalImageAction:(UIButton *)sender {
    if (self.blurView != nil) {
        [self.blurView removeFromSuperview];
        self.blurView = nil;
        self.isBlurOn = NO;
    }
    
    if (self.filteredImageView != nil) {
        [self.filteredImageView removeFromSuperview];
        self.filteredImageView = nil;
    }
    self.imageView.image = self.snappedImage;
    
//    [self.b]
}

-(UIImage *) makeImageFromView: (UIView *) view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (IBAction)setFilterAction:(UIButton *)sender {
    if (self.blurView != nil && self.isBlurOn==YES) {
        return;
    }
    
    self.blurView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    self.blurView.backgroundColor = UIColor.whiteColor;
    self.blurView.alpha = 0.5;
    self.blurView.frame = self.imageView.bounds;
    
    [self.imageView addSubview: self.blurView];
    [[self view] bringSubviewToFront: self.blurView];
    self.isBlurOn = YES;
}

- (IBAction)ciFileter:(UIButton *)sender {
    
    if (self.snappedImage != nil && self.blurView != nil) {
        UIImage *filteredImage = [self makeImageFromView:self.blurView];
        self.filteredImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];

        [self.filteredImageView setImage:filteredImage];

        self.filteredImageView.frame = self.imageView.bounds;
        
        [self.blurView removeFromSuperview];
        [self.imageView addSubview:self.filteredImageView];
        [[self view] bringSubviewToFront:self.filteredImageView];
//        self.imageView.isHidden = YES;
        [self.imageView setHidden:YES];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.snappedImage = chosenImage;
    self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(UIImage *)applyFilter: (UIImage *) originalImage {
    CGColorRef colorRef = [UIColor redColor].CGColor;
    NSString *colorString = [CIColor colorWithCGColor:colorRef].stringRepresentation;
    CIColor *coreColor = [CIColor colorWithString:colorString];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:originalImage];
    
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    [filter setValue:@1.0 forKey:@"inputIntensity"];

    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGRect extent = [result extent];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    
    UIImage *filteredImage = [[UIImage alloc] initWithCGImage:cgImage];
    
    return filteredImage;
}

@end
