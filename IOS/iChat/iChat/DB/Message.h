//
//  Message.h
//  iChat
//
//  Created by Somkid on 9/26/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Message : NSObject
@property (nonatomic, strong) NSString *chat_id;
@property (nonatomic, strong) NSString *object_id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *sender_id;
@property (nonatomic, strong) NSString *receive_id;

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *reader;
@property (nonatomic, strong) NSString *create;
@property (nonatomic, strong) NSString *update;
@end
