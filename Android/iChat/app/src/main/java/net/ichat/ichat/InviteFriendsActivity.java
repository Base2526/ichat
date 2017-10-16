package net.ichat.ichat;

import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Toast;

import net.ichat.ichat.adapter.CreateGroupAdapter;
import net.ichat.ichat.adapter.InviteFriendsAdapter;
import net.ichat.ichat.application.App;
import net.ichat.ichat.handler.GroupInviteNewMembersHandler;
import net.ichat.ichat.thread.GroupInviteNewMembersThread;
import net.ichat.ichat.utils.imagepicker.ImagePicker;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Iterator;

public class InviteFriendsActivity extends AppCompatActivity {
    private String TAG = ManageMembersGroupActivity.class.getName();

    public final int DIALOG_WAIT = 0;
    private ProgressDialog progDialog;
    public JSONObject jsonObject;

    private RecyclerView recyclerView;

    private InviteFriendsAdapter inviteFriendsAdapter;
    private ArrayList<JSONObject> _items;

    // เก็บค่า ที่เราเลือก
    public ArrayList<JSONObject> _check;

    public GroupInviteNewMembersHandler groupInviteNewMembersHandler = new GroupInviteNewMembersHandler(this);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_invite_friends);

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        setTitle("Invite Friends");

        Bundle bundle = getIntent().getExtras();

        try {
            jsonObject = new JSONObject(bundle.getString("data"));
        }catch (Exception ex){
            Log.e(TAG, ex.toString());
        }

        recyclerView    = (RecyclerView) findViewById(R.id.recyclerView);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        _items = new ArrayList<JSONObject>();
        _check = new ArrayList<>();

        CreateGroupAdapter.RecyclerViewClickListener mListener = new CreateGroupAdapter.RecyclerViewClickListener() {
            @Override
            public void onClick(View view, ArrayList<JSONObject> check) {
                _check =check;


                setTitle("Create Group (" + _check.size() + ")");
                // Check if no view has focus:
                View v = getCurrentFocus();
                if (v != null) {
                    InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
                    imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
                }
            }
        };

        inviteFriendsAdapter = new InviteFriendsAdapter(this, _items, mListener);
        recyclerView.setAdapter(inviteFriendsAdapter);

        loadData();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home: {
                finish();
            }
            break;
            case R.id.item_invite: {
                // [groupINMT start:[self.group objectForKey:@"group_id"] : members];

                /*

                [dataToSend appendFormat:@"uid=%@&group_id=%@&", [[Configs sharedInstance] getUIDU], group_id];

    for (NSString *friend_id in members) {
        // [dataToSend appendFormat:@"field[]=%d&",[restID.row]];

        NSLog(@"%@", friend_id);
        [dataToSend appendFormat:@"members[]=%@&", friend_id];
    }
                 */

                try {
                    if (_check.size() < 1) {
                        Toast.makeText(this, "empty", Toast.LENGTH_SHORT).show();
                        break;
                    }

                    String[] mStringArray = new String[_check.size()];
                    for (int i = 0; i < _check.size(); i++) {
                        // {"change_friends_name":"y0u","chat_id":"zSlfdf6d9gBNAjhcTibm","status":"friend","favorite":"1","create":1505280310,"friend_id":"968"}
                        try {
                            JSONObject jsonObject = _check.get(i);

                            mStringArray[i] = jsonObject.getString("friend_id");
                        } catch (Exception ex) {
                            Log.e(TAG, ex.toString());
                        }
                    }

                    showDialog(DIALOG_WAIT);
                    new GroupInviteNewMembersThread(this, jsonObject.getString("group_id"), mStringArray).start();

                }catch (Exception ex){
                    Log.e(TAG, ex.toString());
                }
            }
            break;
        }
        return true;
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


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_invite_friends, menu);
        return super.onCreateOptionsMenu(menu);
    }

    private void loadData() {
        JSONObject jObject = ((App)getApplication()).getFriends();

        try {
            JSONObject jsonMembers = jsonObject.getJSONObject("members");

            Iterator<String> iter = jObject.keys();
            while (iter.hasNext()) {
                String friend_id = iter.next();

                JSONObject val = jObject.getJSONObject(friend_id);
                val.put("friend_id", friend_id);

                // เราจะไม่เอา friend ที่เป็น members
                Boolean flag = false;
                Iterator<?> keys = jsonMembers.keys();
                while(keys.hasNext() ) {
                    String key = (String)keys.next();
                    JSONObject mm = jsonMembers.getJSONObject(key);

                    if(mm.getString("friend_id").equalsIgnoreCase(friend_id)){
                        flag = true;
                        break;
                    }
                }

                if (!flag)
                    _items.add(val);
            }
        }catch (Exception ex){
            Log.e(TAG, ex.toString());
        }
        inviteFriendsAdapter.setData(_items);
    }
}
