package net.ichat.ichat;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.MenuItem;

import net.ichat.ichat.adapter.FriendBlockAdapter;
import net.ichat.ichat.application.App;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Iterator;

public class FriendBlockActivity extends AppCompatActivity {
    private String TAG = FriendBlockActivity.class.getName();
    private RecyclerView recycler_view;

    private FriendBlockAdapter friendBlockAdapter;
    private ArrayList<JSONObject> _items;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_friend_block);

        setTitle("Friend block");

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        recycler_view = (RecyclerView)findViewById(R.id.recycler_view);

        recycler_view.setLayoutManager(new LinearLayoutManager(this));

        _items = new ArrayList<JSONObject>();
        friendBlockAdapter = new FriendBlockAdapter(this, _items);
        recycler_view.setAdapter(friendBlockAdapter);

        loadData();
    }

    public void loadData() {
//        for (int i=0; i<=50; i++){
//            _items.add("" + i);
//        }

        _items.clear();

        JSONObject jsonFriends = ((App)getApplicationContext()).getFriends();
        if (jsonFriends != null) {
            Iterator<String> iter = jsonFriends.keys();
            while (iter.hasNext()) {
                String key = iter.next();
                try {
                    JSONObject value = jsonFriends.getJSONObject(key);

                    value.put("friend_id", key);

                    if (value.has("block")){
                        if (value.getString("block").equalsIgnoreCase("1")){
                            _items.add(value);
                        }
                    }
                } catch (JSONException e) {
                    // Something went wrong!
                }
            }
        }

        friendBlockAdapter.setData(_items);

        setTitle("Friend block ("+_items.size()+")");
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home: {
                finish();
            }
            break;
        }
        return true;
    }
}
