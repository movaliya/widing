//
//  RegistrationVW.h
//  MyWedding
//
//  Created by Mango SW on 20/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationVW : UIViewController


@property (strong, nonatomic) NSString *CustomerID;

@property (weak, nonatomic) IBOutlet UITextField *FirstNameTXT;
@property (weak, nonatomic) IBOutlet UITextField *SecondNameTXT;
@property (weak, nonatomic) IBOutlet UITextField *MiddleNameTXT;
@property (weak, nonatomic) IBOutlet UITextField *LastNameTXT;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTXT;
@property (weak, nonatomic) IBOutlet UITextField *DateOfYearTXT;
@property (weak, nonatomic) IBOutlet UITextField *EmailTXT;
@property (weak, nonatomic) IBOutlet UITextField *VillNoTXT;
@property (weak, nonatomic) IBOutlet UITextField *StreetNameTXT;
@property (weak, nonatomic) IBOutlet UITextField *AreaTXT;
@property (weak, nonatomic) IBOutlet UITextField *ZoneTXT;
@property (weak, nonatomic) IBOutlet UITextField *ConfrimPasswordTXT;

@end
