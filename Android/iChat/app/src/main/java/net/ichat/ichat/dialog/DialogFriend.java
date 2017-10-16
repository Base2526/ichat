package net.ichat.ichat.dialog;

import android.app.Dialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.app.DialogFragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import net.ichat.ichat.ChangeFriendNameActivity;
import net.ichat.ichat.MainActivity;
import net.ichat.ichat.ManageGroupActivity;
import net.ichat.ichat.R;
import net.ichat.ichat.application.App;
import net.ichat.ichat.configs.Configs;
import net.ichat.ichat.utils.JsonUtils;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by somkid on 14/10/2017 AD.
 */

public class DialogFriend extends DialogFragment implements AdapterView.OnItemClickListener {
    private String TAG = DialogFriend.class.getName();

    private ArrayList<String> listitems;// = { "item01", "item02", "item03", "item04" };

    private ListView listView;

    private MainActivity mainActivity;
    private String type;
    private JSONObject data;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.dialog_friend, container, false);

        try {

            mainActivity = (MainActivity)getContext();

            Bundle mArgs = getArguments();
            type      = mArgs.getString("type");
            data      = new JSONObject(mArgs.getString("data"));

            listitems = new ArrayList<>();

            if (type.equalsIgnoreCase(Configs.GROUPS)){
                listitems.add("Manage group");
                listitems.add("Delete group");
                listitems.add("Close");
            }else {
                listitems.add("Favorite");
                listitems.add("Change friend's name");
                listitems.add("Hide");
                listitems.add("Block");
                listitems.add("Close");
            }


            listView = (ListView) rootView.findViewById(R.id.listView);

            getDialog().getWindow().requestFeature(Window.FEATURE_NO_TITLE);

             /*
            btnUTN      = (Button)rootView.findViewById(R.id.btnUTN);

            Bundle mArgs = getArguments();
            phoneNumber = mArgs.getString("phoneNumber");

            if(mArgs.containsKey("email")){
                email = mArgs.getString("email");
            }
            if (mArgs.containsKey("fid")){
                fid = mArgs.getString("fid");
            }

            btnCancel.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    dismiss();
                }
            });

            btnUTN.setTag(R.string._parameter_1, phoneNumber);
            btnUTN.setTag(R.string._parameter_2, email);
            btnUTN.setTag(R.string._parameter_3, fid);
            btnUTN.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    // new ChangeTelThread(welcomeActivity, phoneNumber).start();


                    Intent intent = new Intent(getContext(), Register.class);
                    Bundle bundle = new Bundle();
                    bundle.putString("phoneNumber", (String)view.getTag(R.string._parameter_1));
                    bundle.putString("email", (String)view.getTag(R.string._parameter_2));
                    bundle.putString("fid", (String)view.getTag(R.string._parameter_3));

                    intent.putExtras(bundle);

                    startActivity(intent);

                    dismiss();
                }
            });
            */

             /*
            imageLoader.displayImage(uri_image, imageV);

            btnAction.setText(textButton);
            btnAction.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {

                    // String url = "http://www.example.com";
                    Intent i = new Intent(Intent.ACTION_VIEW);
                    i.setData(Uri.parse(uri_action));
                    startActivity(i);
                }
            });


            imgClose.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    // new ChangeTelThread(welcomeActivity, phoneNumber).start();

                    try {
                        if (checkBox.isChecked()) {
                            SharedPreferences mPrefs = getActivity().getSharedPreferences(Configs.MY_PREFS, MODE_PRIVATE);
                            String diaryPopup = mPrefs.getString(Configs.DIARY_POPUP, "");

                            if (!diaryPopup.equalsIgnoreCase("")) {

                                JSONObject obj = new JSONObject(diaryPopup);

                                JSONObject objNew = new JSONObject();
                                objNew.put("current_date", obj.getString("current_date"));
                                objNew.put("data", obj.getString("data"));
                                objNew.put("flag", true);

                                SharedPreferences.Editor editor = getActivity().getSharedPreferences(Configs.MY_PREFS, MODE_PRIVATE).edit();
                                editor.putString(Configs.DIARY_POPUP, objNew.toString());
                                editor.commit();
                            }
                        }

                        dismiss();
                    }catch (Exception ex){
                        Toast.makeText(getActivity(), ex.toString(), Toast.LENGTH_SHORT).show();
                    }
                }
            });
            */

        }catch (Exception ex){
            Log.e(TAG, ex.toString());
        }
        return rootView;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_list_item_1, listitems);

        listView.setAdapter(adapter);
        listView.setOnItemClickListener(this);
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

        if (type.equalsIgnoreCase(Configs.GROUPS)){

            switch (position) {
                case 0: {
                    // Manage group
                    Intent intent = new Intent(mainActivity, ManageGroupActivity.class);
                    Bundle bundle = new Bundle();
                    bundle.putString("data", data.toString());

                    intent.putExtras(bundle);

                    mainActivity.startActivity(intent);
                }
                break;

                case 1: {
                    // Delete group
                    try {
                        ((App) mainActivity.getApplication()).deleteGroup(data.getString("group_id"));
                    }catch (Exception ex){
                        Log.e(TAG, ex.toString());
                    }
                }
                break;
            }
        }else {

            switch (position) {
                case 0: {
                    // Favorite

                    try {

                        final FirebaseDatabase database = FirebaseDatabase.getInstance();
                        DatabaseReference myRef = database.getReference("toonchat/" + ((App) mainActivity.getApplication()).getUserId() + "/friends/" + data.getString("friend_id") + "/favorite");

                        myRef.addListenerForSingleValueEvent(new ValueEventListener() {
                            @Override
                            public void onDataChange(DataSnapshot snapshot) {

                                try {
                                    Object key = snapshot.getKey();
                                    String value = (String) snapshot.getValue();

                                    String path = "toonchat/" + ((App) mainActivity.getApplication()).getUserId() + "/friends/" + data.getString("friend_id") + "/favorite";

                                    if (value == null) {
                                        Map<String, Object> childUpdates = new HashMap<>();
                                        childUpdates.put(path, "1");

                                        FirebaseDatabase.getInstance().getReference().updateChildren(childUpdates);
                                    } else if (value.equalsIgnoreCase("1")) {
                                        Map<String, Object> childUpdates = new HashMap<>();
                                        childUpdates.put(path, "0");

                                        FirebaseDatabase.getInstance().getReference().updateChildren(childUpdates);
                                    } else {
                                        Map<String, Object> childUpdates = new HashMap<>();
                                        childUpdates.put(path, "1");

                                        FirebaseDatabase.getInstance().getReference().updateChildren(childUpdates);
                                    }

                                    Intent i = new Intent("Contacts_Reload");
                                    Bundle bundle = new Bundle();

                                    i.putExtras(bundle);
                                    mainActivity.sendBroadcast(i);
                                } catch (Exception ex) {
                                    Log.e(TAG, ex.toString());
                                }
                            }

                            @Override
                            public void onCancelled(DatabaseError databaseError) {
                            }
                        });
                    }catch (Exception ex){
                        Log.e(TAG, ex.toString());
                    }

                }
                break;

                case 1: {
                    try {
                        // Change friend's name
                        Intent intent = new Intent(mainActivity, ChangeFriendNameActivity.class);

                        Bundle bundle = new Bundle();
                        bundle.putString("friend_id", data.getString("friend_id"));
                        intent.putExtras(bundle);

                        mainActivity.startActivityForResult(intent, mainActivity.CHANGE_FRIEND_NAME);
                    }catch (Exception ex){
                        Log.e(TAG, ex.toString());
                    }
                }
                break;

                case 2: {
                    // Hide

                    Toast.makeText(mainActivity, "Hide", Toast.LENGTH_SHORT).show();
                }
                break;

                case 3: {
                    // Block
                    Toast.makeText(mainActivity, "Block", Toast.LENGTH_SHORT).show();
                }
                break;

                case 4: {
                    // Close
                    Toast.makeText(mainActivity, "Close", Toast.LENGTH_SHORT).show();
                }
                break;
            }
        }

        dismiss();
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        Dialog dialog = super.onCreateDialog(savedInstanceState);

        // request a window without the title
        dialog.getWindow().requestFeature(Window.FEATURE_NO_TITLE);
        return dialog;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
    }
}