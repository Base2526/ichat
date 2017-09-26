var functions = require('firebase-functions');

// Import Admin SDK
var admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

// Get a database reference to our posts
var db = admin.database();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

var path = 'toonchat';
var path_message = 'toonchat_message';
// https://github.com/firebase/firebase-functions/blob/master/src/providers/database.ts
exports.tiggerUser = functions.database.ref(path + '/{uid}/{type}/{key}/').onWrite(event => {
	// console.log(event.data);

	/*
	ต้องเช็กด้วยว่าเป้นการลบ ข้อมูลหรือไม่ ถ้าใช่ให้ return 
	*/
	// if (event.data.previous.exists()) {
	// 	console.log('#000');
	//     return;
	// }
	if (!event.data.exists()) {
		return;
	}

	const crnt = event.data.current;
    const prev = event.data.previous;

    if (crnt.val() && !prev.val()) {
        // value created
        console.log('Created: send push notification');
    } else if (!crnt.val() && prev.val()) {
        // value removed
        console.log('Removed: send push notification');
    } else {
        // value updated
        console.log('Updated');
    }

	// console.log('#' + event.params.uid);

	var _val = event.data.toJSON();
	// console.log('# _val : ' + _val);

	var cc = event.data.current.val();
	// var ccc = cc.val();
	// console.log('# cc : ' + JSON.stringify(cc));

    /*
	// loop all data
	event.data.forEach(function(childSnapshot) {
      // key will be "ada" the first time and "alan" the second time
      var key = childSnapshot.key;
      // childData will be the actual contents of the child
      var childData = childSnapshot.val();

      // console.log('# key : ' + key + ", childData : " + childData);
  	});

	// จะได้ได้ key ข้อมูลที่ เพิ่มใหม่ หรือ แก้ไข 
  	console.log('key new : ' + event.params.key);
  	*/
	
	switch(event.params.type) {
		case 'profiles':{
			console.log('#1 : profiles');
		}
		break;

		case 'friends':{
			console.log('#2 : friends');
		}
		break;

		case 'groups':{
			// console.log('#3 : groups');

			event.data.forEach(function(childSnapshot) {
		      // key will be "ada" the first time and "alan" the second time
		      // var key = childSnapshot.key;
		      // childData will be the actual contents of the child
		      // var childData = childSnapshot.val();

		      // console.log('# key : ' + key + ", childData : " + childData);

				/*
		      if (event.params.key == childSnapshot.key) {
		      	var key = childSnapshot.key;
		      	var childData = childSnapshot.val();
				console.log('># key : ' + key + ", childData : " + childData);
		      }else{
		      	console.log(">###< | " + event.params.key + " & "+ childSnapshot.key);
		      }
		      */


		      if(childSnapshot.key == 'members'){
		      	// var members = JSON.parse(childSnapshot.val());

		      	var members = childSnapshot.val();

		      	
		      	// members.forEach(function(childMembers) {
		      	// 	console.log('>## childMembers :' + childMembers.key);
		      	// });

		  //     	for(let index in members){
				//   var element = members[index];
				//   console.log('>## element :' + element);
				// }

				console.log('>## numChildren() :' + childSnapshot.numChildren());

				var ref = db.ref(path);

				childSnapshot.forEach(function (snapshot) {
		           var obj = snapshot.val();
		           if(obj.status == "pedding") {
		               // console.log("uid : " + snapshot.key + ", status = " + obj.status);

		               // เราต้อง เพิ่ม invite_group เพือ่นที่เรา invite ไปด้วย
		               ref.child(snapshot.key).child("invite_group").child(event.params.key).set({
		               	'owner_id':event.params.uid,
		               	'status':obj.status
		               });
		           }
		        });


		      	// console.log(JSON.parse(JSON.stringify(childSnapshot.val())));
		      	// console.log('>## KOK : #2 >');
		      	// $.each(JSON.parse(JSON.stringify(childSnapshot.val())), function(index, valueA){
		      	// 	console.log('>##>' + index);
		      	// 	console.log('>##>>' + valueA);
		      	// });

		   //    	for (var keyM in members) {
					// console.log('>## keyM : ' + keyM);
		   //    	}

		   //    	for (var ikey in members) {
					// console.log('>## ikey : ' + ikey);
		   //    	}
				// members.forEach(function(childMember) {
				// 	var _key = childMember.key;
				// 	console.log('>## key : ' + _key);
				// });
		      }
		  	});
		}
		break;

		case 'invite_group':{
			console.log('#4 : invite_group');
		}
		break;
		case 'chat':{
			console.log('#4 : invite_group');
		}
		break;

		case 'multi_chat':{
			console.log('#4 : multi_chat');
		}
		break;
	}
	

	return;
});


