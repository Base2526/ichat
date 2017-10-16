package net.ichat.ichat.adapter;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import net.ichat.ichat.R;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;

/**
 * Created by somkid on 13/10/2017 AD.
 */

public class RecentAdapter extends RecyclerView.Adapter{
    private String TAG = RecentAdapter.class.getName();

    private Context context;
    private ArrayList<String> _items;
    private LayoutInflater mInflater;
    // private final ViewBinderHelper binderHelper = new ViewBinderHelper();

    int selectedPosition=-1;

    public RecentAdapter(Context pcontext, ArrayList<String> _items) {
        context = pcontext;
        this._items = _items;
        mInflater = LayoutInflater.from(pcontext);

    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = mInflater.inflate(R.layout.item_recent, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder h, int position) {
        final ViewHolder holder = (ViewHolder) h;

    }


    @Override
    public int getItemCount() {
        if (_items == null)
            return 0;
        return _items.size();
    }

    public void setData(ArrayList<String> _items) {
        this._items = _items;

        notifyDataSetChanged();
    }

    private class ViewHolder extends RecyclerView.ViewHolder {
        private String TAG = ViewHolder.class.getName();

        private LinearLayout mainV;
        private ImageView imV;
        private TextView txtName, txtMessage, txtTime, new_notifications;
        public ViewHolder(View itemView) {
            super(itemView);

//            _itemView = itemView;
//            swipeLayout = (SwipeRevealLayout) itemView.findViewById(R.id.swipe_layout);
//
//            mainV    = (LinearLayout)itemView.findViewById(R.id.mainV);
//            imV      = (ImageView)itemView.findViewById(R.id.imV);
//            txtName  = (TextView)itemView.findViewById(R.id.txtName);
//            new_notifications  = (TextView)itemView.findViewById(R.id.new_notifications);
//            txtMessage  = (TextView)itemView.findViewById(R.id.txtMessage);
//            txtDelete   = (TextView)itemView.findViewById(R.id.txtDelete);
//            txtArchive  = (TextView)itemView.findViewById(R.id.txtArchive);
//            txtTime     = (TextView)itemView.findViewById(R.id.txtTime);
//
//            new_notifications = (TextView)itemView.findViewById(R.id.new_notifications);
//
//            relativeContainer = (RelativeLayout) itemView.findViewById(R.id.relativeContainer);
        }
    }
}
