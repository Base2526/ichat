package net.ichat.ichat;

import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

import net.ichat.ichat.adapter.CreateGroupAdapter;
import net.ichat.ichat.adapter.RecentAdapter;
import net.ichat.ichat.application.App;
import net.ichat.ichat.handler.CreateGroupHandler;
import net.ichat.ichat.thread.CreateGroupThread;
import net.ichat.ichat.thread.UpdateMyProfileThread;
import net.ichat.ichat.thread.UpdatePictureMyProfileThread;
import net.ichat.ichat.utils.imagepicker.ImagePicker;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Iterator;


public class CreateGroupActivity extends AppCompatActivity {
    private String TAG = CreateGroupActivity.class.getName();

    public final int DIALOG_WAIT = 0;
    private ProgressDialog progDialog;

    private ImageView image_profile;
    private EditText edt_name_group;
    private RecyclerView recyclerView;

    private CreateGroupAdapter createGroupAdapter;
    private ArrayList<JSONObject> _items;

    // เก็บค่า ที่เราเลือก
    public ArrayList<JSONObject> _check;

    public CreateGroupHandler createGroupHandler = new CreateGroupHandler(this);
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_group);

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        setTitle("Create Group");

        image_profile   = (ImageView)findViewById(R.id.image_profile);

        edt_name_group  = (EditText)findViewById(R.id.edt_name_group);
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

        createGroupAdapter = new CreateGroupAdapter(this, _items, mListener);
        recyclerView.setAdapter(createGroupAdapter);

        image_profile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ImagePicker.pickImage(CreateGroupActivity.this, "Select your image:");
            }
        });

        loadData();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home: {
                finish();
            }
            break;

            case R.id.item_save: {


                String name_group = edt_name_group.getText().toString().trim();
                Bitmap bitmap = ((BitmapDrawable)image_profile.getDrawable()).getBitmap();

                if (name_group.equalsIgnoreCase("") || name_group.length() == 0 || _check.size() == 0){
                    return  false;
                }

                String[] mStringArray = new String[_check.size()];
                for(int i = 0; i < _check.size() ; i++){
                    // {"change_friends_name":"y0u","chat_id":"zSlfdf6d9gBNAjhcTibm","status":"friend","favorite":"1","create":1505280310,"friend_id":"968"}
                    try {
                        JSONObject jsonObject = _check.get(i);

                        mStringArray[i] = jsonObject.getString("friend_id");
                    }catch (Exception ex){
                        Log.e(TAG, ex.toString());
                    }
                }

                showDialog(DIALOG_WAIT);
                new CreateGroupThread(CreateGroupActivity.this, bitmap, edt_name_group.getText().toString(), mStringArray).start();
            }
            break;
        }
        return  true;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_create_group, menu);
        return super.onCreateOptionsMenu(menu);
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
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        // TODO do something with the bitmap
        try{
            if (requestCode == ImagePicker.PICK_IMAGE_REQUEST_CODE) {
                Bitmap bitmap = ImagePicker.getImageFromResult(this, requestCode, resultCode, data);
                if (bitmap != null) {

                    // new UpdatePictureMyProfileThread(CreateGroupActivity.this, bitmap).start();

                    image_profile.setImageBitmap(bitmap);
                }
            }
        }catch (Exception ex){
            Log.e(TAG, ex.toString());
        }
    }

    private void loadData() {
        JSONObject jsonObject = ((App)getApplication()).getFriends();
        Iterator<String> iter = jsonObject.keys();
        while (iter.hasNext()) {
            String friend_id = iter.next();
            try {
                JSONObject val = jsonObject.getJSONObject(friend_id);
                val.put("friend_id", friend_id);
                _items.add(val);
            }catch (Exception ex){
                Log.e(TAG, ex.toString());
            }
        }
        createGroupAdapter.setData(_items);
    }
}
