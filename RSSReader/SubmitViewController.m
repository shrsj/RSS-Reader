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
    if(([self.storyTitle.text isEqualToString:@""] || [self.story.text isEqualToString:@""] || [self.author.text isEqualToString:@""] || [self.email.text isEqualToString:@""]))
    {
        [self displayAlert:@"Enter Valid Data in all Fields"];
        
    }
    else if ([self isValidEmail:self.email.text])
    {
        [self displayAlert:@"Enter valid email"];
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

-(void) clearDetails
{
    self.storyTitle.text = @"";
    self.story.text = @"";
    self.email.text = @"" ;
    self.author.text = @"Enter Your Story";
    self.aimage.image = nil;
}

-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
@end

/*******Regex*******/
//^[A-Z0-9._%+-]{1,64}@(?:[A-Z0-9-]{1,63}\.){1,125}[A-Z]{2,63}$ takes into account that the local part (before the @) is limited to 64 characters and that each part of the domain name is limited to 63 characters.
//^(?=[A-Z0-9._%+-]{6,254}$)[A-Z0-9._%+-]{1,64}@(?:[A-Z0-9-]{1,63}\.){1,8}[A-Z]{2,63}$ uses a lookahead to first check that the string doesn't contain invalid characters and isn't too short or too long. When the lookahead succeeds, the remainder of the regex makes a second pass over the string to check for proper placement of the @ sign and the dots.
//^[A-Z0-9][A-Z0-9._%+-]{0,63}@(?:[A-Z0-9](?:[A-Z0-9-]{0,62}[A-Z0-9])?\.){1,8}[A-Z]{2,63}$ //takes into account hiphens lookaheads and
