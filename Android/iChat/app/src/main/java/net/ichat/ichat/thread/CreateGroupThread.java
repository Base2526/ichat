package net.ichat.ichat.thread;

import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Message;

import net.ichat.ichat.CreateGroupActivity;
import net.ichat.ichat.ProfileActivity;
import net.ichat.ichat.service.Services;

import java.util.ArrayList;

/**
 * Created by somkid on 14/10/2017 AD.
 */

public class CreateGroupThread extends Thread {
    private String TAG = CreateGroupThread.class.getName();

    private CreateGroupActivity createGroupActivity;
    private Object[] result;
    private Bundle bundle;
    private Services services;

    private Bitmap bitmap;
    private String name;
    private String[] members;

    public CreateGroupThread(CreateGroupActivity createGroupActivity, Bitmap bitmap, String name, String[] members) {
        // TODO Auto-generated constructor stub
        super("LoginThread");

        this.createGroupActivity = createGroupActivity;

        this.services = new Services(createGroupActivity);
        this.bundle = new Bundle();

        this.bitmap = bitmap;
        this.name = name;
        this.members = members;
    }

    @Override
    public void run() {
        // TODO Auto-generated method stub
        super.run();

        try {
            result = services.onCreateGroup(bitmap, name, members);
            if ((Boolean) result[0]) {
                bundle.putBoolean("status", true);
            } else {
                bundle.putBoolean("status", false);
                bundle.putString("message", (String) result[1]);
            }

        } catch (Exception e) {
            // TODO: handle exception
            bundle.putBoolean("status", false);
            bundle.putString("message", e.toString());
        }

        Message msg = createGroupActivity.createGroupHandler.obtainMessage();
        msg.setData(bundle);
        createGroupActivity.createGroupHandler.sendMessage(msg);
    }
}