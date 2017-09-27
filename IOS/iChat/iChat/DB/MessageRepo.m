//
//  MessageRepo.m
//  iChat
//
//  Created by Somkid on 9/26/2560 BE.
//  Copyright © 2560 klovers.org. All rights reserved.
//

/*
 CREATE TABLE "message" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT, "chat_id" TEXT, "owner_id" TEXT, "text" TEXT, "type" TEXT, "uid" TEXT, "status" TEXT, "create" TEXT, "update" TEXT)
 */

#import "MessageRepo.h"

@implementation MessageRepo

-(id) init{
    self = [super init];
    if(self){
        //do something
        // self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"db.sql"];
        self.dbManager = [[DBManager alloc] init];
    }
    return self;
}

- (BOOL)check:(NSString *)object_id{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from message where object_id=%@", object_id];
    
    //  Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
    if ([results count] ==0) {
        return false;
    }
    return true;
}

- (BOOL) insert:(Message *)message{
    BOOL success = false;
    
    //  ยังไม่เคยมี ให้ insert
    NSString *query = [NSString stringWithFormat:@"INSERT INTO message ('chat_id', 'object_id','owner_id','text','type', 'uid', 'status', 'create', 'update') VALUES (%@, %@, %@, %@, %@, %@, %@, %@, %@);", message.chat_id, message.object_id, message.owner_id, message.text, message.type, message.uid, message.status, message.create, message.update];
    
    //  Execute the query.
    [self.dbManager executeQuery:query];
    
    //  If the query was succesfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affacted rows = %d", self.dbManager.affectedRows);
        return true;
    }else{
        NSLog(@"Could not execute the query");
        return false;
    }
}

- (BOOL) update:(Message *)message{
    //  แสดงว่ามีให้ทำการ udpate
    NSString *query = [NSString stringWithFormat:@"UPDATE message set 'text'=%@, 'status'=%@ WHERE object_id=%@;", message.text, message.status, message.object_id];
    
    //  Execute the query.
    [self.dbManager executeQuery:query];
    
    //  If the query was succesfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affacted rows = %d", self.dbManager.affectedRows);
        return true;
    }else{
        NSLog(@"Could not execute the query");
        return false;
    }
}

- (NSMutableArray *) getMessageByChatId:(NSString *)chat_id{
    //  Create a query
    NSString *query = [NSString stringWithFormat:@"select * from message where chat_id=%@", chat_id];
    
    //  Load the relevant data.
    return [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDBWithQuery:query]];
}

- (BOOL) deleteByChatId :(NSString *)chat_id{
    NSString *query = [NSString stringWithFormat:@"DELETE from message WHERE chat_id = %@", chat_id];
    [self.dbManager executeQuery:query];
    
    //  If the query was succesfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affacted rows = %d", self.dbManager.affectedRows);
        return true;
    }else{
        NSLog(@"Could not execute the query");
        return false;
    }
}
@end
