package net.ichat.ichat.thread;

import android.os.Bundle;
import android.os.Message;

import net.ichat.ichat.MainActivity;
import net.ichat.ichat.ProfileActivity;
import net.ichat.ichat.service.Services;

/**
 * Created by somkid on 14/10/2017 AD.
 */

public class UpdateMyProfileThread extends Thread {
    private String TAG = AnNmousUThread.class.getName();

    private ProfileActivity profileActivity;
    private Object[] result;
    private Bundle bundle;
    private Services services;

    private String name, status_mss;

    public UpdateMyProfileThread(ProfileActivity profileActivity, String name, String status_mss) {
        // TODO Auto-generated constructor stub
        super("LoginThread");

        this.profileActivity = profileActivity;

        this.services = new Services(profileActivity);
        this.bundle = new Bundle();

        this.name = name;
        this.status_mss = status_mss;
    }

    @Override
    public void run() {
        // TODO Auto-generated method stub
        super.run();

        try {
            result = services.onUpdateMyProfile(name, status_mss);
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

        Message msg = profileActivity.updateMyProfileHandler.obtainMessage();
        msg.setData(bundle);
        profileActivity.updateMyProfileHandler.sendMessage(msg);
    }
}