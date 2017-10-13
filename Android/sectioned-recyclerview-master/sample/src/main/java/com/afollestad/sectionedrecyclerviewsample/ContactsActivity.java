package com.afollestad.sectionedrecyclerviewsample;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/** @author Aidan Follestad (afollestad) */
public class ContactsActivity extends AppCompatActivity {

  private ContactsAdapter adapter;
  private boolean hideEmpty  = false;
  private boolean showFooters = false;

  private int count = 0;

  private Map<Integer, ArrayList<String>> data = new HashMap<Integer, ArrayList<String>>();

  @Override
  protected void onCreate(@Nullable Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_contacts);

    RecyclerView recyclerView = (RecyclerView) findViewById(R.id.recycleView);
    adapter = new ContactsAdapter(this);

    GridLayoutManager manager = new GridLayoutManager(this, 1 /* เป็นจำนวนของ  item each row*/);
    recyclerView.setLayoutManager(manager);
    adapter.setLayoutManager(manager);

    /*
    * จะ hide เมือ section นั้นไม่มี item
    * */
    adapter.shouldShowHeadersForEmptySections(hideEmpty);

    /*
    * ปิดไม่ให้แสดง footer
    * */
    adapter.shouldShowFooters(showFooters);
    recyclerView.setAdapter(adapter);

    reloadData();
  }

  private void reloadData() {
    ArrayList<String> a1 = new ArrayList<>();
    ArrayList<String> a2 = new ArrayList<>();
    ArrayList<String> a3 = new ArrayList<>();
    ArrayList<String> a4 = new ArrayList<>();
    ArrayList<String> a5 = new ArrayList<>();

    for (int i =0; i<1; i++){
      a1.add("x0 : " + i);
    }

    data.put(0, a1);

    for (int i =0; i<6; i++){
      a2.add("x1 : " + i);
    }

    data.put(1, a2);

    for (int i =0; i<1; i++){
      a3.add("x2 : " + i);
    }

    data.put(2, a3);

    for (int i =0; i<0; i++){
      a4.add("x3 : " + i);
    }

    data.put(3, a4);

    for (int i =0; i<4; i++){
      a5.add("x4 : " + i);
    }

    data.put(4, a5);
    adapter.setData(data);
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    getMenuInflater().inflate(R.menu.main, menu);
    menu.findItem(R.id.hide_empty_sections).setChecked(!hideEmpty);
    menu.findItem(R.id.show_footers).setChecked(showFooters);
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    if (item.getItemId() == R.id.hide_empty_sections) {
      hideEmpty = !hideEmpty;
//      adapter.shouldShowHeadersForEmptySections(hideEmpty);
//      item.setChecked(!hideEmpty);

      try {
        Iterator myVeryOwnIterator = data.keySet().iterator();
        while (myVeryOwnIterator.hasNext()) {
          Integer key = (Integer) myVeryOwnIterator.next();
          if (0 == key) {
            ArrayList<String> value = (ArrayList<String>) data.get(key);
            // Toast.makeText(ctx, "Key: "+key+" Value: "+value, Toast.LENGTH_LONG).show();

            // emotionName
            // holder.title.setText(value.get(relativePosition).getString("path"));

            // ImageLoader imageLoader = ImageLoader.getInstance();
            // imageLoader.displayImage(value.get(relativePosition).getString("path"), holder.image);

            // holder.title.setText(value.get(relativePosition));
            // value.add("xx-" + (count++));
            value.remove(count);

            data.put(0, value);

            adapter.setData(data);

          }else if (1 == key) {
            ArrayList<String> value = (ArrayList<String>) data.get(key);
            // Toast.makeText(ctx, "Key: "+key+" Value: "+value, Toast.LENGTH_LONG).show();

            // emotionName
            // holder.title.setText(value.get(relativePosition).getString("path"));

            // ImageLoader imageLoader = ImageLoader.getInstance();
            // imageLoader.displayImage(value.get(relativePosition).getString("path"), holder.image);

            // holder.title.setText(value.get(relativePosition));
            value.add("xx-" + (count++));

            data.put(1, value);

            adapter.setData(data);
          }
        }
      }catch (Exception ex){
        Log.e("", ex.toString());
      }

      Log.e("", "");
      return true;
    }else if (item.getItemId() == R.id.show_footers) {
//      showFooters = !showFooters;
//      adapter.shouldShowFooters(showFooters);
//      item.setChecked(showFooters);

      Log.e("", "");
      return true;
    }

    return super.onOptionsItemSelected(item);
  }
}
