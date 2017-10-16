package net.ichat.ichat.thread;

import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Message;

import net.ichat.ichat.CreateGroupActivity;
import net.ichat.ichat.ManageGroupActivity;
import net.ichat.ichat.service.Services;

/**
 * Created by somkid on 15/10/2017 AD.
 */

public class UpdateGroupThread extends Thread {
    private String TAG = CreateGroupThread.class.getName();

    private ManageGroupActivity manageGroupActivity;
    private Object[] result;
    private Bundle bundle;
    private Services services;

    private String group_id;
    private String name;
    private Bitmap bitmap;

    public UpdateGroupThread(ManageGroupActivity manageGroupActivity, String group_id, String name, Bitmap bitmap) {
        // TODO Auto-generated constructor stub
        super("LoginThread");

        this.manageGroupActivity = manageGroupActivity;

        this.services = new Services(manageGroupActivity);
        this.bundle = new Bundle();

        this.group_id = group_id;
        this.name = name;
        this.bitmap = bitmap;
    }

    @Override
    public void run() {
        // TODO Auto-generated method stub
        super.run();

        try {
            result = services.onUpdateGroup(group_id, name, bitmap);
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

        Message msg = manageGroupActivity.updateGroupHandler.obtainMessage();
        msg.setData(bundle);
        manageGroupActivity.updateGroupHandler.sendMessage(msg);
    }
}