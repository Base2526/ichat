package net.ichat.ichat;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;

import net.ichat.ichat.adapter.ManageMembersGroupAdapter;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Iterator;

public class ManageMembersGroupActivity extends AppCompatActivity {
    private String TAG = ManageMembersGroupActivity.class.getName();

    private RecyclerView recyclerView;

    private ManageMembersGroupAdapter manageMembersGroupAdapter;
    private ArrayList<JSONObject> _items;

    public JSONObject jsonObject;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_manage_members_group);

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        setTitle("MM Group");


        Bundle bundle = getIntent().getExtras();

        try {
            jsonObject = new JSONObject(bundle.getString("data"));

        }catch (Exception ex){
            Log.e(TAG, ex.toString());
        }

        recyclerView    = (RecyclerView) findViewById(R.id.recyclerView);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        _items = new ArrayList<JSONObject>();

        manageMembersGroupAdapter = new ManageMembersGroupAdapter(this, _items);
        recyclerView.setAdapter(manageMembersGroupAdapter);

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

                Intent intent = new Intent(this, InviteFriendsActivity.class);
                Bundle bundle = new Bundle();
                bundle.putString("data", jsonObject.toString());
                intent.putExtras(bundle);
                startActivity(intent);
            }
            break;
        }

        return  true;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_manage_members_group, menu);
        return super.onCreateOptionsMenu(menu);
    }

    private void loadData() {
        try {
            JSONObject membersObject = jsonObject.getJSONObject("members");
            Iterator<String> iter = membersObject.keys();
            while (iter.hasNext()) {
                String node_id = iter.next();
                try {
                    JSONObject val = membersObject.getJSONObject(node_id);
                    val.put("node_id", node_id);
                    _items.add(val);
                } catch (Exception ex) {
                    Log.e(TAG, ex.toString());
                }
            }
            manageMembersGroupAdapter.setData(_items);
        }catch (Exception ex){
            Log.e(TAG, ex.toString());
        }
    }
}
