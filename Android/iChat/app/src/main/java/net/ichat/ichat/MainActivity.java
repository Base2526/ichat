package net.ichat.ichat;

import android.app.Dialog;
import android.app.LocalActivityManager;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TabHost;

import com.google.firebase.database.ChildEventListener;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import net.ichat.ichat.application.App;
import net.ichat.ichat.configs.Configs;
import net.ichat.ichat.configs.Messages;
import net.ichat.ichat.configs.MessagesRepo;
import net.ichat.ichat.dialog.DialogFriend;
import net.ichat.ichat.handler.AnNmousUHandler;
import net.ichat.ichat.thread.AnNmousUThread;
import net.ichat.ichat.utils.JsonUtils;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class MainActivity extends AppCompatActivity {
    private String TAG = MainActivity.class.getName();
    private TabHost host;

    private DatabaseReference mDatabase;

    public AnNmousUHandler nmousUHandler = new AnNmousUHandler(this);

    // HashMap<String, Object> _items = new HashMap<String, Object>();

    private SharedPreferences appSharedPrefs;

    public final int DIALOG_WAIT = 0;
    private ProgressDialog progDialog;

    public final int CHANGE_FRIEND_NAME = 0;

    @Override
    protected void onStart() {
        super.onStart();

        if (appSharedPrefs.getString(Configs.USER, "") == ""){
            showDialog(DIALOG_WAIT);
            new AnNmousUThread(this).start();
        }else{
            String USER = appSharedPrefs.getString(Configs.USER, "");
            try {
                if(USER != "") {
                    JSONObject user = new JSONObject(USER).getJSONObject("user");

                    Map<String, Object> childUpdates = new HashMap<>();
                    childUpdates.put("toonchat/" + user.getString("uid") + "/profiles/online", "1");

                    mDatabase.updateChildren(childUpdates);
                }
                init();
            }catch (Exception ex){
                Log.e(TAG, ex.toString());
            }

        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        if (appSharedPrefs.getString(Configs.USER, "") != ""){
            String USER = appSharedPrefs.getString(Configs.USER, "");
            try {
                if(USER != "") {
                    JSONObject user = new JSONObject(USER).getJSONObject("user");

                    Map<String, Object> childUpdates = new HashMap<>();
                    childUpdates.put("toonchat/" + user.getString("uid") + "/profiles/online", "0");

                    mDatabase.updateChildren(childUpdates);
                }
            }catch (Exception ex){
                Log.e(TAG, ex.toString());
            }
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        ((App)getApplicationContext()).setMainActivity(this);

        appSharedPrefs  = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
        mDatabase       = FirebaseDatabase.getInstance().getReference();

        // startActivity(new Intent(this, ChatView.class));

        host = (TabHost) findViewById(R.id.tabHost);
        LocalActivityManager mLocalActivityManager = new LocalActivityManager(this, false);
        mLocalActivityManager.dispatchCreate(savedInstanceState); // state will be bundle your activity state which you get in onCreate
        host.setup(mLocalActivityManager);
        // host.setup();

        LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        //Tab 1
        TabHost.TabSpec spec = host.newTabSpec("Tab One");
        spec.setContent(new Intent(this, ContactsActivity.class));
        spec.setIndicator(inflater.inflate(R.layout.tab_home, null));//("" ,getResources().getDrawable(R.drawable.friends_icon));
        host.addTab(spec);


        //Tab 2
        spec = host.newTabSpec("Tab Two");
        spec.setContent(new Intent(this, RecentActivity.class));
        spec.setIndicator(inflater.inflate(R.layout.tab_update, null));
        host.addTab(spec);

/*
        //Tab 3
        spec = host.newTabSpec("Tab Three");
        spec.setContent(new Intent(this, TabGallerys.class));
        spec.setIndicator(inflater.inflate(R.layout.tab_gallerys, null));
        host.addTab(spec);

        //Tab 4
        spec = host.newTabSpec("Tab Three");
        spec.setContent(new Intent(this, TabMore.class));
        spec.setIndicator(inflater.inflate(R.layout.tab_more, null));
        host.addTab(spec);
        */

        setTitle("iChat");
        host.setOnTabChangedListener(new TabHost.OnTabChangeListener() {

            public void onTabChanged(String tabId) {
                Log.d(TAG, "onTabChanged: tab number=" + host.getCurrentTab());
                for(int i=0;i<host.getTabWidget().getChildCount();i++){
                    host.getTabWidget().getChildAt(i)
                            .setBackgroundColor(Color.WHITE);
                }
                host.getTabWidget().getChildAt(host.getCurrentTab())
                        .setBackgroundColor(Color.parseColor("#C0C0C0"));

                Intent intent = new Intent();
                switch (host.getCurrentTab()) {
                    case 0: {

                        try {
                            JSONObject user = new JSONObject(appSharedPrefs.getString(Configs.USER, "")).getJSONObject("user");
                            setTitle("Contacts " + user.getString("uid"));
                            invalidateOptionsMenu();
                        }catch (Exception ex){
                            Log.e(TAG, ex.toString());
                        }
                        break;
                    }
                    case 1: {
                        setTitle("Recent");
                        invalidateOptionsMenu();
                        break;
                    }
                    /*
                    case 2: {
                        setTitle("Gallery");
                        invalidateOptionsMenu();
                        break;
                    }
                    case 3: {
                        setTitle("More");
                        invalidateOptionsMenu();
                        break;
                    }
                    */
                    default:

                        break;
                }
                sendBroadcast(intent);
            }
        });

        for(int i=0;i<host.getTabWidget().getChildCount();i++){
            host.getTabWidget().getChildAt(i).setBackgroundColor(Color.WHITE);


            /*
            *  เราต้องใช้ loop ในการ access id เพือ่กำหนด budget number
            * */
            // View sp =  host.getTabWidget().getChildAt(i);
            // Log.e(TAG, "");
        }
        host.getTabWidget().getChildAt(0).setBackgroundColor(Color.parseColor("#C0C0C0"));

        init();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.reload_data: {
                // startActivity(new Intent(this, CreateGroupActivity.class));
                Intent i = new Intent("Contacts_Reload");
                Bundle bundle = new Bundle();

                i.putExtras(bundle);
                sendBroadcast(i);
            }
            break;
            case R.id.create_group: {
                startActivity(new Intent(this, CreateGroupActivity.class));
            }
            break;

            case R.id.friend_hide:{
                startActivity(new Intent(this, FriendHideActivity.class));
            }
            break;

            case R.id.friend_block:{
                startActivity(new Intent(this, FriendBlockActivity.class));
            }
            break;
        }
        return  true;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        switch (host.getCurrentTab()){
            case 0:{
                getMenuInflater().inflate(R.menu.menu_contacts, menu);
            }
                break;

            case 1:{

            }
                break;
        }

        return super.onCreateOptionsMenu(menu);
    }

    private void init(){
        try{
            JSONObject user = new JSONObject(appSharedPrefs.getString(Configs.USER, "")).getJSONObject("user");

            setTitle("Contacts " + user.getString("uid"));
        }catch (Exception ex){
            Log.e(TAG, ex.toString());
        }


        // SharedPreferences appSharedPrefs = PreferenceManager.getDefaultSharedPreferences(this.getApplicationContext());
        String USER = appSharedPrefs.getString(Configs.USER, "");

        if (USER != "") {

            try {
                JSONObject user = new JSONObject(USER).getJSONObject("user");
                final FirebaseDatabase database = FirebaseDatabase.getInstance();
                DatabaseReference myRef = database.getReference("toonchat/" +user.getString("uid") +"/");

                myRef.addChildEventListener(new ChildEventListener() {
                    @Override
                    public void onChildAdded(final DataSnapshot dataSnapshot, String prevChildKey) {

                        // Log.e(TAG, "#1. key : " + dataSnapshot.getKey());
                        // Log.e(TAG, "#1. value : " + dataSnapshot.getValue());

                        if ((dataSnapshot.getKey().equalsIgnoreCase("profiles"))){
                            ((App)getApplicationContext()).updateMyProfiles(JsonUtils.mapToJson((HashMap)dataSnapshot.getValue()));

                            Intent i = new Intent(Configs.PROFILES);
                            Bundle bundle = new Bundle();

                            i.putExtras(bundle);
                            sendBroadcast(i);
                        }else if(dataSnapshot.getKey().equalsIgnoreCase("friends")){
                            ((App)getApplicationContext()).updateFriends(JsonUtils.mapToJson((HashMap)dataSnapshot.getValue()));

                            Intent i = new Intent(Configs.FRIENDS);
                            Bundle bundle = new Bundle();

                            i.putExtras(bundle);
                            sendBroadcast(i);
                        }else if(dataSnapshot.getKey().equalsIgnoreCase("invite_group")){
                            JSONObject jsonObject = JsonUtils.mapToJson((HashMap)dataSnapshot.getValue());

                            Iterator<String> iter = jsonObject.keys();
                            while (iter.hasNext()) {
                                String id_invite_group = iter.next();
                                try {
                                    JSONObject value = jsonObject.getJSONObject(id_invite_group);

                                    String owner_id = value.getString("owner_id");//[value objectForKey:@"owner_id"];


                                    // __block NSString *child = [NSString stringWithFormat:@"toonchat/%@/groups/%@", owner_id, id_invite_group];

                                    final FirebaseDatabase database = FirebaseDatabase.getInstance();
                                    DatabaseReference myRef = database.getReference("toonchat/" + owner_id +"/groups/" + id_invite_group);

                                    myRef.addListenerForSingleValueEvent(new ValueEventListener() {
                                        @Override
                                        public void onDataChange(DataSnapshot snapshot) {
                                            JSONObject jsonObject = JsonUtils.mapToJson((HashMap)snapshot.getValue());

                                            SharedPreferences appSharedPrefs = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
                                            SharedPreferences.Editor prefsEditor = appSharedPrefs.edit();
                                            prefsEditor.putString(snapshot.getKey(), jsonObject.toString());
                                            prefsEditor.commit();
                                        }
                                        @Override
                                        public void onCancelled(DatabaseError databaseError) {
                                        }
                                    });
                                    Log.e(TAG, "");
                                } catch (JSONException e) {
                                    // Something went wrong!
                                    Log.e(TAG, e.toString());
                                }
                            }
                            Log.e(TAG, "");
                        }else if(dataSnapshot.getKey().equalsIgnoreCase("groups")){
                            // JSONObject jsonObject = JsonUtils.mapToJson((HashMap)dataSnapshot.getValue());

                            /*
                            Iterator<String> iter = jsonObject.keys();
                            while (iter.hasNext()) {
                                String id_group = iter.next();

                                try {
                                    JSONObject value = jsonObject.getJSONObject(id_group);

                                    Log.e(TAG, "");
                                }catch (Exception ex){
                                    Log.e(TAG, ex.toString());
                                }
                            }
                            */

                            ((App)getApplicationContext()).updateGroups(JsonUtils.mapToJson((HashMap)dataSnapshot.getValue()));

                            Intent i = new Intent(Configs.GROUPS);
                            Bundle bundle = new Bundle();

                            i.putExtras(bundle);
                            sendBroadcast(i);
                        }else if(dataSnapshot.getKey().equalsIgnoreCase("multi_chat")){
                            JSONObject jsonObject = JsonUtils.mapToJson((HashMap)dataSnapshot.getValue());

                            Iterator<String> iter = jsonObject.keys();
                            while (iter.hasNext()) {
                                String id_group = iter.next();

                                try {
                                    JSONObject value = jsonObject.getJSONObject(id_group);

                                    final FirebaseDatabase database = FirebaseDatabase.getInstance();
                                    DatabaseReference toonchat_message = database.getReference("toonchat_message/" +value.getString("chat_id"));

                                    toonchat_message.addChildEventListener(new ChildEventListener() {
                                        @Override
                                        public void onChildAdded(final DataSnapshot dataSnapshot, String prevChildKey) {

                                            try {
                                                // จะได้ chat_id
                                                String chat_id = dataSnapshot.getRef().getParent().getKey();

                                                String key = dataSnapshot.getKey();
                                                JSONObject jsonObject = JsonUtils.mapToJson((HashMap) dataSnapshot.getValue());

                                                MessagesRepo messagesRepo = new MessagesRepo(MainActivity.this);

                                                if (messagesRepo.check(key) == 0) {
                                                    Messages mm = new Messages();
                                                    mm.update       = jsonObject.getString("update");
                                                    mm.status       = jsonObject.getString("status");
                                                    mm.receive_id   = jsonObject.getString("receive_id");
                                                    mm.sender_id    = jsonObject.getString("sender_id");
                                                    mm.create       = jsonObject.getString("create");
                                                    mm.object_id    = jsonObject.getString("object_id");
                                                    mm.text         = jsonObject.getString("text");
                                                    mm.chat_id      = chat_id;//jsonObject.getString("chat_id"); <-- ในอนาคตจะมีการเอาออกเลยดึง chat_id จาก parent key แทน
                                                    mm.type         = jsonObject.getString("type");

                                                    mm.reader       = "";
                                                    if (jsonObject.has("reader")) {
                                                        mm.reader   = jsonObject.getString("reader");
                                                    }
                                                    messagesRepo.insert(mm);
                                                }
                                            }catch (Exception ex){
                                                Log.e(TAG, ex.toString());
                                            }
                                        }

                                        @Override
                                        public void onChildChanged(DataSnapshot dataSnapshot, String s) {
                                            Log.e(TAG, "");
                                        }

                                        @Override
                                        public void onChildMoved(DataSnapshot dataSnapshot, String s) {

                                        }

                                        @Override
                                        public void onChildRemoved(DataSnapshot dataSnapshot) {

                                        }

                                        @Override
                                        public void onCancelled(DatabaseError databaseError) {

                                        }
                                    });


                                }catch (Exception ex){
                                    Log.e(TAG, ex.toString());
                                }
                            }
                            Log.e(TAG, "");
                        }


//                        switch (dataSnapshot.getKey()){
//                            case "alumni_news":
//                                _items.put(dataSnapshot.getKey(), (JSONObject) dataSnapshot.getValue());
//                                break;
//                            case "parent_letter":
//                                _items.put(dataSnapshot.getKey(), (JSONObject) dataSnapshot.getValue());
//                                break;
//                            case "recruitment":
//                                _items.put(dataSnapshot.getKey(), (JSONObject) dataSnapshot.getValue());
//                                break;
//                            case "purchase":
//
//                                break;
//                            case "news_public_relations":
//
//                                break;
//
//                            case "news_activity":
//
//                                break;
//                        }


                        // ((App)getApplication())._items.put(dataSnapshot.getKey(), dataSnapshot.getValue());


                        updateBudget();

                        Log.e(TAG, "");
                    }

                    @Override
                    public void onChildRemoved(DataSnapshot dataSnapshot) {
                        Log.e(TAG, "onChildRemoved : " + dataSnapshot.getValue());
                    }

                    @Override
                    public void onCancelled(DatabaseError databaseError) {
                        Log.e(TAG, "onCancelled" );
                    }

                    @Override
                    public void onChildChanged(DataSnapshot dataSnapshot, String s) {
                        Log.e(TAG, "onChildChanged : " + dataSnapshot.getValue());
                        // new sAsyncTaskChangedRelationFriendshipList().execute(dataSnapshot);

                        // ((App)getApplication())._items.put(dataSnapshot.getKey(), dataSnapshot.getValue());

                        // updateBudget();
                    }

                    @Override
                    public void onChildMoved(DataSnapshot dataSnapshot, String s) {
                        Log.e(TAG, "onChildMoved");
                    }
                });


                String strData = appSharedPrefs.getString(Configs.DATA, "");
                JSONObject jsonData = new JSONObject(strData);

                if (jsonData.has(Configs.FRIENDS)){
                    JSONObject jsonFriends = jsonData.getJSONObject(Configs.FRIENDS);


                    Iterator<String> iter = jsonFriends.keys();
                    while (iter.hasNext()) {
                        String key = iter.next();
                        try {
                            JSONObject val = jsonFriends.getJSONObject(key);

                            // NSString *child = [NSString stringWithFormat:@"toonchat/%@/", key];

                            /*
                            * กรณีเพือนเราจะ แท๊กเฉพาะ profile friend เท่านั้น
                            * */
                            DatabaseReference myRef_Friend = FirebaseDatabase.getInstance().getReference("toonchat/" + key +"/profiles/");

                            myRef_Friend.addChildEventListener(new ChildEventListener() {
                                @Override
                                public void onChildAdded(final DataSnapshot dataSnapshot, String prevChildKey) {
                                    if(((App)getApplicationContext()).updateProfileFriend(dataSnapshot)){

                                    }else{
                                        Log.e(TAG, "");
                                    }
                                }

                                @Override
                                public void onChildRemoved(DataSnapshot dataSnapshot) {
                                    Log.e(TAG, "onChildRemoved : " + dataSnapshot.getValue());
                                }

                                @Override
                                public void onCancelled(DatabaseError databaseError) {
                                    Log.e(TAG, "onCancelled" );
                                }

                                @Override
                                public void onChildChanged(DataSnapshot dataSnapshot, String s) {
                                    Log.e(TAG, "onChildChanged : " + dataSnapshot.getValue());

                                    if(((App)getApplicationContext()).updateProfileFriend(dataSnapshot)){

                                        Intent i = new Intent(Configs.FRIENDS);
                                        Bundle bundle = new Bundle();

                                        i.putExtras(bundle);
                                        sendBroadcast(i);
                                    }else{
                                        Log.e(TAG, "");
                                    }

                                }

                                @Override
                                public void onChildMoved(DataSnapshot dataSnapshot, String s) {
                                    Log.e(TAG, "onChildMoved");
                                }
                            });

                            DatabaseReference myRef_Message = FirebaseDatabase.getInstance().getReference("toonchat_message/" + val.getString("chat_id") +"/");

                            myRef_Message.addChildEventListener(new ChildEventListener() {
                                @Override
                                public void onChildAdded(final DataSnapshot dataSnapshot, String prevChildKey) {
                                    Log.e(TAG, "");

                                    try {
                                        // จะได้ chat_id
                                        String chat_id = dataSnapshot.getRef().getParent().getKey();

                                        String key = dataSnapshot.getKey();
                                        JSONObject jsonObject = JsonUtils.mapToJson((HashMap) dataSnapshot.getValue());

                                        MessagesRepo messagesRepo = new MessagesRepo(MainActivity.this);

                                        if (messagesRepo.check(key) == 0) {
                                            Messages mm = new Messages();
                                            mm.update       = jsonObject.getString("update");
                                            mm.status       = jsonObject.getString("status");
                                            mm.receive_id   = jsonObject.getString("receive_id");
                                            mm.sender_id    = jsonObject.getString("sender_id");
                                            mm.create       = jsonObject.getString("create");
                                            mm.object_id    = jsonObject.getString("object_id");
                                            mm.text         = jsonObject.getString("text");
                                            mm.chat_id      = chat_id;//jsonObject.getString("chat_id"); <-- ในอนาคตจะมีการเอาออกเลยดึง chat_id จาก parent key แทน
                                            mm.type         = jsonObject.getString("type");

                                            mm.reader       = "";
                                            if (jsonObject.has("reader")) {
                                                mm.reader   = jsonObject.getString("reader");
                                            }
                                            messagesRepo.insert(mm);
                                        }
                                    }catch (Exception ex){
                                        Log.e(TAG, ex.toString());
                                    }
                                }

                                @Override
                                public void onChildRemoved(DataSnapshot dataSnapshot) {
                                    Log.e(TAG, "onChildRemoved : " + dataSnapshot.getValue());
                                }

                                @Override
                                public void onCancelled(DatabaseError databaseError) {
                                    Log.e(TAG, "onCancelled" );
                                }

                                @Override
                                public void onChildChanged(DataSnapshot dataSnapshot, String s) {
                                    Log.e(TAG, "onChildChanged : " + dataSnapshot.getValue());
                                    // new sAsyncTaskChangedRelationFriendshipList().execute(dataSnapshot);

                                    try {
                                        // จะได้ chat_id
                                        String chat_id = dataSnapshot.getRef().getParent().getKey();

                                        String key = dataSnapshot.getKey();
                                        JSONObject jsonObject = JsonUtils.mapToJson((HashMap) dataSnapshot.getValue());

                                        MessagesRepo messagesRepo = new MessagesRepo(MainActivity.this);

                                        if (messagesRepo.check(key) == 0) {
                                            Messages mm = new Messages();
                                            mm.update       = jsonObject.getString("update");
                                            mm.status       = jsonObject.getString("status");
                                            mm.receive_id   = jsonObject.getString("receive_id");
                                            mm.sender_id    = jsonObject.getString("sender_id");
                                            mm.create       = jsonObject.getString("create");
                                            mm.object_id    = jsonObject.getString("object_id");
                                            mm.text         = jsonObject.getString("text");
                                            mm.chat_id      = chat_id;//jsonObject.getString("chat_id"); <-- ในอนาคตจะมีการเอาออกเลยดึง chat_id จาก parent key แทน
                                            mm.type         = jsonObject.getString("type");

                                            mm.reader       = "";
                                            if (jsonObject.has("reader")) {
                                                mm.reader   = jsonObject.getString("reader");
                                            }
                                            messagesRepo.insert(mm);
                                        }else{

                                            Messages mm = new Messages();
                                            mm.update       = jsonObject.getString("update");
                                            mm.status       = jsonObject.getString("status");
                                            mm.receive_id   = jsonObject.getString("receive_id");
                                            mm.sender_id    = jsonObject.getString("sender_id");
                                            mm.create       = jsonObject.getString("create");
                                            mm.object_id    = jsonObject.getString("object_id");
                                            mm.text         = jsonObject.getString("text");
                                            mm.chat_id      = chat_id;//jsonObject.getString("chat_id"); <-- ในอนาคตจะมีการเอาออกเลยดึง chat_id จาก parent key แทน
                                            mm.type         = jsonObject.getString("type");

                                            mm.reader       = "";
                                            if (jsonObject.has("reader")) {
                                                mm.reader   = jsonObject.getString("reader");
                                            }
                                            messagesRepo.update(mm);
                                        }
                                    }catch (Exception ex){
                                        Log.e(TAG, ex.toString());
                                    }
                                }

                                @Override
                                public void onChildMoved(DataSnapshot dataSnapshot, String s) {
                                    Log.e(TAG, "onChildMoved");
                                }
                            });

                        } catch (JSONException e) {
                            // Something went wrong!
                        }
                    }
                }
            }catch (Exception ex){
                Log.e(TAG, ex.toString());
            }
        }
    }

    private void updateBudget(){

    }

    public void showDialogFriend(String type, String data){
        DialogFriend dialogFragment = new DialogFriend();

        Bundle args = new Bundle();
        args.putString("type", type);  // friend_firebase_id
        args.putString("data", data);  // friend_firebase_id
        dialogFragment.setArguments(args);
        dialogFragment.setCancelable(false);  // กรณีที่เราไม่ต้องการให้ touch out view ของ DialogFragment แล้ว  dismiss
        dialogFragment.show(getSupportFragmentManager(), "");
    }

    @Override
    protected Dialog onCreateDialog(int id) {
        switch (id) {
            case DIALOG_WAIT:
                progDialog = new ProgressDialog(this);
                progDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
                progDialog.setMessage("Wait");
                progDialog.setCancelable(false);
                return progDialog;
            default:
                return null;
        }
    }

    public void UserLg(){
        String USER = appSharedPrefs.getString(Configs.USER, "");
        try {

            if(USER != "") {
                JSONObject user = new JSONObject(USER).getJSONObject("user");

//                Map<String, Object> childUpdates = new HashMap<>();
//                childUpdates.put("userLogin/" + user.getString("uid") + "/HW/token", FirebaseInstanceId.getInstance().getToken());
//                childUpdates.put("userLogin/" + user.getString("uid") + "/HW/platform", "android");
//                childUpdates.put("userLogin/" + user.getString("uid") + "/HW/online", "1");
//
//                Long tsLong = System.currentTimeMillis()/1000;
//                childUpdates.put("userLogin/" + user.getString("uid") + "/create", tsLong.toString());

                Map<String, Object> childUpdates = new HashMap<>();
                childUpdates.put("toonchat/" + user.getString("uid") + "/profiles/online", "1");

                mDatabase.updateChildren(childUpdates);

                init();

                dismissDialog(DIALOG_WAIT);
            }
        }catch (Exception ex){
            Log.e(TAG, "");
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

    }//
}
