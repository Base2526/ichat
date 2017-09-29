//
//  MessageRepo.h
//  iChat
//
//  Created by Somkid on 9/26/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DBManager.h"
#import "Message.h"

@interface MessageRepo : NSObject{
    
}

@property (nonatomic, strong) DBManager *dbManager;

- (BOOL)check:(NSString *)object_id;
- (Message *)get:(NSString *)object_id;
- (BOOL)insert:(Message *)message;
- (BOOL)update:(Message *)message;

/*
 การดึงข้อความ chat แยกตาม chat_id
 */
- (NSMutableArray *) getMessageByChatId:(NSString *)chat_id;

/*
 เป้นการลบ ข้อความที่ละ 1 ข้อความ
 */
- (BOOL) deleteByMessage:(Message *)message;

/*
 เป้นการลบ ข้อความ โดยลบตาม chat_id
 */
- (BOOL) deleteByChatId:(NSString *)chat_id;

@end
