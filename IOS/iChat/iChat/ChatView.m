//
//  ChatView.m
//  CustomizingTableViewCell
//
//  Created by Somkid on 9/20/2560 BE.
//  Copyright © 2560 com.ms. All rights reserved.
//

#import "ChatView.h"
#import "Configs.h"
#import "InviteFriends.h"

@interface ChatView ()

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubble;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubble;
@property (strong, nonatomic) JSQMessagesAvatarImage *incomingAvatar;
@property (strong, nonatomic) JSQMessagesAvatarImage *outgoingAvatar;

@end

@implementation ChatView
@synthesize friend;
@synthesize ref;

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自分の senderId, senderDisplayName を設定
    self.senderId = @"user1";
    self.senderDisplayName = @"classmethod";
    // MessageBubble (背景の吹き出し) を設定
    JSQMessagesBubbleImageFactory *bubbleFactory = [JSQMessagesBubbleImageFactory new];
    self.incomingBubble = [bubbleFactory  incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.outgoingBubble = [bubbleFactory  outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    // アバター画像を設定
    self.incomingAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"User2"] diameter:64];
    self.outgoingAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"User1"] diameter:64];
    // メッセージデータの配列を初期化
    self.messages = [NSMutableArray array];
    
    // hide attachment icon
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
    JSQMessage *message1 = [JSQMessage messageWithSenderId:@"user1"
                                               displayName:@"underscore"
                                                      text:@"Hello"];
    
    [self.messages addObject:message1];
    [self.messages addObject:message1];
    [self.messages addObject:message1];
    [self.messages addObject:message1];
    [self.messages addObject:message1];
    [self.messages addObject:message1];
    [self.messages addObject:message1];
    [self.messages addObject:message1];
    [self.messages addObject:message1];
    [self.messages addObject:message1];
    [self.messages addObject:message1];
    [self.messages addObject:message1];
    [self.messages addObject:message1];
    [self.messages addObject:message1];
    
    JSQMessage *message2 = [JSQMessage messageWithSenderId:@"user2"
                                              displayName:@"underscore"
                                                     text:@"Hello2"];
    [self.messages addObject:message2];
    [self.messages addObject:message2];
    [self.messages addObject:message2];
    [self.messages addObject:message2];
    [self.messages addObject:message2];
    
    JSQMessage *message3 = [JSQMessage messageWithSenderId:@"user3"
                                               displayName:@"underscore"
                                                      text:@"Hello3"];
    [self.messages addObject:message3];
    [self.messages addObject:message3];
    [self.messages addObject:message3];
    [self.messages addObject:message3];
    [self.messages addObject:message3];
    
    
    
    
    ref = [[FIRDatabase database] reference];
}

#pragma mark - Auto Message

- (void)receiveAutoMessage
{
    // 1秒後にメッセージを受信する
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(didFinishMessageTimer:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)didFinishMessageTimer:(NSTimer*)timer
{
    // 効果音を再生する
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    // 新しいメッセージデータを追加する
    JSQMessage *message = [JSQMessage messageWithSenderId:@"user2"
                                              displayName:@"underscore"
                                                     text:@"Hello"];
    [self.messages addObject:message];
    // メッセージの受信処理を完了する (画面上にメッセージが表示される)
    [self finishReceivingMessageAnimated:YES];
    
    
    NSDictionary *_message = @{
                               @"sender_id" : [friend objectForKey:@"friend_id"],
                               @"create": [FIRServerValue timestamp],
                               @"text": @"Hello",
                               @"type": @"private"};
    
    NSString *ccmessage = [NSString stringWithFormat:@"toonchat_message/%@/", [friend objectForKey:@"chat_id"]];
    
    // [[[[_ref child:@"users"] child:user.uid] child:@"username"] setValue:username];
    [[[ref child:ccmessage] childByAutoId] setValue:_message withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        NSLog(@"");
    }];
}

#pragma mark - JSQMessagesViewController

// Sendボタンが押下されたときに呼ばれる
- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    // 効果音を再生する
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    // 新しいメッセージデータを追加する
    JSQMessage *message = [JSQMessage messageWithSenderId:senderId
                                              displayName:senderDisplayName
                                                     text:text];
    [self.messages addObject:message];
    // メッセージの送信処理を完了する (画面上にメッセージが表示される)
    [self finishSendingMessageAnimated:YES];
    // 擬似的に自動でメッセージを受信
    [self receiveAutoMessage];
    
    
    /*
     create:     1501506541412
     friend_id:  "913"
     text:       "1@"
     type:       "private"
     uid:        "912"
     */
    
    NSDictionary *_message = @{
                           @"sender_id" : [[Configs sharedInstance] getUIDU],
                           @"create": [FIRServerValue timestamp],
                           @"text": text,
                           @"type": @"private"};
    
    NSString *ccmessage = [NSString stringWithFormat:@"toonchat_message/%@/", [friend objectForKey:@"chat_id"]];
    
    // [[[[_ref child:@"users"] child:user.uid] child:@"username"] setValue:username];
    [[[ref child:ccmessage] childByAutoId] setValue:_message withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        NSLog(@"");
    }];
}

#pragma mark - JSQMessagesCollectionViewDataSource

// アイテムごとに参照するメッセージデータを返す
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}

// アイテムごとの MessageBubble (背景) を返す
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubble;
    }
    return self.incomingBubble;
}

// アイテムごとのアバター画像を返す
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingAvatar;
    }
    return self.incomingAvatar;
}

#pragma mark - UICollectionViewDataSource

// アイテムの総数を返す
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (IBAction)onInvite:(id)sender {
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InviteFriends *inviteF = [storybrd instantiateViewControllerWithIdentifier:@"InviteFriends"];
    
    // changeFN.friend_id = [item objectForKey:@"friend_id"];
    [self.navigationController pushViewController:inviteF animated:YES];
}
@end

