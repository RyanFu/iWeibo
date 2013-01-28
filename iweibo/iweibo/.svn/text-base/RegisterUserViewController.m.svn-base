//
//  RegisterUserViewController.m
//  iweibo
//
//  Created by Yi Minwen on 6/21/12.
//  Copyright (c) 2012 Beyondsoft. All rights reserved.
//

#import "RegisterUserViewController.h"
#import "IWBSvrSettingsManager.h"
#import "NSString+QEncoding.h"
#import "UserAuthBindingWebViewController.h"

@implementation RegisterUserViewController
@synthesize enumAuthStatus, parentViewControllerId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    api = [[IWeiboAsyncApi alloc] init];
    enumAuthStatus = NEVER_AUTH;
    bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registerBg.png"]];
    bgView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bgView];
    UIImage *viewSearchImg = [UIImage imageNamed:@"subScribeTitleBg.png"];
	UIImageView	*viewSearchBG = [[UIImageView alloc] initWithImage:viewSearchImg];
	viewSearchBG.userInteractionEnabled = YES;
    UIImageView *imgBG = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    imgBG.backgroundColor = [UIColor blackColor];
    imgBG.userInteractionEnabled = YES;
//    [imgBG addSubview:viewSearchBG];
	[self.view addSubview:imgBG];
    [self.view bringSubviewToFront:imgBG];
	[self.view addSubview:viewSearchBG];
    [self.view bringSubviewToFront:viewSearchBG];
	[viewSearchBG release];
    [imgBG release];
	UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	leftButton.frame = CGRectMake(4, 5, 50, 30);
	[leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.titleLabel.shadowOffset = CGSizeMake(-1.0f, 2.0f);
	leftButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	[leftButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 12, 5, 5)];
	[leftButton setBackgroundImage:[UIImage imageNamed:@"subScribeNav.png"] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[viewSearchBG addSubview:leftButton];
	UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 11, 200, 20)];
	[customLab setTextColor:[UIColor whiteColor]];
	[customLab setText:@"注册"];
	[customLab setTextAlignment:UITextAlignmentCenter];
	customLab.backgroundColor = [UIColor clearColor];
	customLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [viewSearchBG addSubview:customLab];
	[customLab release];
    // 显示用户名的背景图片
	nameBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registerInputFrame.png"]];
	nameBg.frame = CGRectMake(18, 68.0f, 286.0f, 39.0f);
    nameBg.userInteractionEnabled = YES;
    nameBg.tag = NAME_BG_TAG;
	[bgView addSubview:nameBg];
    // 显示用户图像的图片
	UIImageView *nameHead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registerUser.png"]];
	nameHead.frame = CGRectMake(10.0f, 9.0f, 15.0f, 18.0f);
	[nameBg addSubview:nameHead];
	[nameHead release];
    
    usrTextField = [self createTextFieldWithRect:CGRectMake(32.0f, 11.0f, 240.0f, 25.0f) placeHolder:@"用户名"];
    usrTextField.tag = TEXTFIELD_TAG;
    usrTextField.keyboardType = UIKeyboardTypeDefault;
    usrTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [nameBg addSubview:usrTextField];
	
	// 显示密码的背景图片
	emailBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registerInputFrame.png"]];
	emailBg.frame = CGRectMake(18.0f, 117.0f, 286.0f, 39.0f);
    emailBg.userInteractionEnabled = YES;
    emailBg.tag = EMAIL_BG_TAG;
	[bgView addSubview:emailBg];
    // 显示邮箱的图片
	UIImageView *emailHead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registerEmail.png"]];
	emailHead.frame = CGRectMake(10.0f, 13.0f, 17.0f, 13.0f);
	[emailBg addSubview:emailHead];
	[emailHead release];
    emailTextField = [self createTextFieldWithRect:CGRectMake(32.0f, 11.0f, 240.0f, 25.0f) placeHolder:@"邮箱地址"];
    emailTextField.tag = TEXTFIELD_TAG;
    emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [emailBg addSubview:emailTextField];
    // 显示密码的背景图片
	pwdBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registerInputFrame.png"]];
	pwdBg.frame = CGRectMake(18.0f, 166.0f, 286.0f, 39.0f);
    pwdBg.userInteractionEnabled = YES;
    pwdBg.tag = PWD_BG_TAG;
	[bgView addSubview:pwdBg];
    // 显示密码的图片
	UIImageView *pwdHead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registerLock.png"]];
	pwdHead.frame = CGRectMake(10.0f, 9.0f, 15.0f, 18.0f);
	[pwdBg addSubview:pwdHead];
	[pwdHead release];
    pwdTextField = [self createTextFieldWithRect:CGRectMake(32.0f, 11.0f, 240.0f, 25.0f)  placeHolder:@"密码"];
    pwdTextField.tag = TEXTFIELD_TAG;
    pwdTextField.secureTextEntry = YES;
    [pwdBg addSubview:pwdTextField];
    // 显示密码的背景图片
	pwdRetryBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registerInputFrame.png"]];
	pwdRetryBg.frame = CGRectMake(18, 215.0f, 286.0f, 39.0f);
    pwdRetryBg.userInteractionEnabled = YES;
    pwdRetryBg.tag = PWD_RETRY_BG_TAG;
	[bgView addSubview:pwdRetryBg];
    // 显示密码的图片
	UIImageView *pwdRetryHead = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registerLock.png"]];
	pwdRetryHead.frame = CGRectMake(10.0f, 9.0f, 15.0f, 18.0f);
	[pwdRetryBg addSubview:pwdRetryHead];
	[pwdRetryHead release];
    pwdRetryTextField = [self createTextFieldWithRect:CGRectMake(32.0f, 11.0f, 240.0f, 25.0f)  placeHolder:@"重复密码"];
    pwdRetryTextField.tag = TEXTFIELD_TAG;
    pwdRetryTextField.secureTextEntry = YES;
    [pwdRetryBg addSubview:pwdRetryTextField];
    // 注册
    btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"registerClickBtn.png"] forState:UIControlStateNormal];
    btnRegister.titleLabel.text = @"注册";
    btnRegister.titleLabel.textAlignment = UITextAlignmentCenter;
    btnRegister.frame = CGRectMake(18.0f, 269.0f, 286.0f, 39.0f);
    [btnRegister addTarget:self action:@selector(onRegister) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btnRegister];
}

