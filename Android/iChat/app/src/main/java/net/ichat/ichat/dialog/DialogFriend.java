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

    private ArrayList<String> listitems;
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
                String favorite = "0";
                if (data.has("favorite")){
                    favorite = data.getString("favorite");
                }

                listitems.add("Favorite > " + favorite);
                listitems.add("Change friend's name");
                listitems.add("Hide");
                listitems.add("Block");
                listitems.add("Close");
            }
            listView = (ListView) rootView.findViewById(R.id.listView);
            getDialog().getWindow().requestFeature(Window.FEATURE_NO_TITLE);
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

                                        data.put("favorite", "1");
                                    } else if (value.equalsIgnoreCase("1")) {
                                        Map<String, Object> childUpdates = new HashMap<>();
                                        childUpdates.put(path, "0");

                                        FirebaseDatabase.getInstance().getReference().updateChildren(childUpdates);

                                        data.put("favorite", "0");
                                    } else {
                                        Map<String, Object> childUpdates = new HashMap<>();
                                        childUpdates.put(path, "1");

                                        FirebaseDatabase.getInstance().getReference().updateChildren(childUpdates);

                                        data.put("favorite", "1");
                                    }
                                    ((App)mainActivity.getApplication()).updateFriendsbyFriend(data);

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
                        bundle.putString("data", data.toString());
                        intent.putExtras(bundle);

                        mainActivity.startActivity(intent);
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