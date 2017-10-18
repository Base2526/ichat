package net.ichat.ichat.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.TextView;

import com.chauthai.swipereveallayout.SwipeRevealLayout;
import com.chauthai.swipereveallayout.ViewBinderHelper;
import com.nostra13.universalimageloader.core.ImageLoader;

import net.ichat.ichat.ManageMembersGroupActivity;
import net.ichat.ichat.R;
import net.ichat.ichat.application.App;
import net.ichat.ichat.configs.Configs;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by somkid on 15/10/2017 AD.
 */

public class ManageMembersGroupAdapter extends RecyclerView.Adapter{
    private String TAG = ManageMembersGroupAdapter.class.getName();

    private ManageMembersGroupActivity manageMembersGroupActivity;
    private ArrayList<JSONObject> _items;
    private LayoutInflater mInflater;

    private ViewBinderHelper binderHelper;

    public ManageMembersGroupAdapter(ManageMembersGroupActivity manageMembersGroupActivity, ArrayList<JSONObject> _items) {
        this.manageMembersGroupActivity = manageMembersGroupActivity;
        this._items = _items;
        mInflater = LayoutInflater.from(manageMembersGroupActivity);

        binderHelper = new ViewBinderHelper();
        // uncomment if you want to open only one row at a time
        binderHelper.setOpenOnlyOne(true);
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.item_manage_members_group, parent, false);
        return new ManageMembersGroupAdapter.ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder h, int position) {
        final ManageMembersGroupAdapter.ViewHolder holder = (ManageMembersGroupAdapter.ViewHolder) h;

        try {

            binderHelper.bind(holder.swipe_layout, Integer.toString(position));

            JSONObject jsonObject = this._items.get(position);

            String friend_id = jsonObject.getString("friend_id");
            JSONObject jsonFProfile = ((App) manageMembersGroupActivity.getApplicationContext()).getProfileFriend(friend_id);


            holder.txt_name.setText(jsonFProfile.getString("name") + " : " + friend_id);

            ImageLoader.getInstance().displayImage("", holder.image_profile);
            if(jsonFProfile.has("image_url")){
                ImageLoader.getInstance().displayImage(Configs.API_URI + jsonFProfile.getString("image_url"), holder.image_profile);
            }

            // {"change_friends_name":"y0u","chat_id":"zSlfdf6d9gBNAjhcTibm","status":"friend","favorite":"1","create":1505280310,"friend_id":"968"}
            if (jsonObject.has("change_friends_name")) {
                holder.txt_name.setText(jsonObject.getString("change_friends_name")  + " : " + friend_id);
            }

            holder.txt_delete.setTag(R.string._parameter_1, manageMembersGroupActivity.jsonObject.getString("group_id"));
            holder.txt_delete.setTag(R.string._parameter_2, jsonObject.getString("node_id"));
            holder.txt_delete.setTag(R.string._parameter_3, position);
            holder.txt_delete.setTag(R.string._parameter_4, holder.swipe_layout);
            holder.txt_delete.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {

                    String group_id = (String)view.getTag(R.string._parameter_1);
                    String node_id = (String)view.getTag(R.string._parameter_2);
                    int position = (int)view.getTag(R.string._parameter_3);

                    SwipeRevealLayout swipeRevealLayout = (SwipeRevealLayout)view.getTag(R.string._parameter_4);
                    swipeRevealLayout.close(true);

                    notifyItemRemoved(position);

                    ((App)manageMembersGroupActivity.getApplication()).deleteMemberForGroup(group_id, node_id);
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
        private String TAG = ManageMembersGroupAdapter.ViewHolder.class.getName();

        private SwipeRevealLayout swipe_layout;
        private ImageView image_profile;
        private TextView txt_name;

        private TextView txt_delete;

        public ViewHolder(View itemView) {
            super(itemView);
            swipe_layout     = (SwipeRevealLayout) itemView.findViewById(R.id.swipe_layout);
            image_profile    = (ImageView) itemView.findViewById(R.id.image_profile);
            txt_name   = (TextView) itemView.findViewById(R.id.txt_name);
            txt_delete   = (TextView) itemView.findViewById(R.id.txt_delete);
        }
    }
}