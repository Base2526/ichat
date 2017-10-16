package com.afollestad.sectionedrecyclerviewsample;

import android.annotation.SuppressLint;
import android.content.Context;
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
import org.json.JSONObject;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/** @author Aidan Follestad (afollestad) */
@SuppressLint("DefaultLocale")
class ContactsAdapter extends SectionedRecyclerViewAdapter<ContactsAdapter.MainVH> {

  private Context context;

  private Map<Integer, ArrayList<String>> data = new HashMap<Integer, ArrayList<String>>();

  private final ViewBinderHelper binderHelper;

  public ContactsAdapter(Context context) {
      this.context = context;

      binderHelper = new ViewBinderHelper();
      // uncomment if you want to open only one row at a time
      binderHelper.setOpenOnlyOne(true);
  }

  public void setData(Map<Integer, ArrayList<String>> data){
    this.data = data;

    notifyDataSetChanged();
  }

  @Override
  public int getSectionCount() {
    /*
    * จำนวน section ทั้งหมด
    * */
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
        ArrayList<String> value = (ArrayList<String>) data.get(key);
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
        holder.title.setText("Profile");
        holder.caret.setImageResource(0);

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
              ArrayList<String> value = (ArrayList<String>) data.get(key);
              // Toast.makeText(ctx, "Key: "+key+" Value: "+value, Toast.LENGTH_LONG).show();

              // emotionName
              // holder.title.setText(value.get(relativePosition).getString("path"));

              // ImageLoader imageLoader = ImageLoader.getInstance();
              // imageLoader.displayImage(value.get(relativePosition).getString("path"), holder.image);

              // holder.title.setText(value.get(relativePosition));
              holder.title.setText(String.format("Section Header %d : %d", section, value.size()));
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
    // holder.title.setText(String.format("S:%d, P:%d, A:%d", section, relativePosition, absolutePosition));
    //  holder.image.setBackgroundResource(R.drawable.a1_1_1);

    // holder.image.setBackgroundResource(R.drawable.a1_1_1);

    // holder.image.setBackground(context.getDrawable(R.drawable.a1_1_1));
    // holder.image.setBackgroundResource(context.getDrawable(R.drawable.a1_1_1));

    try {

        holder.swipeRevealLayout.close(true);
        binderHelper.bind(holder.swipeRevealLayout, Integer.toString(section + relativePosition + absolutePosition));

        switch (section) {
          case 0: {
            holder.title.setText("Item Profile");
  //          holder.caret.setImageResource(0);
  //
            holder.swipeRevealLayout.setLockDrag(true);

            holder.swipeRevealLayout.setOnClickListener(new View.OnClickListener() {
              @Override
              public void onClick(View view) {
                Toast.makeText(context, "swipeRevealLayout", Toast.LENGTH_LONG).show();
              }
            });
            holder.mainLayout.setOnClickListener(new View.OnClickListener() {
              @Override
              public void onClick(View view) {
                Toast.makeText(context, "mainLayout : Profile", Toast.LENGTH_LONG).show();
              }
            });
          }
          break;
          default: {

            holder.swipeRevealLayout.setLockDrag(false);

            Iterator myVeryOwnIterator = data.keySet().iterator();
            while (myVeryOwnIterator.hasNext()) {
              Integer key = (Integer) myVeryOwnIterator.next();
              if (section == key) {
                ArrayList<String> value = (ArrayList<String>) data.get(key);
                // Toast.makeText(ctx, "Key: "+key+" Value: "+value, Toast.LENGTH_LONG).show();

                // emotionName
                // holder.title.setText(value.get(relativePosition).getString("path"));

                // ImageLoader imageLoader = ImageLoader.getInstance();
                // imageLoader.displayImage(value.get(relativePosition).getString("path"), holder.image);

                holder.title.setText("Item " + value.get(relativePosition));
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
                    ArrayList<String> value = (ArrayList<String>) data.get(key);
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
                    ArrayList<String> value = (ArrayList<String>) data.get(key);
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
                Toast.makeText(context, "mainLayout : xx", Toast.LENGTH_LONG).show();
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
      case VIEW_TYPE_ITEM:
        layout = R.layout.list_item_main;
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
    private SwipeRevealLayout swipeRevealLayout;
    private LinearLayout mainLayout;
    private TextView textArchive, textDelete;

    private TextView title;
    private ImageView caret;
    private ContactsAdapter adapter;
    private Toast toast;

    MainVH(View itemView, ContactsAdapter adapter, int viewType) {
      super(itemView);

      this.swipeRevealLayout = (SwipeRevealLayout)itemView.findViewById(R.id.swipe_layout);
      this.mainLayout = (LinearLayout) itemView.findViewById(R.id.main_layout);
      this.textArchive = (TextView) itemView.findViewById(R.id.txt_archive);
      this.textDelete = (TextView) itemView.findViewById(R.id.txt_delete);


      this.title = itemView.findViewById(R.id.title);
      this.caret = itemView.findViewById(R.id.caret);

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
