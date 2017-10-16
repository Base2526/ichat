package net.ichat.ichat;

import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;

import com.nostra13.universalimageloader.core.ImageLoader;

import net.ichat.ichat.configs.Configs;
import net.ichat.ichat.handler.UpdateGroupHandler;
import net.ichat.ichat.thread.UpdateGroupThread;
import net.ichat.ichat.thread.UpdateMyProfileThread;
import net.ichat.ichat.thread.UpdatePictureMyProfileThread;
import net.ichat.ichat.utils.imagepicker.ImagePicker;

import org.json.JSONObject;

public class ManageGroupActivity extends AppCompatActivity {
    private String TAG = ManageGroupActivity.class.getName();
    public final int DIALOG_WAIT = 0;
    private ProgressDialog progDialog;


    private ImageView image_profile_group;
    private EditText edt_name_group;

    private JSONObject jsonObject;

    public UpdateGroupHandler updateGroupHandler = new UpdateGroupHandler(this);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_manage_group);
        setTitle("Manage Group");
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        image_profile_group = (ImageView)findViewById(R.id.image_profile_group);
        edt_name_group = (EditText) findViewById(R.id.edt_name_group);

        image_profile_group.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ImagePicker.pickImage(ManageGroupActivity.this, "Select your image:");
            }
        });

        Bundle bundle = getIntent().getExtras();

        try {
            jsonObject = new JSONObject(bundle.getString("data"));

            edt_name_group.setText(jsonObject.getString("name"));
            ImageLoader.getInstance().displayImage("", image_profile_group);
            if(jsonObject.has("image_url")){
                ImageLoader.getInstance().displayImage(Configs.API_URI + jsonObject.getString("image_url"), image_profile_group);
            }
        }catch (Exception ex){
            Log.e(TAG, ex.toString());
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home: {
                finish();
            }

            break;
            case R.id.item_save: {
                // startActivity(new Intent(this, CreateGroupActivity.class));
                try {

                    String name_group = edt_name_group.getText().toString().trim();
                    Bitmap bitmap = ((BitmapDrawable) image_profile_group.getDrawable()).getBitmap();

                    if (name_group.equalsIgnoreCase("") || name_group.length() == 0) {
                        return false;
                    }

                    // [uThread start:[self.group objectForKey:@"group_id"] :self.txtGroupName.text : [imageV image]];

                    showDialog(DIALOG_WAIT);
                    new UpdateGroupThread(this, jsonObject.getString("group_id"), name_group, bitmap).start();
                }catch (Exception ex){
                    Log.e(TAG, ex.toString());
                }

            }
            break;

        }
        return  true;
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
        getMenuInflater().inflate(R.menu.menu_manage_group, menu);
        return super.onCreateOptionsMenu(menu);
    }


    public void onMangeMembers(View v) {

        Intent intent = new Intent(this, ManageMembersGroupActivity.class);

        Bundle bundle = new Bundle();
        bundle.putString("data", jsonObject.toString());

        intent.putExtras(bundle);
        startActivity(intent);
    }

    public void onInviteMembers(View v) {
        Log.e(TAG, "");
    }

    public void onDeleteGroup(View v) {
        Log.e(TAG, "");
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        // TODO do something with the bitmap
        try{
            if (requestCode == ImagePicker.PICK_IMAGE_REQUEST_CODE) {
                Bitmap bitmap = ImagePicker.getImageFromResult(this, requestCode, resultCode, data);
                if (bitmap != null) {

                    // new UpdatePictureMyProfileThread(ProfileActivity.this, bitmap).start();

                    image_profile_group.setImageBitmap(bitmap);
                }
            }
        }catch (Exception ex){
            Log.e(TAG, ex.toString());
        }
    }
}
