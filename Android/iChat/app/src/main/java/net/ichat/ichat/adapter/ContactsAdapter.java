package net.ichat.ichat.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.afollestad.sectionedrecyclerview.SectionedRecyclerViewAdapter;
import com.afollestad.sectionedrecyclerview.SectionedViewHolder;
import com.chauthai.swipereveallayout.SwipeRevealLayout;
import com.chauthai.swipereveallayout.ViewBinderHelper;
import com.nostra13.universalimageloader.core.ImageLoader;

import net.ichat.ichat.ContactsActivity;
import net.ichat.ichat.ProfileActivity;
import net.ichat.ichat.R;
import net.ichat.ichat.application.App;
import net.ichat.ichat.chatview.ChatView;
import net.ichat.ichat.configs.Configs;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/** @author Aidan Follestad (afollestad) */
@SuppressLint("DefaultLocale")
public class ContactsAdapter extends SectionedRecyclerViewAdapter<ContactsAdapter.MainVH> {
    private String TAG = ContactsAdapter.class.getName();

    private ContactsActivity contactsActivity;

    private Map<Integer, ArrayList<JSONObject>> data = new HashMap<Integer, ArrayList<JSONObject>>();

    private final ViewBinderHelper binderHelper;

    public ContactsAdapter(ContactsActivity contactsActivity) {
        this.contactsActivity = contactsActivity;

        binderHelper = new ViewBinderHelper();
        // uncomment if you want to open only one row at a time
        binderHelper.setOpenOnlyOne(true);
    }

    public void setData(Map<Integer, ArrayList<JSONObject>> data){
        this.data = data;

        notifyDataSetChanged();
    }

    @Override
    public int getSectionCount() {
    /*
    * จำนวน section ทั้งหมด
    * */
        int iii = data.size();
        Log.e(TAG, "");

        return data.size();
    }

    @Override
    public int getItemCount(int section) {
    /*
    * จำนวน item ของแต่ละ section
    * */
//    switch (section) {
//      case 0:
//        return 3;
//      case 1:
//        return 3;
//      case 2:
//        return 3;
//      default:
//        return 6;
//    }

        Iterator myVeryOwnIterator = data.keySet().iterator();
        while(myVeryOwnIterator.hasNext()) {
            Integer key=(Integer)myVeryOwnIterator.next();
            if (section == key) {
                ArrayList<JSONObject> value = (ArrayList<JSONObject>) data.get(key);
                // Toast.makeText(ctx, "Key: "+key+" Value: "+value, Toast.LENGTH_LONG).show();

                return value.size();
            }
        }

        return 0;
    }

    @Override
    public void onBindHeaderViewHolder(MainVH holder, int section, boolean expanded) {

        switch (section){
            case 0: {

                try {
                    Iterator myVeryOwnIterator = data.keySet().iterator();
                    while (myVeryOwnIterator.hasNext()) {
                        Integer key = (Integer) myVeryOwnIterator.next();
                        if (section == key) {
                            ArrayList<JSONObject> value = (ArrayList<JSONObject>) data.get(key);
                            // Toast.makeText(ctx, "Key: "+key+" Value: "+value, Toast.LENGTH_LONG).show();

                            holder.title.setText(value.get(0).getString("title_section"));
                            holder.caret.setImageResource(0);
                            break;
                        }
                    }
                }catch (Exception ex){
                    Log.e(TAG, ex.toString());
                }

            }
            break;

            default: {
                holder.caret.setImageResource(expanded ? R.drawable.ic_collapse : R.drawable.ic_expand);

                // holder.itemView.setEnabled(false);

                try {
                    Iterator myVeryOwnIterator = data.keySet().iterator();
                    while (myVeryOwnIterator.hasNext()) {
                        Integer key = (Integer) myVeryOwnIterator.next();
                        if (section == key) {
                            ArrayList<JSONObject> value = (ArrayList<JSONObject>) data.get(key);
                            // Toast.makeText(ctx, "Key: "+key+" Value: "+value, Toast.LENGTH_LONG).show();

                            // emotionName
                            // holder.title.setText(value.get(relativePosition).getString("path"));

                            // ImageLoader imageLoader = ImageLoader.getInstance();
                            // imageLoader.displayImage(value.get(relativePosition).getString("path"), holder.image);

                            // holder.title.setText(value.get(relativePosition));
                            holder.title.setText(value.get(0).getString("title_section") +" ("+ value.size() +")");
                            break;
                        }
                    }
                }catch (Exception ex){
                    Log.e("", ex.toString());
                }
            }
            break;
        }
    }

