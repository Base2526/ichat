package net.ichat.ichat.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.nostra13.universalimageloader.core.ImageLoader;

import net.ichat.ichat.R;
import net.ichat.ichat.application.App;
import net.ichat.ichat.configs.Configs;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by somkid on 14/10/2017 AD.
 */

public class CreateGroupAdapter extends RecyclerView.Adapter{
    private String TAG = CreateGroupAdapter.class.getName();

    private Context context;
    private ArrayList<JSONObject> _items;
    private LayoutInflater mInflater;
    private ArrayList<JSONObject> check;

    private RecyclerViewClickListener mListener;

    public interface RecyclerViewClickListener {
        void onClick(View view, ArrayList<JSONObject> check);
    }

    public CreateGroupAdapter(Context pcontext, ArrayList<JSONObject> _items, RecyclerViewClickListener listener) {
        context = pcontext;
        this._items = _items;
        mInflater = LayoutInflater.from(pcontext);

        check = new ArrayList<>();
        mListener = listener;
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.item_create_group, parent, false);
        return new CreateGroupAdapter.ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder h, int position) {
        final CreateGroupAdapter.ViewHolder holder = (CreateGroupAdapter.ViewHolder) h;

        try {
            JSONObject jsonObject = this._items.get(position);

            String friend_id = jsonObject.getString("friend_id");
            JSONObject jsonFProfile = ((App) context.getApplicationContext()).getProfileFriend(friend_id);

            holder.txt_name.setText(jsonFProfile.getString("name") + " : " + friend_id);

            ImageLoader.getInstance().displayImage("", holder.image_profile);
            if(jsonFProfile.has("image_url")){
                ImageLoader.getInstance().displayImage(Configs.API_URI + jsonFProfile.getString("image_url"), holder.image_profile);
            }

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
        private String TAG = CreateGroupAdapter.ViewHolder.class.getName();
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