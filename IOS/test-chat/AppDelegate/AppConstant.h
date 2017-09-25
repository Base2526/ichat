//
//  AppConstant.h
//  D8
//
//  Created by System Administrator on 6/29/2559 BE.
//  Copyright © 2559 KLover. All rights reserved.
//

#ifndef AppConstant_h
#define AppConstant_h

/*
 [preferences setObject:[jsonDict objectForKey:@"uid"] forKey:@"uid"];
 [preferences setObject:[jsonDict objectForKey:@"session_id"] forKey:@"session_id"];
 */
// #define     DEFUALT_PASSWORD        @"KLOVERSORG"

// #define     _isAnonymous            @"is_annonymous"    // เก้บ สถานะว่าเป้น user annonymous หรือไม่

// #define		_UID                    @"uid"              // user id
// #define		_SESSION_ID             @"session_id"		// session id
// #define		_SESSION_NAME           @"session_name"		// session name
#define		_USER                   @"user"             // name, mail, image_url
// #define     _PROFILE                @"profile"
// #define     _MYAPP                  @"myapp"


#define     _USER_CONTACTS          @"user_contacts"     // เก็บ contacts friends ทั้งหมดของ user
#define     _USER_HEART             @"user_heart"        // เก็บ heart friends ทั้งหมดของ user
#define     _USER_HEART_CURRENT     @"user_friends_current"     // เก็บจำนวน heart ของ user

#define     _PROFILE_FRIENDS        @"profile_friends"   // เป็นการเก็บ profile friend ทั้งหมด


#define     _EMAIL_LAST             @"email_last"       //  เก็บ email ล่าสุดที่ใช้งาน

// #define     _USER_MY_ID             @"user_my_id"     // เก็บ my id ของ user  โดยรวมถึง my card, my application

#define     _CATEGORY_APPLICATION   @"category_application" 


#define     _DATA                   @"data"
#define     _EXTERNAL               @"external"
#define     _CENTER                 @"center"
#define     _CENTER_SLIDE           @"center_slide"

#endif /* AppConstant_h */
