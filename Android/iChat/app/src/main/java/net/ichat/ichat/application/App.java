package net.ichat.ichat.application;

import android.app.Application;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.preference.PreferenceManager;
import android.util.Log;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.cache.memory.impl.WeakMemoryCache;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;
import com.nostra13.universalimageloader.core.display.FadeInBitmapDisplayer;

import net.ichat.ichat.MainActivity;
import net.ichat.ichat.R;
import net.ichat.ichat.configs.Configs;
import net.ichat.ichat.utils.JsonUtils;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

/**
 * Created by somkid on 13/10/2017 AD.
 */

public class App extends Application {
    private String TAG = App.class.getName();

    private SharedPreferences appSharedPrefs;

    private MainActivity mainActivity;
    @Override
    public void onCreate() {
        super.onCreate();

        initImageLoader(getApplicationContext());

        appSharedPrefs = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    }

    public void setMainActivity(MainActivity mainActivity) {
        this.mainActivity = mainActivity;
    }

    public MainActivity getMainActivity() {
        return this.mainActivity;
    }

    public void initImageLoader(Context context) {
        DisplayImageOptions defaultOptions = new DisplayImageOptions.Builder()
                .cacheOnDisk(true).cacheInMemory(true)
                .imageScaleType(ImageScaleType.EXACTLY)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .resetViewBeforeLoading(false)
                .displayer(new FadeInBitmapDisplayer(300))
                .showImageForEmptyUri(R.drawable.ic_placeholder)
                .showImageOnFail(R.drawable.ic_placeholder)
                .showImageOnLoading(R.drawable.ic_placeholder)
                .considerExifParams(true)
                .build();

        ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(getApplicationContext())
                .defaultDisplayImageOptions(defaultOptions)
                .memoryCache(new WeakMemoryCache())
                .threadPoolSize(5)
                .diskCacheSize(1000 * 1024 * 1024)
                .denyCacheImageMultipleSizesInMemory()
                .diskCacheFileNameGenerator(new Md5FileNameGenerator())
                .tasksProcessingOrder(QueueProcessingType.LIFO)
                .build();

        ImageLoader.getInstance().init(config);
    }