-(void)back {
    [usrTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
    [pwdTextField resignFirstResponder];
    [pwdRetryTextField resignFirstResponder];
	//[self.navigationController setNavigationBarHidden:YES animated:NO];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[pwdRetryBg release];
    pwdRetryBg = nil;
	[pwdBg release];
    pwdBg = nil;
	[nameBg release];
    nameBg = nil;
	[emailBg release];
    emailBg = nil;
    [bgView release];
    bgView = nil;    
}

-(void)dealloc {
    [api cancelSpecifiedRequest];
    [api release];
    
	[pwdRetryBg release];
    pwdRetryBg = nil;
    [pwdBg release];
    pwdBg = nil;
	[nameBg release];
    nameBg = nil;
	[emailBg release];
    emailBg = nil;
    [bgView release];
    bgView = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(UITextField *)createTextFieldWithRect:(CGRect)rect placeHolder:(NSString *)strHolder {
    UITextField *tf = [[UITextField alloc] initWithFrame:rect];
    tf.borderStyle = UITextBorderStyleNone;
    tf.textColor = [UIColor blackColor];
    tf.font = [UIFont systemFontOfSize:14.0];
    tf.backgroundColor = [UIColor clearColor];
    tf.placeholder = strHolder;
    tf.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
    tf.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
    tf.returnKeyType = UIReturnKeyDone;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
    tf.delegate = self;
    return [tf autorelease];
}

//利用正则表达式验证

-(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    return [emailTest evaluateWithObject:email];
    
}
-(NSInteger)checkItems {
    NSInteger nResult = 0;
    // 名称验证: 3 到 15 个字符组成,不能含有"|<>
    if ([usrTextField.text length] == 0) {
        nResult = -1;
        markedTextFieldIndex = 0;
        return nResult;
    }
    NSString *strUser = usrTextField.text;
    if ([strUser length] > 15 || [strUser length] < 3) {
        nResult = -6;
        markedTextFieldIndex = 0;
        return nResult;
    }
    NSRange rangQuote = [strUser rangeOfString:@"""" options:NSCaseInsensitiveSearch];
    NSRange rangS = [strUser rangeOfString:@"|" options:NSCaseInsensitiveSearch];
    NSRange rangT = [strUser rangeOfString:@"<" options:NSCaseInsensitiveSearch];
    NSRange rangF = [strUser rangeOfString:@">" options:NSCaseInsensitiveSearch];
    if (rangQuote.location != NSNotFound || rangS.location != NSNotFound
        || rangT.location != NSNotFound || rangF.location != NSNotFound)
    {
        nResult = -6;
        markedTextFieldIndex = 0;
        return nResult;
    }
    // 邮箱验证
    if (![self isValidateEmail:emailTextField.text]) {
        nResult = -2;
        markedTextFieldIndex = 1;
        return nResult;
    }
    // 密码验证
    if (([pwdTextField.text length] < 3) || ([pwdTextField.text length] > 15)) {
        nResult = -3;
        markedTextFieldIndex = 2;
        return nResult;
    }
    if ([pwdRetryTextField.text length] == 0) {
        nResult = -4;
        markedTextFieldIndex = 3;
        return nResult;
    }
    if (![pwdRetryTextField.text isEqualToString:pwdTextField.text] ) {
        nResult = -5;
        markedTextFieldIndex = 3;
        return nResult;
    }
    return nResult;
}

- (void)showAlert: (NSString *) theMessage{
    UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"错误" message:theMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [av show];
}

-(void)checkErrorItemClicked {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
    UIImageView *markedItemView = (UIImageView *)[bgView viewWithTag:(NAME_BG_TAG + markedTextFieldIndex)];
    [[markedItemView viewWithTag:ERROR_BG_TAG] removeFromSuperview];
	[UIView commitAnimations];
    [(UITextField *)[markedItemView viewWithTag:TEXTFIELD_TAG] becomeFirstResponder];
    markedTextFieldIndex = -1;
}

- (void)showCheckError:(NSString *)theMessage{
    [[nameBg viewWithTag:ERROR_BG_TAG] removeFromSuperview];
    [[emailBg viewWithTag:ERROR_BG_TAG] removeFromSuperview];
    [[pwdBg viewWithTag:ERROR_BG_TAG] removeFromSuperview];
    [[pwdRetryBg viewWithTag:ERROR_BG_TAG] removeFromSuperview];
    UIImageView *imgErrBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registerInputWrong.png"]];
    imgErrBg.tag = ERROR_BG_TAG;
    imgErrBg.frame = CGRectMake(-2.0f, -2.0f, 289.0f, 43.0f);
    // 描述文本
    imgErrBg.userInteractionEnabled = YES;
    UILabel *lbDes = [[UILabel alloc] initWithFrame:CGRectMake(34.0f, 9.0f, 200.0f, 25.0f)];
    lbDes.text = theMessage;
    lbDes.font = [UIFont systemFontOfSize:14.0];
    lbDes.textColor = [UIColor colorWithRed:232.0f/255.0f green:49.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
    lbDes.backgroundColor = [UIColor clearColor];
    lbDes.userInteractionEnabled = YES;
    UITapGestureRecognizer *stateClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkErrorItemClicked)];
    [lbDes addGestureRecognizer:stateClick];
    [stateClick release];
    [imgErrBg addSubview:lbDes];
    [lbDes release];
    UIImageView *markedItemView = (UIImageView *)[bgView viewWithTag:(NAME_BG_TAG + markedTextFieldIndex)];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
    [markedItemView addSubview:imgErrBg];
	[UIView commitAnimations];
    [imgErrBg release];
}

-(void)onRegisterSuccess:(NSDictionary *)result {
    btnRegister.enabled = YES;
	NSString *msg = [result objectForKey:@"msg"];
    if ([[result objectForKey:@"ret"] intValue] != 0) {
        [self showAlert:[msg URLDecodedString]];
        return;
    }
    // 注册成功跳转到授权页面
    UserAuthBindingWebViewController *webUrlViewController = [[UserAuthBindingWebViewController alloc] init];
	NSString *str = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite.descriptionInfo.svrUrl;
	webUrlViewController.parentViewControllerId = self;
    webUrlViewController.graParentViewControllerId = parentViewControllerId;
    NSString *strEncodeName =[usrTextField.text URLEncodedString];
	webUrlViewController.webUrl = [NSString stringWithFormat:@"%@private/authorize?user=%@", str, strEncodeName];
	//webUrlViewController.webUrl = @"http://open.t.qq.com/cgi-bin/authorize?oauth_token=06201f23f0b44a12ba3054a57c5d1a37&wap=2";
	[self.navigationController pushViewController:webUrlViewController animated:YES];
	[webUrlViewController release];
	CLog(@"%s,result:%@, msg:%@", __FUNCTION__, result, [msg URLDecodedString]);
}

-(void)onRegisterFailure:(NSError *)error {
    btnRegister.enabled = YES;
    [self showAlert:[error localizedDescription]];
	CLog(@"%s,result:%@", __FUNCTION__, [error localizedDescription]);
}

-(void)onRegister {
    // 输入检测
    [usrTextField resignFirstResponder];
    [emailTextField resignFirstResponder];
    [pwdTextField resignFirstResponder];
    [pwdRetryTextField resignFirstResponder];
    [self performSelectorOnMainThread:@selector(scrollIfNeeded:) withObject:[NSNumber numberWithFloat:230.0f] waitUntilDone:NO];
    NSInteger nResult = [self checkItems];
    if (nResult == 0) {
        btnRegister.enabled = NO;
        NSMutableDictionary *par = [NSMutableDictionary dictionaryWithCapacity:3];
        [par setObject:@"json" forKey:@"format"];
        [par setObject:@"private/reg" forKey:@"request_api"];
        [par setObject:usrTextField.text forKey:@"user"];
        [par setObject:pwdTextField.text forKey:@"pwd"];
        [par setObject:emailTextField.text forKey:@"email"];
        NSString *str = [IWBSvrSettingsManager sharedSvrSettingManager].activeSite.descriptionInfo.svrUrl;
        if (api == nil) {
            api = [[IWeiboAsyncApi alloc] init];
        }
        [api iweiboRegisterUserWithUrl:str
                            Parameters:par 
                              delegate:self
                             onSuccess:@selector(onRegisterSuccess:) onFailure:@selector(onRegisterFailure:)];
    }
    else {
        switch (nResult) {
            case -6:
            case -1:
                [self showCheckError:@"3 到 15 个字符组成,不能含有|<>"];
                break;
            case -2:
                [self showCheckError:@"邮箱格式不正确"];
                break;
            case -3:
                [self showCheckError:@"密码长度为3~15字符"];
                break;
            case -4:
            case -5:
                [self showCheckError:@"重复密码有误"];
                break;
            default:
                break;
        }
    }
}



- (void)scrollIfNeeded:(NSNumber *)yCenterPos {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
    bgView.center = CGPointMake(bgView.center.x, [yCenterPos floatValue]);
	[UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == usrTextField) {
        // 不位移
        [self performSelectorOnMainThread:@selector(scrollIfNeeded:) withObject:[NSNumber numberWithFloat:230.0f] waitUntilDone:NO];
    }
    else if (textField == emailTextField) {
        // 68.0f - 44.0f - 10.0f = 14.0f
        [self performSelectorOnMainThread:@selector(scrollIfNeeded:) withObject:[NSNumber numberWithFloat:230.0f - 14.0f] waitUntilDone:NO];
    }
    else if (textField == pwdTextField) {
        [self performSelectorOnMainThread:@selector(scrollIfNeeded:) withObject:[NSNumber numberWithFloat:230.0f - (14.0f +  49.0f)] waitUntilDone:NO];
    }
    else if (textField == pwdRetryTextField) {
        [self performSelectorOnMainThread:@selector(scrollIfNeeded:) withObject:[NSNumber numberWithFloat:230.0f - (14.0f + 2 * 49.0f)] waitUntilDone:NO];
    }
}

//改变输入框焦点
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self performSelectorOnMainThread:@selector(scrollIfNeeded:) withObject:[NSNumber numberWithFloat:230.0f] waitUntilDone:NO];
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	[super viewWillAppear:animated];
//    if (enumAuthStatus != NEVER_AUTH) {
//        if (enumAuthStatus == SUCCEED_AUTH) {
//            // 传递账号密码
//            if (nil != parentViewControllerId) {
//                parentViewControllerId.usrTextField.text = usrTextField.text;
//                parentViewControllerId.pwdTextField.text = pwdTextField.text;
//            }
//        }
//        
//        if ([parentViewControllerId respondsToSelector:@selector(updateAuthStatus:)]) {
//            [parentViewControllerId updateAuthStatus:enumAuthStatus];
//        }
//        [self performSelector:@selector(back) withObject:nil afterDelay:0.5f];
//        enumAuthStatus = NEVER_AUTH;
//    }
}

// 更新授权状态
-(void)updateAuthStatus:(ENUMAUTHSTATUS)status {
    self.enumAuthStatus = status;
    if (enumAuthStatus == SUCCEED_AUTH) {
        // 传递账号密码
        if (nil != parentViewControllerId) {
            parentViewControllerId.usrTextField.text = usrTextField.text;
            parentViewControllerId.pwdTextField.text = pwdTextField.text;
        }
    }
    
    if ([parentViewControllerId respondsToSelector:@selector(updateAuthStatus:)]) {
        [parentViewControllerId updateAuthStatus:enumAuthStatus];
    }
}
@end
