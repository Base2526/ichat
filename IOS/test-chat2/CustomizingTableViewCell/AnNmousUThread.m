//
//  AnNmousUThread.m
//  Heart
//
//  Created by Somkid on 1/1/2560 BE.
//  Copyright © 2560 Klovers.org. All rights reserved.
//

#import "AnNmousUThread.h"
#import "Configs.h"
#import "AppConstant.h"

#import "Configs.h"
@import FirebaseInstanceID;

@implementation AnNmousUThread

-(void)start
{
    //if there is a connection going on just cancel it.
    [self.connection cancel];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    // [data release];
    
    // NSString *token = [[FIRInstanceID instanceID] token];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.json",  [Configs sharedInstance].API_URL, [Configs sharedInstance].ANNMOUSU]];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:[Configs sharedInstance].timeOut];;//[NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    /*
     
     
     */
    
    NSString *dataToSend = [[NSString alloc] initWithFormat:@"udid=%@&platform=ios&bundleidentifier=%@&version=%@", [[Configs sharedInstance] getUniqueDeviceIdentifierAsString], [[Configs sharedInstance] getBundleIdentifier], [[Configs sharedInstance] getVersionApplication]];
    [request setHTTPBody:[dataToSend dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    // [connection release];
    
    //start the connection
    [connection start];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response{
    
    [self.receivedData setLength:0];
}

/*
 this method might be calling more than one times according to incoming data size
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [self.receivedData appendData:data];
}

/*
 if there is an error occured, this method will be called by connection
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    if (self.errorHandler) {
        self.errorHandler([error description]);
    }
}

/*
 if data is successfully received, this method will be called by connection
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    if (self.completionHandler) {
        self.completionHandler(self.receivedData);
    }
}

@end