    @Override
    public void onBindFooterViewHolder(MainVH holder, int section) {
        holder.title.setText(String.format("Section footer %d", section));
    }

    @Override
    public void onBindViewHolder(MainVH holder, int section, int relativePosition, int absolutePosition) {
        try {
            switch (section) {
                case 0: {
                    holder.main_content_profile.setVisibility(View.VISIBLE);
                    holder.main_content_group.setVisibility(View.GONE);
                    holder.main_content_friend.setVisibility(View.GONE);

                    JSONObject jsonProfiles =((App)contactsActivity.getApplicationContext()).getMyProfile();

                    holder.text_name_content_profile.setText(jsonProfiles.getString("name"));
                    holder.text_email_content_profile.setText(jsonProfiles.getString("mail"));

                    holder.text_status_message_content_profile.setText("");
                    if(jsonProfiles.has("status_message")){
                        holder.text_status_message_content_profile.setText(jsonProfiles.getString("status_message"));
                    }

                    ImageLoader.getInstance().displayImage("", holder.image_content_profile);
                    if(jsonProfiles.has("image_url")){
                        ImageLoader.getInstance().displayImage(Configs.API_URI + jsonProfiles.getString("image_url"), holder.image_content_profile);
                    }

                    holder.main_content_profile.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            // Toast.makeText(context, "mainLayout : Profile", Toast.LENGTH_LONG).show();
                            contactsActivity.startActivity(new Intent(contactsActivity, ProfileActivity.class));
                        }
                    });
                }
                break;

                case 1:{
                    // Group
                    holder.main_content_profile.setVisibility(View.GONE);
                    holder.main_content_group.setVisibility(View.VISIBLE);
                    holder.main_content_friend.setVisibility(View.GONE);


                    // this.text_name_content_group = (TextView) itemView.findViewById(R.id.text_name_content_group);

                    Iterator myVeryOwnIterator = data.keySet().iterator();
                    while (myVeryOwnIterator.hasNext()) {
                        Integer key = (Integer) myVeryOwnIterator.next();
                        if (section == key) {
                            ArrayList<JSONObject> value = (ArrayList<JSONObject>) data.get(key);
                            // Toast.makeText(ctx, "Key: "+key+" Value: "+value, Toast.LENGTH_LONG).show();

                            // emotionName
                            // holder.title.setText(value.get(relativePosition).getString("path"));

                            // ImageLoader imageLoader = ImageLoader.getInstance();
                            // imageLoader.displayImage(value.get(relativePosition).getString("path"), holder.image);

                            JSONObject jsonObject = value.get(relativePosition);

                            if (jsonObject.has("title_section")) {

                                if (jsonObject.getString("title_section").equalsIgnoreCase("Groups")) {

                                    // members
                                    if (jsonObject.has("members")){
                                        JSONObject members= jsonObject.getJSONObject("members");

                                        String name = jsonObject.getString("name");
                                        holder.text_name_content_group.setText(name + "("+ members.length() +")");
                                    }else{
                                        String name = jsonObject.getString("name");
                                        holder.text_name_content_group.setText(name);
                                    }


                                    ImageLoader.getInstance().displayImage("", holder.image_content_group);
                                    if (jsonObject.has("image_url")) {
                                        ImageLoader.getInstance().displayImage(Configs.API_URI + jsonObject.getString("image_url"), holder.image_content_group);
                                    }

                                    holder.main_content_group.setTag(R.string._parameter_1, jsonObject);
                                    holder.main_content_group.setOnLongClickListener(new View.OnLongClickListener() {
                                        @Override
                                        public boolean onLongClick(View view) {

                                            JSONObject data = (JSONObject) view.getTag(R.string._parameter_1);
                                            ((App) contactsActivity.getApplicationContext()).getMainActivity().showDialogFriend(Configs.GROUPS, data.toString());

                                            return true;
                                        }
                                    });
                                }
                            }
                            break;
                        }
                    }
                }
                break;

