<?php
	define("TAG", "BASIC Module");
	define("PATH_FOLDER_QRCODE", "sites/default/files/qrcode");


	define("DEFUALT_NUMBER_HEART", "50");       // จำนวน Heart ที่เราให้ครั้งเมือสมัคร
	define("DEFUALT_HEART_FREE_DAILY", "10");   // จำนวน Heart ที่เราให้ทุกวัน โดยมีเงื่อนไขว่า User ต้องเปิดวันนั้นๆ
	define("LIMIT_SEND_HEART", "2");


	define("DEFUALT_PASSWORD", "HEARTBASIC");
	define("DEFUALT_DISPLAY_USER_ANNONYMOUS", "ANNONYMOUS");
	define("DEFUALT_STATUS_MESSAGE", "status message");


	// URL STORE
	define("DEFUALT_IOS_URL_STORE_BASIC", "https://itunes.apple.com/us/app/heart-basic/id1184807478?ls=1&mt=8");
	define("DEFUALT_IOS_URL_STORE_DNA", "https://itunes.apple.com/us/app/dna/id1184836132?ls=1&mt=8");
	define("DEFUALT_ANDROID_URL_STORE_BASIC", "https://itunes.apple.com/us/app/heart-basic/id1184807478");
	define("DEFUALT_ANDROID_URL_STORE_DNA", "https://itunes.apple.com/us/app/heart-basic/id1184807478");


	// Firebase Config             
	define("FIREBASE_BASIC_KEY", "AIzaSyBoWN3hYF-fmOmXUKwFuM5GnuIcxdpmC3o");  //
	define("FIREBASE_DEFAULT_URL", 'https://basic-dev.firebaseio.com/');
	define("FIREBASE_DEFAULT_PATH", '/heart-id/');
	define("FIREBASE_LOGIN_PATH", 'user-login/');
	define("FIREBASE_CENTER", 'center/'); 
	define("FIREBASE_CENTER_SLIDE", 'center-slide/'); 



	// Bundle Identifier  
	define("BI_IOS_BASIC", "heart.basic");
	define("BI_IOS_IDNA", "heart.idna");

	define("BI_ANDROID_BASIC", "heart.basic");
	define("BI_ANDROID_IDNA", "heart.idna");

?>