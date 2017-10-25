package net.ichat.ichat;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.WindowManager;

import net.ichat.ichat.adapter.ContactsAdapter;
import net.ichat.ichat.application.App;
import net.ichat.ichat.configs.Configs;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;


/** @author Aidan Follestad (afollestad) */
public class ContactsActivity extends AppCompatActivity {
  private String TAG = ContactsActivity.class.getName();

  public final int RESULT_PROFILE = 10;

  private ContactsAdapter contactsAdapter;
  private boolean hideEmpty  = false;
  private boolean showFooters = false;
  private int count = 0;
  private Map<Integer, ArrayList<JSONObject>> data = new HashMap<Integer, ArrayList<JSONObject>>();

  private SharedPreferences appSharedPrefs;

  private ContactsListener contactsListener;
  public class ContactsListener extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
      if (intent.getAction().equals(Configs.PROFILES)) {
          reloadData();
      }else if (intent.getAction().equals(Configs.FRIENDS)) {
          reloadData();
      }else if (intent.getAction().equals(Configs.GROUPS)) {
          reloadData();
      }else if (intent.getAction().equals("Contacts_Reload")) {
          reloadData();
      }
    }
  }
  @Override
  protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_contacts);

    getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
            WindowManager.LayoutParams.FLAG_FULLSCREEN);
    getSupportActionBar().hide();

    appSharedPrefs  = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());

    RecyclerView recyclerView = (RecyclerView) findViewById(R.id.recycleView);
    contactsAdapter = new ContactsAdapter(this);

    GridLayoutManager manager = new GridLayoutManager(this, 1 /* เป็นจำนวนของ  item each row*/);
    recyclerView.setLayoutManager(manager);
    contactsAdapter.setLayoutManager(manager);

    /*
    * จะ hide เมือ section นั้นไม่มี item
    * */
    contactsAdapter.shouldShowHeadersForEmptySections(hideEmpty);

    /*
    * ปิดไม่ให้แสดง footer
    * */
    contactsAdapter.shouldShowFooters(showFooters);
    recyclerView.setAdapter(contactsAdapter);

    contactsListener = new ContactsListener();

    registerReceiver(contactsListener, new IntentFilter(Configs.PROFILES));
    registerReceiver(contactsListener, new IntentFilter(Configs.FRIENDS));
    registerReceiver(contactsListener, new IntentFilter(Configs.GROUPS));
    registerReceiver(contactsListener, new IntentFilter("Contacts_Reload"));

    reloadData();
  }

  private void reloadData() {
    ArrayList<JSONObject> profile = new ArrayList<>();
    ArrayList<JSONObject> friends = new ArrayList<>();
    ArrayList<JSONObject> groups  = new ArrayList<>();
    ArrayList<JSONObject> favorites = new ArrayList<>();

    try {
      data.clear();
      String strData = appSharedPrefs.getString(Configs.DATA, "");

      if (!strData.equalsIgnoreCase("")) {
        // #1 -- Profile
        JSONObject jsonProfile = new JSONObject(strData).getJSONObject("profiles");
        jsonProfile.put("title_section", "Profile");
        profile.add(jsonProfile);
        data.put(0, profile);

        // #2 -- Groups
        JSONObject jsonGroups = ((App)getApplicationContext()).getGroups();
        if (jsonGroups != null) {
          Iterator<String> iterG = jsonGroups.keys();
          while (iterG.hasNext()) {
            String key = iterG.next();
            try {
              JSONObject value = jsonGroups.getJSONObject(key);

              value.put("group_id", key);
              value.put("title_section", "Groups");

              groups.add(value);
            } catch (JSONException e) {
              // Something went wrong!
            }
          }
        }
        data.put(1, groups);

        // #3 -- Friends
        JSONObject jsonFriends = ((App)getApplicationContext()).getFriends();
        if (jsonFriends != null) {
          Iterator<String> iter = jsonFriends.keys();
          while (iter.hasNext()) {
            String key = iter.next();
            try {
              JSONObject value = jsonFriends.getJSONObject(key);


              /*
              * เช็กว่า friend คนนี้โดน hide หรือ block หรือเปล่า
              * */
              if (!checkIsHide(value) && !checkIsBlock(value) ) {
                /*
                * แสดงว่า hide == 0, block == 0
                * */
                value.put("friend_id", key);
                value.put("title_section", "Friends");
                friends.add(value);
                if (value.has("favorite")){
                  if (value.getString("favorite").equalsIgnoreCase("1")){

                    // clone JSONObject
                    JSONObject _value = new JSONObject(value.toString());;
                    _value.put("title_section", "Favorites");

                    favorites.add(_value);
                  }
                }
              }

            } catch (JSONException e) {
              // Something went wrong!
            }
          }
        }
        data.put(2, favorites);
        data.put(3, friends);

        contactsAdapter.setData(data);
      }
    }catch (Exception ex){
      Log.e(TAG, ex.toString());
    }
  }

  private Boolean checkIsHide(JSONObject val) {
    try {
        if (val.getString("hide").equalsIgnoreCase("1")){
          return true;
        }else{
          return false;
        }
    }catch (Exception ex){
      return false;
    }
  }

  private Boolean checkIsBlock(JSONObject val) {
    try {
      if (val.getString("block").equalsIgnoreCase("1")){
        return true;
      }else{
        return false;
      }
    }catch (Exception ex){
      return false;
    }
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    getMenuInflater().inflate(R.menu.main, menu);
    menu.findItem(R.id.hide_empty_sections).setChecked(!hideEmpty);
    menu.findItem(R.id.show_footers).setChecked(showFooters);
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    if (item.getItemId() == R.id.hide_empty_sections) {
      hideEmpty = !hideEmpty;
//      adapter.shouldShowHeadersForEmptySections(hideEmpty);
//      item.setChecked(!hideEmpty);

      try {
        /*
        Iterator myVeryOwnIterator = data.keySet().iterator();
        while (myVeryOwnIterator.hasNext()) {
          Integer key = (Integer) myVeryOwnIterator.next();
          if (0 == key) {
            ArrayList<String> value = (ArrayList<String>) data.get(key);
            // Toast.makeText(ctx, "Key: "+key+" Value: "+value, Toast.LENGTH_LONG).show();

            // emotionName
            // holder.title.setText(value.get(relativePosition).getString("path"));

            // ImageLoader imageLoader = ImageLoader.getInstance();
            // imageLoader.displayImage(value.get(relativePosition).getString("path"), holder.image);

            // holder.title.setText(value.get(relativePosition));
            // value.add("xx-" + (count++));
            value.remove(count);

            data.put(0, value);

            contactsAdapter.setData(data);

          }else if (1 == key) {
            ArrayList<String> value = (ArrayList<String>) data.get(key);
            // Toast.makeText(ctx, "Key: "+key+" Value: "+value, Toast.LENGTH_LONG).show();

            // emotionName
            // holder.title.setText(value.get(relativePosition).getString("path"));

            // ImageLoader imageLoader = ImageLoader.getInstance();
            // imageLoader.displayImage(value.get(relativePosition).getString("path"), holder.image);

            // holder.title.setText(value.get(relativePosition));
            value.add("xx-" + (count++));

            data.put(1, value);

            contactsAdapter.setData(data);
          }
        }
        */
      }catch (Exception ex){
        Log.e("", ex.toString());
      }

      Log.e("", "");
      return true;
    }else if (item.getItemId() == R.id.show_footers) {
//      showFooters = !showFooters;
//      adapter.shouldShowFooters(showFooters);
//      item.setChecked(showFooters);

      Log.e("", "");
      return true;
    }

    return super.onOptionsItemSelected(item);
  }

  @Override
  protected void onDestroy() {
    super.onDestroy();
    try {
      unregisterReceiver(contactsListener);
    }catch (Exception ex){
      Log.e(TAG, ex.toString());
    }
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {

    if (requestCode == 1) {
      if(resultCode == Activity.RESULT_OK){
        String result=data.getStringExtra("result");
      }
      if (resultCode == Activity.RESULT_CANCELED) {
        //Write your code if there's no result
      }
    }
  }
}