exports.tiggerMessage = functions.database.ref(path_message + '/{chat_id}/{key}/').onWrite(event => {

	if (!event.data.exists()) {
		return;
	}

	const crnt = event.data.current;
    const prev = event.data.previous;

    if (crnt.val() && !prev.val()) {
        // value created
        console.log('Created: {tiggerMessage}');
    } else if (!crnt.val() && prev.val()) {
        // value removed
        console.log('Removed: {tiggerMessage}');
    } else {
        // value updated
        console.log('Updated: {tiggerMessage}');
    }

    // var cc = event.data.current.val();

    console.log('key new : ' + event.params.key);

    console.log('Text : ' + event.data.val().text);
    console.log('Type : ' + event.data.val().type);

	var ref = db.ref(path);

    switch(event.data.val().type){
    	case 'group':{

			// https://stackoverflow.com/questions/42824688/firebase-get-data-by-key-or-chid-values-javascript
    		var chat_id  = event.params.chat_id;
    		var owner_id = event.data.val().owner_id;

    		var sender_id = event.data.val().uid;

    		//  udpate recents ของผู้ส่ง
			ref.child(sender_id).child("recents").child(chat_id).set({
		               	'create':admin.database.ServerValue.TIMESTAMP,
		               	'type':event.data.val().type,
		               	'text':event.data.val().text
		               });

			/*
				ดึงข้อมูล members ของ groups chat id โดยเราจะเอาเฉพาะ user ที่มี status = join เท่านั้น เพือ่ udpate recices ของ user id
			*/
			ref.child(owner_id).child('groups').child(chat_id).child("members").once("value", function(snap){

				/*
				console.log("xxxxxx #1");
				console.log("There are "+snap.numChildren()+" messages");
				console.log(JSON.stringify(snap.val()));
				console.log("xxxxxx #2");
				*/

				/*
				เช็กว่า  user id นี้มีข้อมูลหรือไม่
				*
				if (snap.numChildren() > 0) {
					ref.child(childSnapshot.key).child('update').child(event.params.type).child(event.params.nid).remove();
					// console.log("remove()" + childSnapshot.key);
				}
				*/

				

				//  udpate recents ของ friend(member)
				snap.forEach(function (snapshot) {
					console.log('x-x ' + snapshot.key +', status : ' + snapshot.val().status);

					ref.child(snapshot.key).child("recents").child(chat_id).set({
		               	'create':admin.database.ServerValue.TIMESTAMP,
		               	'type':event.data.val().type,
		               	'text':event.data.val().text
		               });
				});

			}, function (errorObject) {
	  			console.log(errorObject.code);
			});

    	}
    	break;

    	case 'private':{
    		var chat_id  = event.params.chat_id;
    		var friend_id  = event.data.val().friend_id;

    		var sender_id = event.data.val().uid;


			console.log('y-y chat_id : ' + chat_id +', friend_id : ' + friend_id);

			//  udpate recents ของ friend
			ref.child(friend_id).child("recents").child(chat_id).set({
		               	'create':admin.database.ServerValue.TIMESTAMP,
		               	'type':event.data.val().type,
		               	'text':event.data.val().text
		               });

			//  udpate recents ของผู้ส่ง
			ref.child(sender_id).child("recents").child(chat_id).set({
		               	'create':admin.database.ServerValue.TIMESTAMP,
		               	'type':event.data.val().type,
		               	'text':event.data.val().text
		               });
    	}
    	break;
    }

    // event.data.forEach(function(childSnapshot) {
    // 	// console.log(childSnapshot.val());
    // 	if (childSnapshot.key == event.params.key) {
    // 		console.log(childSnapshot);
    // 	}

    // 	console.log('> : ' + childSnapshot.key + ', ' + childSnapshot.val());

    // 	switch(childSnapshot.key){
    // 		case 'private':{

    // 		}
    // 		break;

    // 		case 'group':{
    			
    // 		}
    // 		break;
    // 	}
    // });

    return;
});
