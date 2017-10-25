package net.ichat.ichat;

import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;

import com.squareup.picasso.Picasso;

import net.ichat.ichat.application.App;
import net.ichat.ichat.configs.Configs;
import net.ichat.ichat.handler.UpdateMyProfileHandler;
import net.ichat.ichat.handler.UpdatePictureMyProfileHandler;
import net.ichat.ichat.thread.UpdateMyProfileThread;
import net.ichat.ichat.thread.UpdatePictureMyProfileThread;
import net.ichat.ichat.utils.imagepicker.ImagePicker;

import org.json.JSONObject;

public class ProfileActivity extends AppCompatActivity {
    private String TAG = ProfileActivity.class.getName();

    public final int DIALOG_WAIT = 0;
    private ProgressDialog progDialog;

    private ImageView image_profile;
    private EditText edt_name, edt_email, edt_status_message;
    private SharedPreferences appSharedPrefs;

    public UpdateMyProfileHandler updateMyProfileHandler = new UpdateMyProfileHandler(this);
    public UpdatePictureMyProfileHandler updatePictureMyProfileHandler = new UpdatePictureMyProfileHandler(this);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile);

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        appSharedPrefs  = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());

        image_profile   = (ImageView)findViewById(R.id.image_profile);
        edt_name       = (EditText) findViewById(R.id.edt_name);
        edt_email      = (EditText)findViewById(R.id.edt_email);
        edt_status_message      = (EditText)findViewById(R.id.edt_status_message);

        image_profile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ImagePicker.pickImage(ProfileActivity.this, "Select your image:");
            }
        });

        loadData();
    }

    private void loadData() {
        try {
            // JSONObject jsonProfiles = new JSONObject(appSharedPrefs.getString(Configs.PROFILES, ""));

            JSONObject jsonProfiles =((App)getApplicationContext()).getMyProfile();

            edt_name.setText(jsonProfiles.getString("name"));
            edt_email.setText(jsonProfiles.getString("mail"));

//            if(jsonProfiles.has("image_url")){
//                ImageLoader.getInstance().displayImage( Configs.API_URI +  jsonProfiles.getString("image_url"), image_profile);
//            }

//            ImageLoader.getInstance().displayImage("", image_profile);
//            if(jsonProfiles.has("image_url")){
//                ImageLoader.getInstance().displayImage(Configs.API_URI + jsonProfiles.getString("image_url"), image_profile);
//            }

            String image_uri = "";
            if(jsonProfiles.has("image_url")){
                image_uri = Configs.API_URI + jsonProfiles.getString("image_url");
            }
            Picasso.with(this)
                    .load(image_uri)
                    .placeholder(R.drawable.ic_placeholder)
                    .into(image_profile);

            edt_status_message.setText("");
            if(jsonProfiles.has("status_message")){
                edt_status_message.setText(jsonProfiles.getString("status_message"));
            }
        }catch (Exception ex){
            Log.e(TAG, ex.toString());
        }
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
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home: {
                finish();
            }
            break;

            case R.id.item_save: {
                showDialog(DIALOG_WAIT);
                new UpdateMyProfileThread(this, edt_name.getText().toString().trim(), edt_status_message.getText().toString().trim()).start();
            }
            break;
        }
        return  true;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_profile, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        // TODO do something with the bitmap
        try{
           if (requestCode == ImagePicker.PICK_IMAGE_REQUEST_CODE) {
               Bitmap bitmap = ImagePicker.getImageFromResult(this, requestCode, resultCode, data);
               if (bitmap != null) {

                   new UpdatePictureMyProfileThread(ProfileActivity.this, bitmap).start();

                   image_profile.setImageBitmap(bitmap);
               }
           }
        }catch (Exception ex){
            Log.e(TAG, ex.toString());
        }
    }
}
