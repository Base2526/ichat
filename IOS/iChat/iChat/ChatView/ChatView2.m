//
//  ChatView2.m
//  iChat
//
//  Created by Somkid on 29/9/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import "ChatView2.h"
#import "Configs.h"
#import "InviteFriends.h"
#import "MessageRepo.h"
#import "Message.h"
#import "UIView+KeyBoardShowAndHidden.h"
#import "MultiInvite.h"
#import "MultiMembers.h"
#import "UserDataUIAlertView.h"

@interface ChatView2 (){
    
}

// @property (nonatomic) NSArray * messages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) MessageRepo *msRepo;
@property (strong, nonatomic) NSMutableArray *messages;

@end

@implementation ChatView2
@synthesize friend, msRepo, _viewBottom;
@synthesize ref, messages;

@synthesize barItemMembers;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:_viewBottom];
    
    [_viewBottom showAccessoryViewAnimation];
    [_viewBottom hiddenAccessoryViewAnimation];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

    
//    _messages = [[NSArray alloc] initWithObjects:
//                 @"Hello, how are you.",
//                 @"I'm great, how are you?",
//                 @"I'm fine, thanks. Up for dinner tonight?",
//                 @"Glad to hear. No sorry, I have to work.",
//                 @"Oh that sucks. A pitty, well then - have a nice day.."
//                 @"Thanks! You too. Cuu soon.",
//                 @"Hello, how are you.",
//                 @"I'm great, how are you?",
//                 @"I'm fine, thanks. Up for dinner tonight?",
//                 @"Glad to hear. No sorry, I have to work.",
//                 @"Oh that sucks. A pitty, well then - have a nice day.."
//                 @"Thanks! You too. Cuu soon.",
//                 @"Hello, how are you.",
//                 @"I'm great, how are you?",
//                 @"I'm fine, thanks. Up for dinner tonight?",
//                 @"Glad to hear. No sorry, I have to work.",
//                 @"Oh that sucks. A pitty, well then - have a nice day.."
//                 @"Thanks! You too. Cuu soon.",
//                 nil];
    
    
    

    msRepo = [[MessageRepo alloc] init];
    ref = [[FIRDatabase database] reference];
    messages = [NSMutableArray array];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
    [self.tableView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData:)
                                                 name:@"ChatView_reloadData"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(detectOnline:)
                                                 name:@"ChatView_detectOnline"
                                               object:nil];
    
    
    [self reloadData:nil];
    [self detectOnline:nil];
    
    
    if ([self.typeChat isEqualToString:@"1"] || [self.typeChat isEqualToString:@"2"]) {
        
        [self.barItemMembers setEnabled:NO];
        [self.barItemMembers setTintColor: [UIColor clearColor]];
    }else if([self.typeChat isEqualToString:@"4"]){
        [self.barItemMembers setEnabled:YES];
        [self.barItemMembers setTintColor:nil];
        
        NSDictionary *members = [self.friend valueForKey:@"members"];
        self.barItemMembers.title = [NSString stringWithFormat:@"Members(%d)", [members count]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)detectOnline:(NSNotification *) notification{
    // NSMutableDictionary *f = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] objectForKey:@""];
    
    NSMutableDictionary *ff = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] friendsProfile] objectForKey:[friend objectForKey:@"friend_id"]];
    
    self.title = [NSString stringWithFormat:@"%@-online : %@", [friend objectForKey:@"friend_id"], [ff objectForKey:@"online"]];
    NSLog(@"");
}

