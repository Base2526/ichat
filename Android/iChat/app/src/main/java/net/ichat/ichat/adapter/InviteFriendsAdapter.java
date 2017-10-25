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

import com.squareup.picasso.Picasso;

import net.ichat.ichat.R;
import net.ichat.ichat.application.App;
import net.ichat.ichat.configs.Configs;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by somkid on 15/10/2017 AD.
 */

public class InviteFriendsAdapter extends RecyclerView.Adapter{
    private String TAG = InviteFriendsAdapter.class.getName();

    private Context context;
    private ArrayList<JSONObject> _items;
    private LayoutInflater mInflater;
    private ArrayList<JSONObject> check;

    private CreateGroupAdapter.RecyclerViewClickListener mListener;

    public interface RecyclerViewClickListener {
        void onClick(View view, ArrayList<JSONObject> check);
    }

    public InviteFriendsAdapter(Context pcontext, ArrayList<JSONObject> _items, CreateGroupAdapter.RecyclerViewClickListener listener) {
        context = pcontext;
        this._items = _items;
        mInflater = LayoutInflater.from(pcontext);

        check = new ArrayList<>();
        mListener = listener;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.item_create_group, parent, false);
        return new InviteFriendsAdapter.ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder h, int position) {
        final InviteFriendsAdapter.ViewHolder holder = (InviteFriendsAdapter.ViewHolder) h;

        try {
            JSONObject jsonObject = this._items.get(position);

            String friend_id = jsonObject.getString("friend_id");
            JSONObject jsonFProfile = ((App) context.getApplicationContext()).getProfileFriend(friend_id);

            holder.txt_name.setText(jsonFProfile.getString("name") + " : " + friend_id);

//            ImageLoader.getInstance().displayImage("", holder.image_profile);
//            if(jsonFProfile.has("image_url")){
//                ImageLoader.getInstance().displayImage(Configs.API_URI + jsonFProfile.getString("image_url"), holder.image_profile);
//            }

            String image_uri = "";
            if(jsonFProfile.has("image_url")){
                image_uri = Configs.API_URI + jsonFProfile.getString("image_url");
            }
            Picasso.with(context)
                    .load(image_uri)
                    .placeholder(R.drawable.ic_placeholder)
                    .into(holder.image_profile);

            // {"change_friends_name":"y0u","chat_id":"zSlfdf6d9gBNAjhcTibm","status":"friend","favorite":"1","create":1505280310,"friend_id":"968"}
            if (jsonObject.has("change_friends_name")) {
                holder.txt_name.setText(jsonObject.getString("change_friends_name")  + " : " + friend_id);
            }

            if (check.contains(jsonObject)){
                holder.checkBox.setChecked(true);
            }else {
                holder.checkBox.setChecked(false);
            }

            //in some cases, it will prevent unwanted situations
            holder.checkBox.setOnCheckedChangeListener(null);
            holder.checkBox.setTag(jsonObject);
            holder.checkBox.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    JSONObject position = (JSONObject) v.getTag();

                    if (check.contains(position)){
                        check.remove(position);
                    }else {
                        check.add(position);
                    }

                    /**
                     * เราจะได้ค่า check ไปใช้งาน
                     * */
                    mListener.onClick(v, check);
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
        private String TAG = InviteFriendsAdapter.ViewHolder.class.getName();
        private ImageView image_profile;
        private TextView txt_name;
        private CheckBox checkBox;

        public ViewHolder(View itemView) {
            super(itemView);
            image_profile    = (ImageView) itemView.findViewById(R.id.image_profile);
            txt_name   = (TextView) itemView.findViewById(R.id.txt_name);
            checkBox   = (CheckBox) itemView.findViewById(R.id.checkBox);
        }
    }
}