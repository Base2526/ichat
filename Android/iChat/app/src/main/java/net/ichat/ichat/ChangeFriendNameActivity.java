package net.ichat.ichat;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import net.ichat.ichat.application.App;
import net.ichat.ichat.chatview.SingleViewActivity;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class ChangeFriendNameActivity extends AppCompatActivity {
    private String TAG = ChangeFriendNameActivity.class.getName();

    private EditText edt_name;
    private Button btn_save;

    private String friend_id;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_change_friend_name);

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        setTitle("Change Friend Name");

        edt_name = (EditText)findViewById(R.id.edt_name);

        Bundle bundle = getIntent().getExtras();
        friend_id = bundle.getString("friend_id");

        try {

            JSONObject profileF = ((App) getApplication()).getFriends();

            Iterator<String> iter = profileF.keys();
            while (iter.hasNext()) {
                String key = iter.next();
                if (key.equalsIgnoreCase(friend_id)){
                    JSONObject js = profileF.getJSONObject(key);
                    if (js.has("change_friends_name")) {
                        edt_name.setText(js.getString("change_friends_name"));
                    }
                    break;
                }
            }
//

            ((Button) findViewById(R.id.btn_save)).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {

                    final FirebaseDatabase database = FirebaseDatabase.getInstance();
                    DatabaseReference myRef = database.getReference("toonchat/" + ((App) getApplication()).getUserId() + "/friends/");

                    Map<String, Object> childUpdates = new HashMap<>();
                    childUpdates.put("toonchat/" + ((App) getApplication()).getUserId() + "/friends/" + friend_id + "/change_friends_name/", edt_name.getText().toString().trim());

                    FirebaseDatabase.getInstance().getReference().updateChildren(childUpdates);

                    finish();
                }
            });
        }catch (Exception ex){
            Log.e(TAG, ex.toString());
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if(id == android.R.id.home){
            finish();
        }
        return super.onOptionsItemSelected(item);
    }
}