-(void)reloadData:(NSNotification *) notification{
    
    // [self.messages removeAllObjects];
    
    if (notification == nil) {
        /*
        NSMutableArray *all_message = [msRepo getMessageByChatId:[friend objectForKey:@"chat_id"]];
        
        NSInteger ichat_id = [msRepo.dbManager.arrColumnNames indexOfObject:@"chat_id"];
        NSInteger iobject_id = [msRepo.dbManager.arrColumnNames indexOfObject:@"object_id"];
        NSInteger itext = [msRepo.dbManager.arrColumnNames indexOfObject:@"text"];
        NSInteger itype = [msRepo.dbManager.arrColumnNames indexOfObject:@"type"];
        NSInteger isender_id = [msRepo.dbManager.arrColumnNames indexOfObject:@"sender_id"];
        NSInteger ireceive_id = [msRepo.dbManager.arrColumnNames indexOfObject:@"receive_id"];
        NSInteger istatus = [msRepo.dbManager.arrColumnNames indexOfObject:@"status"];
        NSInteger ireader = [msRepo.dbManager.arrColumnNames indexOfObject:@"reader"];
        NSInteger icreate = [msRepo.dbManager.arrColumnNames indexOfObject:@"create"];
        NSInteger iupdate = [msRepo.dbManager.arrColumnNames indexOfObject:@"update"];
        
        for (int i = 0; i < [all_message count]; i++) {
            // NSArray *item = all_message[i];
            
//            NSString*text = [[all_message objectAtIndex:i] objectAtIndex:itext];
//            NSString*sender_id = [[all_message objectAtIndex:i] objectAtIndex:isender_id];
//
            Message *ms = [[Message alloc] init];
            
            NSMutableArray *message = [all_message objectAtIndex:i];
            
            ms.chat_id  = [ message objectAtIndex:ichat_id];
            ms.object_id  = [message objectAtIndex:iobject_id];
            ms.text  = [message objectAtIndex:itext];
            ms.type  = [message objectAtIndex:itype];
            ms.sender_id  = [message objectAtIndex:isender_id];
            ms.receive_id  = [message objectAtIndex:ireceive_id];
            ms.status  = [message objectAtIndex:istatus];
            ms.reader  = [message objectAtIndex:ireader];
            ms.create  = [message objectAtIndex:icreate];
            ms.update  = [message objectAtIndex:iupdate];
            
            [self.messages addObject:ms];
        }
        */
    }else{
    
        if ([notification.name isEqualToString:@"ChatView_reloadData"]) {
            NSDictionary* userInfo = notification.userInfo;
            
            Message *m = [userInfo objectForKey:@"message"];
            
            BOOL flag = false;
            for (int i = 0; i < [self.messages  count]; i++) {
                Message *item = [self.messages objectAtIndex:i];
                if ([item.object_id isEqualToString:m.object_id]) {
                    flag = true;
                    break;
                }
            }
            
            if (!flag) {
                [self.messages addObject:m];
                
                NSInteger row = [self.messages count] - 1;//specify a row where you need to add new row
                NSInteger section = 0;//specify the section where the new row to be added,
                //section = 1 here since you need to add row at second section
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView endUpdates];
                

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self scrollToBottom];
                });
            }
            NSLog(@"");
            
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"");
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"MultiInvite"]) {
        MultiInvite *muti = (MultiInvite*)segue.destinationViewController;
        
    
        if ([self.typeChat isEqualToString:@"1"] || [self.typeChat isEqualToString:@"2"]) {
            muti.typeChat = self.typeChat;
            muti.friend_id = [friend objectForKey:@"friend_id"];
        }else if([self.typeChat isEqualToString:@"4"]){
            // Multi Chat
            muti.typeChat = self.typeChat;
            muti.friend_id = @"";
            muti.multi_members = self.friend;
        }
        
    }else if ([segue.identifier isEqualToString:@"MultiMembers"]) {
        MultiMembers *members = (MultiMembers*)segue.destinationViewController;
        members.group = self.friend;
        
    }
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"MultiMembers"]) {
//        MultiMembers *members = (MultiMembers*)segue.destinationViewController;
//        members.group = self.group;
//    }else if([segue.identifier isEqualToString:@"MultiInvite"]){
//        MutiInvite *invite = (MutiInvite*)segue.destinationViewController;
//        invite.friend_id = @"";
//    }
//}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self scrollToBottom];
//        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*This method sets up the table-view.*/
    
    static NSString* cellIdentifier = @"messagingCell";
    
    PTSMessagingCell * cell = (PTSMessagingCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[PTSMessagingCell alloc] initMessagingCellWithReuseIdentifier:cellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // CGSize messageSize = [PTSMessagingCell messageSize:[_messages objectAtIndex:indexPath.row]];
    // return messageSize.height + 2*[PTSMessagingCell textMarginVertical] + 40.0f;
    
    return 100.0f;
}

-(void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath {
    PTSMessagingCell* ccell = (PTSMessagingCell*)cell;
    
//    if (indexPath.row % 2 == 0) {
//        ccell.sent = YES;
//        ccell.avatarImageView.image = [UIImage imageNamed:@"person1"];
//    } else {
//        ccell.sent = NO;
//        ccell.avatarImageView.image = [UIImage imageNamed:@"person2"];
//    }
//
    Message *mm = [self.messages objectAtIndex:indexPath.row];
    
    if ([[[Configs sharedInstance] getUIDU] isEqualToString:mm.sender_id]) {
        ccell.sent = YES;
        ccell.avatarImageView.image = [UIImage imageNamed:@"person1"];
    }else{
        ccell.sent = NO;
        ccell.avatarImageView.image = [UIImage imageNamed:@"person2"];
    }
    
    ccell.messageLabel.text = mm.text;
    // ccell.timeLabel.text = @"2012-08-29";
}

- (IBAction)onSend:(id)sender {
    NSString *text = self.txtMessage.text;
    
    NSString *ccmessage = [NSString stringWithFormat:@"toonchat_message/%@/", [friend objectForKey:@"chat_id"]];
    NSString *object_id = [[ref child:ccmessage] childByAutoId].key;
    
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
    
    // MessageRepo *meRepo = [[MessageRepo alloc] init];
    Message* m  = [[Message alloc] init];
    m.chat_id   = [friend objectForKey:@"chat_id"];
    m.object_id = object_id;
    m.text      = text;
    
    m.sender_id = [[Configs sharedInstance] getUIDU];
    
    
    m.status    = @"sending";
    m.reader    = @"";
    m.create    = [timeStampObj stringValue];
    m.update    = [timeStampObj stringValue];
    
    if ([self.typeChat isEqualToString:@"1"] || [self.typeChat isEqualToString:@"2"]) {
        m.type      = @"private";
        m.receive_id = [friend objectForKey:@"friend_id"];
    }else if([self.typeChat isEqualToString:@"4"]){
        // Multi Chat
        m.type      = @"private";
        m.receive_id = [friend objectForKey:@"members"];
    }
    
    [self.messages addObject:m];
    
    NSInteger row = [self.messages count] - 1;//specify a row where you need to add new row
    NSInteger section = 0;//specify the section where the new row to be added,
    //section = 1 here since you need to add row at second section
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
    
    self.txtMessage.text = @"";
    [self scrollToBottom];
    
    if([msRepo insert:m]){
        NSDictionary *_message = @{
                                   @"chat_id":m.chat_id,
                                   @"object_id":m.object_id,
                                   @"text": m.text,
                                   @"type": m.type,
                                   @"sender_id" : m.sender_id,
                                   @"receive_id" : m.receive_id,
                                   @"status" : @"send", // สถานะการส่ง  sending(กำลังส่ง), resend(ส่งไม่สำเร็จ), send_success(ส่งสำเร็จ)
                                   @"reader" : @{}, // จะเก็บ uid ของผู้เปิดอ่าน
                                   @"create": [FIRServerValue timestamp],
                                   @"update": [FIRServerValue timestamp]
                                   };
        
        [[[ref child:ccmessage] child:object_id] setValue:_message withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            
            NSString*chat_id   = ref.parent.key;
            NSString*object_id = ref.key;
            
            // MessageRepo *meRepo = [[MessageRepo alloc] init];
            NSArray*item = [msRepo get:object_id];
            
            if(item != nil){
                
                /*
                 Message* m =[[Message alloc] init];
                 m.chat_id  = item[1];
                 m.object_id  = item[2];
                 m.text  = item[3];
                 m.type  = item[4];
                 m.sender_id  = item[5];
                 m.receive_id  = item[6];
                 // m.status  = item[7];
                 m.reader  = item[8];
                 m.create  = item[9];
                 m.update  = item[10];
                 
                 if (error == nil) {
                 m.status  = @"send_success";
                 }else{
                 // error
                 m.status  = @"resend";
                 }
                 BOOL us = [meRepo update:m];
                 */
                
                /*
                 @"chat_id":m.chat_id,
                 @"object_id":m.object_id,
                 @"text": m.text,
                 
                 @"type": m.type,
                 @"sender_id" : m.sender_id,
                 @"receive_id" : m.receive_id,
                 @"status" : @"send", // สถานะการส่ง  sending(กำลังส่ง), resend(ส่งไม่สำเร็จ), send_success(ส่งสำเร็จ)
                 @"reader" : @{}, // จะเก็บ uid ของผู้เปิดอ่าน
                 @"create": [FIRServerValue timestamp],
                 @"update": [FIRServerValue timestamp]
                 */
                
                NSInteger ichat_id = [msRepo.dbManager.arrColumnNames indexOfObject:@"chat_id"];
                NSInteger iobject_id = [msRepo.dbManager.arrColumnNames indexOfObject:@"object_id"];
                NSInteger itext = [msRepo.dbManager.arrColumnNames indexOfObject:@"text"];
                
                NSInteger itype = [msRepo.dbManager.arrColumnNames indexOfObject:@"type"];
                NSInteger isender_id = [msRepo.dbManager.arrColumnNames indexOfObject:@"sender_id"];
                NSInteger ireceive_id = [msRepo.dbManager.arrColumnNames indexOfObject:@"receive_id"];
                NSInteger istatus = [msRepo.dbManager.arrColumnNames indexOfObject:@"status"];
                NSInteger ireader = [msRepo.dbManager.arrColumnNames indexOfObject:@"reader"];
                NSInteger icreate = [msRepo.dbManager.arrColumnNames indexOfObject:@"create"];
                NSInteger iupdate = [msRepo.dbManager.arrColumnNames indexOfObject:@"update"];
                
                // NSMutableArray*item2 = [meRepo get:object_id];
                
                
                
                Message* m =[[Message alloc] init];
                m.chat_id  = [item objectAtIndex:ichat_id];
                m.object_id  = [item objectAtIndex:iobject_id];
                m.text  = [item objectAtIndex:itext];
                m.type  = [item objectAtIndex:itype];
                m.sender_id  = [item objectAtIndex:isender_id];
                m.receive_id  = [item objectAtIndex:ireceive_id];
                // m.status  = item[7];
                m.reader  = [item objectAtIndex:ireader];
                m.create  = [item objectAtIndex:icreate];
                m.update  = [item objectAtIndex:iupdate];
                
                if (error == nil) {
                    m.status  = @"send_success";
                }else{
                    // error
                    m.status  = @"resend";
                }
                BOOL us = [msRepo update:m];
                NSLog(@"");
            }
        }];
    }
}

- (IBAction)onSettings:(id)sender {
    
    if ([self.typeChat isEqualToString:@"1"] || [self.typeChat isEqualToString:@"2"]) {
        
        //Do Whatever You want on End of Gesture
        UserDataUIAlertView *alert = [[UserDataUIAlertView alloc] initWithTitle:nil
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Close"
                                         otherButtonTitles:@"Invite friend(สร้าง Multi-Chat)", nil];
        
        alert.userData = @"";
        alert.tag = 1;
        [alert show];
    }else if([self.typeChat isEqualToString:@"4"]){
        
        NSDictionary *members = [self.friend valueForKey:@"members"];
        
        //Do Whatever You want on End of Gesture
        UserDataUIAlertView * alert = [[UserDataUIAlertView alloc] initWithTitle:nil
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Close"
                                         otherButtonTitles:@"Invite friend(เพิ่มเพื่อนใหม่เข้า Multi-Chat)", [NSString stringWithFormat:@"Members(%d)", [members count]], @"สร้าง Group Chat", nil];
        
        alert.userData = @"";
        alert.tag = 2;
        [alert show];
    }
}

- (void)alertView:(UserDataUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (alertView.tag == 1) {
        
        NSIndexPath * indexPath = alertView.userData;
        
        switch (buttonIndex) {
            case 0:{
                // Close
            }
                break;
                
            case 1:{
                // Invite friend(สร้าง Multi-Chat)
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MultiInvite *muti = [storybrd instantiateViewControllerWithIdentifier:@"MultiInvite"];
                
                muti.typeChat = self.typeChat;
                muti.friend_id = [friend objectForKey:@"friend_id"];
                [self.navigationController pushViewController:muti animated:YES];
            }
                break;
        }
    }else if(alertView.tag == 2){
        NSIndexPath * indexPath = alertView.userData;
        
        switch (buttonIndex) {
            case 0:{
                // Close
            }
                break;
                
            case 1:{
                // Invite friend(เพิ่มเพื่อนใหม่เข้า Multi-Chat)
                NSLog(@"");
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MultiInvite *muti = [storybrd instantiateViewControllerWithIdentifier:@"MultiInvite"];
                
                muti.typeChat = self.typeChat;
                muti.friend_id = @"";
                muti.multi_members = self.friend;
                [self.navigationController pushViewController:muti animated:YES];
            }
                break;
                
            case 2:{
                // Members
                NSLog(@"");
                
                // MultiMembers *members = (MultiMembers*)segue.destinationViewController;
                
                UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MultiMembers *members = [storybrd instantiateViewControllerWithIdentifier:@"MultiMembers"];
                members.group = self.friend;
                
                [self.navigationController pushViewController:members animated:YES];
            }
                break;
                
            case 3:{
                // สร้าง Group Chat
                NSLog(@"");
            }
                break;
        }
    }
}

-(void)scrollToBottom{
    [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height) animated:NO];
}

#pragma mark --  notification    Method
- (void)keyBoardWillShow:(NSNotification *)noti{
    NSDictionary * dic = noti.userInfo;
    CGRect keyboardBounds = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval keyboardTime = [dic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat deleteY = keyboardBounds.size.height;
    [UIView animateWithDuration:keyboardTime delay:0 options:[dic[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16 animations:^{
        _viewBottom.transform = CGAffineTransformMakeTranslation(0, -deleteY);
    } completion:nil];
    
}

- (void)keyBoardWillHidden:(NSNotification *)noti{
    NSDictionary * dic = noti.userInfo;
    NSTimeInterval time = [dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue];
    [UIView animateWithDuration:time delay:0 options: [dic[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16 animations:^{
        _viewBottom.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)hidden{
    [self.view endEditing:YES];
}

@end
