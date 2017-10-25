package net.ichat.ichat.adapter;

import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.firebase.database.FirebaseDatabase;
import com.squareup.picasso.Picasso;

import net.ichat.ichat.FriendHideActivity;
import net.ichat.ichat.R;
import net.ichat.ichat.application.App;
import net.ichat.ichat.configs.Configs;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by somkid on 18/10/2017 AD.
 */

public class FriendHideAdapter extends RecyclerView.Adapter{
    private String TAG = RecentAdapter.class.getName();
    private FriendHideActivity friendHideActivity;
    private ArrayList<JSONObject> _items;
    private LayoutInflater mInflater;
    public FriendHideAdapter(FriendHideActivity friendHideActivity, ArrayList<JSONObject> _items) {
        this.friendHideActivity = friendHideActivity;
        this._items = _items;
        mInflater = LayoutInflater.from(friendHideActivity);
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.item_hide, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder h, int position) {
        final ViewHolder holder = (ViewHolder) h;

        try {
            final JSONObject val = (JSONObject) _items.get(position);
            JSONObject _val = ((App)friendHideActivity.getApplicationContext()).getProfileFriend(val.getString("friend_id"));

            if(val.has("change_friends_name")){
                holder.text_name.setText(val.getString("change_friends_name")+ " : " + val.getString("friend_id"));
            }else {

                holder.text_name.setText(_val.getString("name") + " : " + val.getString("friend_id"));
            }

            String image_uri = "";
            if (_val.has("image_url")) {
                image_uri = Configs.API_URI + _val.getString("image_url");
            }

            if (!image_uri.equalsIgnoreCase("")) {
                Picasso.with(friendHideActivity.getApplicationContext())
                        .load(image_uri)
                        .placeholder(R.drawable.ic_placeholder)
                        .into(holder.image);
            } else {
                // .load(R.drawable.placeholder)
                Picasso.with(friendHideActivity)
                        .load(R.drawable.ic_placeholder)
                        .placeholder(R.drawable.ic_placeholder)
                        .into(holder.image);
            }

            holder.btn_unhide.setTag(R.string._parameter_1, val);
            holder.btn_unhide.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    JSONObject val = (JSONObject) view.getTag(R.string._parameter_1);
                    try {
                        String path = "toonchat/" + ((App) friendHideActivity.getApplicationContext()).getUserId() + "/friends/" + val.getString("friend_id") + "/hide";

                        Map<String, Object> childUpdates = new HashMap<>();
                        childUpdates.put(path, "0");

                        FirebaseDatabase.getInstance().getReference().updateChildren(childUpdates);

                        val.put("hide", "0");
                        ((App)friendHideActivity.getApplicationContext()).updateFriendsbyFriend(val);


                        friendHideActivity.loadData();

                    }catch (Exception ex){
                        Log.e(TAG, ex.toString());
                    }
                }
            });

            holder.btn_remove.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Toast.makeText(friendHideActivity, "Remove", Toast.LENGTH_SHORT).show();
                }
            });
        }catch (Exception ex){
            Log.e(TAG, ex.toString());
        }
    }

    @Override
    public int getItemCount() {
        if (_items == null)
            return 0;
        return _items.size();
    }

    public void setData(ArrayList<JSONObject> _items) {
        this._items = _items;

        notifyDataSetChanged();
    }

    private class ViewHolder extends RecyclerView.ViewHolder {
        private String TAG = ViewHolder.class.getName();

        private ImageView image;
        private TextView text_name;
        private Button btn_unhide, btn_remove;
        public ViewHolder(View itemView) {
            super(itemView);
            image       = (ImageView)itemView.findViewById(R.id.image);
            text_name   = (TextView) itemView.findViewById(R.id.text_name);
            btn_unhide  = (Button) itemView.findViewById(R.id.btn_unhide);
            btn_remove  = (Button) itemView.findViewById(R.id.btn_remove);
        }
    }
}