    /*
     จะ Sync ข้อมูลใหม่ทุกครั่งที่ login
     */
    int count = 0;
    JSONObject jsonFriends;
    public void  synchronizeDataLogin(){

        final FirebaseDatabase database = FirebaseDatabase.getInstance();
        DatabaseReference myRef = database.getReference("toonchat/" + getUserId());

        myRef.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot snapshot) {
                JSONObject jsonObject = JsonUtils.mapToJson((HashMap)snapshot.getValue());


                SharedPreferences appSharedPrefs = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
                SharedPreferences.Editor prefsEditor = appSharedPrefs.edit();
                prefsEditor.putString(Configs.DATA, jsonObject.toString());
                prefsEditor.commit();


                try {

                    // String strData = appSharedPrefs.getString(Configs.DATA, "");
                    // JSONObject jsonF = new JSONObject(strData);

                    jsonFriends = jsonObject.getJSONObject("friends");
                    Iterator<String> iter = jsonFriends.keys();
                    while (iter.hasNext()) {
                        String friend_id = iter.next();

                        Object value = jsonObject.getJSONObject("friends").get(friend_id);
                        // NSString *fchild = [NSString stringWithFormat:@"toonchat/%@/profiles", key];

                        final FirebaseDatabase database = FirebaseDatabase.getInstance();
                        DatabaseReference myRef = database.getReference("toonchat/" + friend_id + "/profiles");


                        myRef.addListenerForSingleValueEvent(new ValueEventListener() {
                            @Override
                            public void onDataChange(DataSnapshot snapshot) {
                                JSONObject jsonObject = JsonUtils.mapToJson((HashMap) snapshot.getValue());

                                /**
                                 * เป็นการ save profile ของ friend แยกตาม friend id
                                 */
                                SharedPreferences appSharedPrefs = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
                                SharedPreferences.Editor prefsEditor = appSharedPrefs.edit();
                                prefsEditor.putString(snapshot.getRef().getParent().getKey(), jsonObject.toString());
                                prefsEditor.commit();

                                count++;

                                if (jsonFriends.length() == count){
                                    getMainActivity().UserLg();
                                }
                            }

                            @Override
                            public void onCancelled(DatabaseError databaseError) {
                            }
                        });

                        Log.e(TAG, "");

                    }
                } catch (Exception e) {
                    // Something went wrong!
                }
            }
            @Override
            public void onCancelled(DatabaseError databaseError) {
            }
        });
    }

    /*
    * uid ของ user current login
    * */
    public String getUserId() {
        try {
            JSONObject jsonUser = new JSONObject(appSharedPrefs.getString(Configs.USER, ""));
            return jsonUser.getJSONObject("user").getString("uid");
        }catch (Exception ex){
            return "";
        }
    }

    /*
    * Get MyProfile
    * */
    public JSONObject getMyProfile() {
        try{
            String strData = appSharedPrefs.getString(Configs.DATA, "");
            JSONObject jsonData = new JSONObject(strData);

            return jsonData.getJSONObject(Configs.PROFILES);

        }catch (Exception ex){
            return null;
        }
    }


    /*
    * Update profiles
    * */
    public Boolean updateMyProfiles(JSONObject myProfiles) {
        try{
            String strData = appSharedPrefs.getString(Configs.DATA, "");
            JSONObject jsonData = new JSONObject(strData);
            jsonData.put(Configs.PROFILES, myProfiles);

            SharedPreferences.Editor prefsEditor = appSharedPrefs.edit();
            prefsEditor.putString(Configs.DATA, jsonData.toString());
            prefsEditor.commit();

            return true;
        }catch (Exception ex){
            return false;
        }
    }

    /*
   * Update Friends คือเราจะเขียนทับ friends ทั้งหมด
   * */
    public Boolean updateFriends(JSONObject friends) {
        try{
            String strData = appSharedPrefs.getString(Configs.DATA, "");
            JSONObject jsonData = new JSONObject(strData);
            jsonData.put(Configs.FRIENDS, friends);

            SharedPreferences.Editor prefsEditor = appSharedPrefs.edit();
            prefsEditor.putString(Configs.DATA, jsonData.toString());
            prefsEditor.commit();

            return true;
        }catch (Exception ex){
            return false;
        }
    }

    /*
     * Update Groups คือเราจะเขียนทับ group ทั้งหมด
     * */
    public Boolean updateGroups(JSONObject groups) {
        try{
            String strData = appSharedPrefs.getString(Configs.DATA, "");
            JSONObject jsonData = new JSONObject(strData);
            jsonData.put(Configs.GROUPS, groups);

            SharedPreferences.Editor prefsEditor = appSharedPrefs.edit();
            prefsEditor.putString(Configs.DATA, jsonData.toString());
            prefsEditor.commit();

            return true;
        }catch (Exception ex){
            return false;
        }
    }

    /*
    * เพือ่นทั้งหมด
    */
    public JSONObject getFriends() {
        try {
            String strData = appSharedPrefs.getString(Configs.DATA, "");
            JSONObject jsonData = new JSONObject(strData);

            return jsonData.getJSONObject(Configs.FRIENDS);
        }catch (Exception ex){
            return null;
        }
    }

        /*
      * เพือ่นทั้งหมด
      */
    public JSONObject getGroups() {
        try {
            String strData = appSharedPrefs.getString(Configs.DATA, "");
            JSONObject jsonData = new JSONObject(strData);

            return jsonData.getJSONObject(Configs.GROUPS);
        }catch (Exception ex){
            return null;
        }
    }

    /*
    * ดึง profile friend by friend_id
    */
    public JSONObject getProfileFriend(String friend_id) {
        try {
            String profileFriend = appSharedPrefs.getString(friend_id, "");
            return new JSONObject(profileFriend);
        }catch (Exception ex){
            return null;
        }
    }

    /*
    *  update profile friend by friend_id
    * */
    public Boolean updateProfileFriend(DataSnapshot dataSnapshot){
        try {
            String friend_id = dataSnapshot.getRef().getParent().getParent().getKey();

            String profileFriend = appSharedPrefs.getString(friend_id, "");
            JSONObject jsonPFriend = new JSONObject(profileFriend);

            jsonPFriend.put(dataSnapshot.getKey(), dataSnapshot.getValue());

            SharedPreferences appSharedPrefs = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
            SharedPreferences.Editor prefsEditor = appSharedPrefs.edit();
            prefsEditor.putString(friend_id, jsonPFriend.toString());
            prefsEditor.commit();

            profileFriend = appSharedPrefs.getString(friend_id, "");
            Log.e(TAG, "");
            return true;
        }catch (Exception ex){
            return false;
        }
    }


    /*
    * เป้นการลบ group ที่ firebase
    * */
    public Boolean deleteGroup(String group_id) {
        try {
            final FirebaseDatabase database = FirebaseDatabase.getInstance();
            database.getReference("toonchat/" + getUserId() + "/groups/" + group_id).removeValue();
            return true;
        }catch (Exception ex){
            return false;
        }
    }

    /*
    * เป้นการลบ friend ออกจาก group
    * */
    public Boolean deleteMemberForGroup(String group_id, String node_id){

        /*
        NSString *child = [NSString stringWithFormat:@"toonchat/%@/groups/%@/members/%@", [[Configs sharedInstance] getUIDU], [self.group objectForKey:@"group_id"], key];

        * */

        try {
            final FirebaseDatabase database = FirebaseDatabase.getInstance();
            database.getReference("toonchat/" + getUserId() + "/groups/" + group_id + "/members/" + node_id).removeValue();
            return true;
        }catch (Exception ex){
            return false;
        }
    }
}