                default: {

                    holder.main_content_profile.setVisibility(View.GONE);
                    holder.main_content_group.setVisibility(View.GONE);
                    holder.main_content_friend.setVisibility(View.VISIBLE);

                    holder.swipeRevealLayout.close(true);
                    binderHelper.bind(holder.swipeRevealLayout, Integer.toString(section + relativePosition + absolutePosition));

                    holder.swipeRevealLayout.setLockDrag(false);

                    Iterator myVeryOwnIterator = data.keySet().iterator();
                    while (myVeryOwnIterator.hasNext()) {
                        Integer key = (Integer) myVeryOwnIterator.next();
                        if (section == key) {
                            ArrayList<JSONObject> value = (ArrayList<JSONObject>) data.get(key);
                            // Toast.makeText(ctx, "Key: "+key+" Value: "+value, Toast.LENGTH_LONG).show();

                            // emotionName
                            // holder.title.setText(value.get(relativePosition).getString("path"));

                            // ImageLoader imageLoader = ImageLoader.getInstance();
                            // imageLoader.displayImage(value.get(relativePosition).getString("path"), holder.image);

                            JSONObject jsonObject = value.get(relativePosition);

                            if (jsonObject.has("title_section")){

                                if (jsonObject.getString("title_section").equalsIgnoreCase("Groups")){

                                    String name = jsonObject.getString("name");
                                    holder.text_name.setText(name);

                                    ImageLoader.getInstance().displayImage("", holder.image_profile);
                                    if(jsonObject.has("image_url")){
                                        ImageLoader.getInstance().displayImage(Configs.API_URI + jsonObject.getString("image_url"), holder.image_profile);
                                    }

                                    holder.mainLayout.setTag(R.string._parameter_1, jsonObject);
                                    holder.mainLayout.setOnLongClickListener(new View.OnLongClickListener(){
                                        @Override
                                        public boolean onLongClick(View view) {

                                            JSONObject data = (JSONObject) view.getTag(R.string._parameter_1);
                                            ((App)contactsActivity.getApplicationContext()).getMainActivity().showDialogFriend(Configs.GROUPS, data.toString());

                                            return true;
                                        }
                                    });
                                }else if (jsonObject.getString("title_section").equalsIgnoreCase("Friends")){
                                    String friend_id = value.get(relativePosition).getString("friend_id");

//                                    String favorite = "0";
//                                    if (value.get(relativePosition).has("favorite")){
//                                        favorite = value.get(relativePosition).getString("favorite");
//                                    }

                                    JSONObject val = ((App)contactsActivity.getApplicationContext()).getProfileFriend(friend_id);
                                    // val.put("friend_id", friend_id);
                                    // val.put("favorite", favorite);

                                    holder.text_name.setText(val.getString("name") + " : " + value.get(relativePosition).getString("friend_id"));
                                    holder.text_email.setText(val.getString("mail"));

                                    ImageLoader.getInstance().displayImage("", holder.image_profile);
                                    if(val.has("image_url")){
                                        ImageLoader.getInstance().displayImage(Configs.API_URI + val.getString("image_url"), holder.image_profile);
                                    }

                                    holder.text_change_friend_name.setText("-");
                                    if(jsonObject.has("change_friends_name")){
                                        holder.text_change_friend_name.setText("Change friends name : " + jsonObject.getString("change_friends_name"));
                                    }

                                    holder.text_status_messsage.setText("-");
                                    if(val.has("status_message")){
                                        holder.text_status_messsage.setText(val.getString("status_message"));
                                    }

                                    holder.mainLayout.setTag(R.string._parameter_1, value.get(relativePosition));
                                    holder.mainLayout.setOnLongClickListener(new View.OnLongClickListener(){
                                        @Override
                                        public boolean onLongClick(View view) {

                                            JSONObject data = (JSONObject) view.getTag(R.string._parameter_1);
                                            ((App)contactsActivity.getApplicationContext()).getMainActivity().showDialogFriend(Configs.FRIENDS, data.toString());

                                            return true;
                                        }
                                    });
                                }else if (jsonObject.getString("title_section").equalsIgnoreCase("Favorites")){
                                    // {"change_friends_name":"y0u","chat_id":"zSlfdf6d9gBNAjhcTibm","status":"friend","favorite":"1","create":1505280310,"friend_id":"968","title_section":"Favorites"}
                                    String friend_id = value.get(relativePosition).getString("friend_id");
                                    // String favorite = value.get(relativePosition).getString("favorite");

                                    JSONObject val = ((App)contactsActivity.getApplicationContext()).getProfileFriend(friend_id);
                                    // val.put("friend_id", friend_id);
                                    // val.put("favorite", favorite);

                                    holder.text_name.setText(val.getString("name") + " : " + value.get(relativePosition).getString("friend_id"));
                                    holder.text_email.setText(val.getString("mail"));

                                    ImageLoader.getInstance().displayImage("", holder.image_profile);
                                    if(val.has("image_url")){
                                        ImageLoader.getInstance().displayImage(Configs.API_URI + val.getString("image_url"), holder.image_profile);
                                    }

                                    holder.text_change_friend_name.setText("-");
                                    if(jsonObject.has("change_friends_name")){
                                        holder.text_change_friend_name.setText("Change friends name : " + jsonObject.getString("change_friends_name"));
                                    }

                                    holder.text_status_messsage.setText("-");
                                    if(val.has("status_message")){
                                        holder.text_status_messsage.setText(val.getString("status_message"));
                                    }

                                    holder.mainLayout.setTag(R.string._parameter_1, value.get(relativePosition));
                                    holder.mainLayout.setOnLongClickListener(new View.OnLongClickListener(){
                                        @Override
                                        public boolean onLongClick(View view) {

                                            JSONObject data = (JSONObject) view.getTag(R.string._parameter_1);
                                            ((App)contactsActivity.getApplicationContext()).getMainActivity().showDialogFriend(Configs.FAVORITES, data.toString());

                                            return true;
                                        }
                                    });
                                }
                            }

                            /*

                            */
                            break;
                        }
                    }

                    holder.textArchive.setTag(R.string._parameter_1, section);
                    holder.textArchive.setTag(R.string._parameter_2, relativePosition);
                    holder.textArchive.setTag(R.string._parameter_3, holder.swipeRevealLayout);
                    holder.textArchive.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            int section = (int)view.getTag(R.string._parameter_1);
                            int index = (int)view.getTag(R.string._parameter_2);
                            SwipeRevealLayout swipeRevealLayout = (SwipeRevealLayout)view.getTag(R.string._parameter_3);

                            Iterator myVeryOwnIterator = data.keySet().iterator();
                            while(myVeryOwnIterator.hasNext()) {
                                Integer key=(Integer)myVeryOwnIterator.next();
                                if (section == key) {
                                    ArrayList<JSONObject> value = (ArrayList<JSONObject>) data.get(key);
                                    value.remove(index);

                                    data.put(key, value);
                                    swipeRevealLayout.close(true);
                                    notifyDataSetChanged();
                                }
                            }
                        }
                    });

                    holder.textDelete.setTag(R.string._parameter_1, section);
                    holder.textDelete.setTag(R.string._parameter_2, relativePosition);
                    holder.textDelete.setTag(R.string._parameter_3, holder.swipeRevealLayout);
                    holder.textDelete.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            int section = (int)view.getTag(R.string._parameter_1);
                            int index = (int)view.getTag(R.string._parameter_2);
                            SwipeRevealLayout swipeRevealLayout = (SwipeRevealLayout)view.getTag(R.string._parameter_3);

                            Iterator myVeryOwnIterator = data.keySet().iterator();
                            while(myVeryOwnIterator.hasNext()) {
                                Integer key=(Integer)myVeryOwnIterator.next();
                                if (section == key) {
                                    ArrayList<JSONObject> value = (ArrayList<JSONObject>) data.get(key);
                                    value.remove(index);

                                    data.put(key, value);
                                    swipeRevealLayout.close(true);
                                    notifyDataSetChanged();
                                }
                            }
                        }
                    });

                    holder.mainLayout.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            contactsActivity.startActivity(new Intent(contactsActivity, ChatView.class));
                        }
                    });


                }
            }
        }catch(Exception ex){
            Log.e("", ex.toString());
        }
    }

    @Override
    public int getItemViewType(int section, int relativePosition, int absolutePosition) {
//    if (section == 1) {
//      // VIEW_TYPE_FOOTER is -3, VIEW_TYPE_HEADER is -2, VIEW_TYPE_ITEM is -1.
//      // You can return 0 or greater.
//      return 0;
//    }
        return super.getItemViewType(section, relativePosition, absolutePosition);
    }

    @Override
    public MainVH onCreateViewHolder(ViewGroup parent, int viewType) {
        int layout;
        switch (viewType) {
            case VIEW_TYPE_HEADER:
                layout = R.layout.list_item_header;
                break;
            case VIEW_TYPE_ITEM: {
                layout = R.layout.list_item_main;
            }
                break;
            case VIEW_TYPE_FOOTER:
                layout = R.layout.list_item_footer;
                break;
            default:
                // Our custom item, which is the 0 returned in getItemViewType() above
                layout = R.layout.list_item_main_bold;
                break;
        }

        View v = LayoutInflater.from(parent.getContext()).inflate(layout, parent, false);
        return new MainVH(v, this, viewType);
    }

    /**
     * Only if you need to restore open/close state when the orientation is changed.
     * Call this method in {@link android.app.Activity#onSaveInstanceState(Bundle)}
     */
    public void saveStates(Bundle outState) {
        binderHelper.saveStates(outState);
    }

    /**
     * Only if you need to restore open/close state when the orientation is changed.
     * Call this method in {@link android.app.Activity#onRestoreInstanceState(Bundle)}
     */
    public void restoreStates(Bundle inState) {
        binderHelper.restoreStates(inState);
    }

    static class MainVH extends SectionedViewHolder implements View.OnClickListener, View.OnLongClickListener {

        private LinearLayout main_content_profile, main_content_group,main_content_friend;

        // -- profile
        private ImageView image_content_profile;
        private TextView text_name_content_profile, text_email_content_profile, text_status_message_content_profile;
        // -- profile

        // -- group
        private ImageView image_content_group;
        private TextView text_name_content_group;
        // -- group


        private SwipeRevealLayout swipeRevealLayout;
        private LinearLayout mainLayout;
        private TextView textArchive, textDelete;

        private TextView title;
        private ImageView caret;
        private ContactsAdapter adapter;
        private Toast toast;

        //---- list_item_main
        private ImageView image_profile;
        private TextView text_name, text_email, text_status_messsage, text_change_friend_name;
        //---- list_item_main

        MainVH(View itemView, ContactsAdapter adapter, int viewType) {
            super(itemView);

            this.main_content_profile = (LinearLayout)itemView.findViewById(R.id.main_content_profile);
            this.main_content_group = (LinearLayout)itemView.findViewById(R.id.main_content_group);
            this.main_content_friend = (LinearLayout)itemView.findViewById(R.id.main_content_friend);

            // -- profile
            this.image_content_profile = (ImageView)itemView.findViewById(R.id.image_content_profile);
            this.text_name_content_profile = (TextView) itemView.findViewById(R.id.text_name_content_profile);
            this.text_email_content_profile = (TextView) itemView.findViewById(R.id.text_email_content_profile);
            this.text_status_message_content_profile = (TextView) itemView.findViewById(R.id.text_status_message_content_profile);
            // -- profile

            // -- group
            this.image_content_group = (ImageView) itemView.findViewById(R.id.image_content_group);
            this.text_name_content_group = (TextView) itemView.findViewById(R.id.text_name_content_group);
            // -- group

            this.swipeRevealLayout = (SwipeRevealLayout)itemView.findViewById(R.id.swipe_layout);
            this.mainLayout = (LinearLayout) itemView.findViewById(R.id.main_layout);
            this.textArchive = (TextView) itemView.findViewById(R.id.txt_archive);
            this.textDelete = (TextView) itemView.findViewById(R.id.txt_delete);


            this.title = itemView.findViewById(R.id.title);
            this.caret = itemView.findViewById(R.id.caret);


            //---- list_item_main
            this.image_profile = itemView.findViewById(R.id.image_profile);
            this.text_name = itemView.findViewById(R.id.text_name);
            this.text_change_friend_name = itemView.findViewById(R.id.text_change_friend_name);
            this.text_email = itemView.findViewById(R.id.text_email);
            this.text_status_messsage = itemView.findViewById(R.id.text_status_messsage);
            //---- list_item_main

            this.adapter = adapter;
            itemView.setOnClickListener(this);
            itemView.setOnLongClickListener(this);
        }

        @Override
        public void onClick(View view) {

            if (isFooter()) {
                // ignore footer clicks
                return;
            }

            if (isHeader()) {
                int section = getRelativePosition().section();
                switch (section){
                    case 0:{
                        return;
                    }
                    default:{
                        adapter.toggleSectionExpanded(section);
                    }
                    break;
                }
            } else {
                if (toast != null) {
                    toast.cancel();
                }
                toast = Toast.makeText(view.getContext(), getRelativePosition().toString(), Toast.LENGTH_SHORT);
                toast.show();
            }
        }

        @Override
        public boolean onLongClick(View view) {

            if (isFooter()) {
                // ignore footer clicks
                return false;
            }

            int section = getRelativePosition().section();
            if (isHeader()) {

            }else{
                switch (section){
                    case 0:{
                        toast = Toast.makeText(view.getContext(), "Profile : " + getRelativePosition().toString(), Toast.LENGTH_SHORT);
                        toast.show();

                        return true;
                    }
                    default:{
                        toast = Toast.makeText(view.getContext(), "F * R * G : " + getRelativePosition().toString(), Toast.LENGTH_SHORT);
                        toast.show();

                        return true;
                    }
                }
            }

            return false;
        }

    }
}
