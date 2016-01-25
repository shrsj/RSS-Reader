//
//  SubmitViewController.m
//  RSSReader
//
//  Created by Mac-Mini-2 on 11/12/15.
//  Copyright © 2015 Mac-Mini-2. All rights reserved.
//

#import "SubmitViewController.h"

@interface SubmitViewController ()
{
    MFMailComposeViewController *mc;
    UIImagePickerController *imagePickerController;
    UIPopoverPresentationController *pop;
}

@end

@implementation SubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)send:(UIButton *)sender
{
    if([self.storyTitle.text isEqualToString:@""] )
    {
        [self animateField:self.storyTitle];
    }
    else if([self.story.text isEqualToString:@""] )
    {
        [self animateField:self.story];
    }
    else if([self.author.text isEqualToString:@""])
    {
        [self animateField:self.author];
    }
    else if ([self.email.text isEqualToString:@""])
    {
        [self animateField:self.email];
    }
    else
    {
        BOOL validate =[self validateEmail:self.email.text];
        if (!validate)
        {
            self.warning.text = @"Enter valid email";
            
            CAKeyframeAnimation *animation =[CAKeyframeAnimation animation];
            animation.keyPath = @"position.x";
            animation.values =   @[ @0,  @10, @-10,@10,@-10, @0];
            animation.keyTimes = @[ @0, @(1 / 6.0), @(2 / 6.0),@(3 / 6.0), @(5 / 6.0), @1 ];
            animation.duration = 0.6;
            
            animation.additive = YES;
            
            [self.email.layer addAnimation:animation forKey:@"shake"];
        }
        else
        {
            // Email Subject
            NSString *emailTitle = @"Submit Story";
            
            // Email Content
            NSString *storyTitle = self.storyTitle.text;
            NSString *storyContent = self.story.text;
            NSString *authorInfor = [NSString stringWithFormat:@" Author Name : %@ \n Author email : %@",self.author.text,self.email.text];
            NSString *messageBody = [NSString stringWithFormat:@" Story Title: %@ \n Story Content \n %@ \n %@", storyTitle , storyContent , authorInfor];
            
            // To address
            NSArray *toRecipents = [NSArray arrayWithObject:@"shravan@sjinnovation.com"];
            mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            [mc setSubject:emailTitle];
            [mc setMessageBody:messageBody isHTML:NO];
            [mc setToRecipients:toRecipents];
            
            UIImage *myImage = self.aimage.image;
            if (myImage != nil)
            {
                NSData *myImageData = UIImagePNGRepresentation(myImage);
                // Add attachment
                [mc addAttachmentData:myImageData mimeType:@"image/png" fileName:@"cover.png"];
            }
            
            // Present mail view controller on screen
            [self presentViewController:mc animated:YES completion:NULL];
        }
        
    }
}
- (IBAction)attach:(UIButton *)sender
{
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.aimage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    NSLog(@"%@",savedImagePath);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) displayAlert: (NSString *) msg
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"RSS Feeds"
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)animateField:(id)textBox
{
    CAKeyframeAnimation *animation =[CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values =   @[ @0,  @10, @-10,@10,@-10, @0];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(2 / 6.0),@(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.6;
    
    animation.additive = YES;
    
    if ([(id)textBox isKindOfClass:[UITextField class]])
    {
        [((UITextField*)textBox).layer addAnimation:animation forKey:@"shake"];
        self.warning.text = @"Please Fill in all the details";
    }
    else if ([(id)textBox isKindOfClass:[UITextView class]])
    {
        [((UITextView*)textBox).layer addAnimation:animation forKey:@"shake"];
        self.warning.text = @"Please Fill in the story";
    }
}


-(void) clearDetails
{
    self.storyTitle.text = @"";
    self.story.text = @"";
    self.email.text = @"" ;
    self.author.text = @"Enter Your Story";
    self.aimage.image = nil;
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    BOOL test  = [emailTest evaluateWithObject:candidate];
    NSLog(@"email is valid ?? %d", test );
    return [emailTest evaluateWithObject:candidate];
}

@end


