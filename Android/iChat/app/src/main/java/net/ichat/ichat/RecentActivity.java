package net.ichat.ichat;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.WindowManager;

import net.ichat.ichat.adapter.RecentAdapter;

import java.util.ArrayList;

public class RecentActivity extends AppCompatActivity {
    private String TAG = RecentActivity.class.getName();

    private RecyclerView recycler_view;

    private RecentAdapter recentAdapter;
    private ArrayList<String> _items;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_recent);

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        getSupportActionBar().hide();

        recycler_view = (RecyclerView)findViewById(R.id.recycler_view);

        recycler_view.setLayoutManager(new LinearLayoutManager(this));

        _items = new ArrayList<String>();
        recentAdapter = new RecentAdapter(this, _items);
        recycler_view.setAdapter(recentAdapter);

        loadData();
    }

    private void loadData() {

        _items.add("1");
        _items.add("2");
        _items.add("3");
        _items.add("4");
        _items.add("5");
        _items.add("6");
        _items.add("7");
        _items.add("8");
        _items.add("9");
        _items.add("10");

        recentAdapter.setData(_items);
    }
}
