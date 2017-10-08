<?php
	define("TAG", "Patumwan Module");
	define("PATH_FOLDER_QRCODE", "sites/default/files/qrcode");

	define("DEFUALT_NUMBER_HEART", "50");       // จำนวน Heart ที่เราให้ครั้งเมือสมัคร
	define("DEFUALT_HEART_FREE_DAILY", "10");   // จำนวน Heart ที่เราให้ทุกวัน โดยมีเงื่อนไขว่า User ต้องเปิดวันนั้นๆ
	define("LIMIT_SEND_HEART", "2");


	define("DEFUALT_PASSWORD", "HEARTBASIC");
	define("DEFUALT_DISPLAY_USER_ANNONYMOUS", "ANNONYMOUS");
	define("DEFUALT_STATUS_MESSAGE", "status message");

	define("DEFUALT_LENGTH_CHAT_ID", 20); 


	// URL STORE
	define("DEFUALT_IOS_URL_STORE_BASIC", "https://itunes.apple.com/us/app/heart-basic/id1184807478?ls=1&mt=8");
	define("DEFUALT_IOS_URL_STORE_DNA", "https://itunes.apple.com/us/app/dna/id1184836132?ls=1&mt=8");
	define("DEFUALT_ANDROID_URL_STORE_BASIC", "https://itunes.apple.com/us/app/heart-basic/id1184807478");
	define("DEFUALT_ANDROID_URL_STORE_DNA", "https://itunes.apple.com/us/app/heart-basic/id1184807478");


	// Firebase Config             
	define("FIREBASE_BASIC_KEY", "AIzaSyDfCPJJNM0SusVYNCzo76e9S4esYkqVjzA"); 
	define("FIREBASE_DEFAULT_URL", 'https://test-toonchat.firebaseio.com/');
	define("FIREBASE_DEFAULT_PATH", '/');
	define("FIREBASE_LOGIN_PATH", 'toonchat/');
	define("FIREBASE_DEFAULT_UPDATE", 'update/');


	define("PATH_GROUPS", "groups");
	define("PATH_MULTI_CHAT", "multi_chat");


	// Bundle Identifier  
	define("BI_IOS_BASIC", "heart.basic");
	define("BI_IOS_IDNA", "heart.idna");

	define("BI_ANDROID_BASIC", "");
	define("BI_ANDROID_IDNA", "");
?>