//
//  VerificationCodeScreen.m
//  MyWedding
//
//  Created by kaushik on 20/04/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "VerificationCodeScreen.h"

@interface VerificationCodeScreen ()

@end

@implementation VerificationCodeScreen
@synthesize Code1_TXT,Code2_TXT,Code3_TXT,Code4_TXT;

- (void)viewDidLoad
{
    [super viewDidLoad];
    Code1_TXT.enabled = YES;
    Code2_TXT.enabled = Code3_TXT.enabled = Code4_TXT.enabled  = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ((textField.text.length >= 1) && (string.length > 0))
    {
        NSInteger nextText = textField.tag + 1;
        UIResponder* nextResponder = [textField.superview viewWithTag:nextText];
        if (! nextResponder)
            [textField resignFirstResponder];
        if (nextResponder)
        {
            UITextField* nextTextfield= (UITextField*) [textField.superview viewWithTag:nextText];
            nextTextfield.enabled = YES;
            
            [nextResponder becomeFirstResponder];
            
            if ((nextTextfield.text.length < 1)){
                [nextTextfield setText:string];
            }
            
            textField.enabled = NO;
            return NO;
        }
    }
    else if ((textField.text.length >= 1) && (string.length == 0))
    {
        NSInteger prevTag = textField.tag - 1;
        // Try to find prev responder
        UIResponder* prevResponder = [textField.superview viewWithTag:prevTag];
        if (! prevResponder)
        {
            prevResponder = [textField.superview viewWithTag:1001];
        }
        else
        {
            UITextField *preTextField = (UITextField*)[textField.superview viewWithTag:prevTag];
            preTextField.enabled = YES;
            // Found next responder, so set it.
            [prevResponder becomeFirstResponder];
        }
        textField.text = @"";
        
        if (! prevTag)
        {
            textField.enabled = YES;
        }
        else
        {
            textField.enabled = NO;
        }
        
        return NO;
    }
    return YES;
}

@end
