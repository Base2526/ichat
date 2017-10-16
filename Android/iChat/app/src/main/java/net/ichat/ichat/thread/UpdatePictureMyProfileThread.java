package net.ichat.ichat.thread;

import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Message;

import net.ichat.ichat.ProfileActivity;
import net.ichat.ichat.service.Services;

/**
 * Created by somkid on 14/10/2017 AD.
 */

public class UpdatePictureMyProfileThread extends Thread {
    private String TAG = AnNmousUThread.class.getName();

    private ProfileActivity profileActivity;
    private Object[] result;
    private Bundle bundle;
    private Services services;

    private Bitmap bitmap;

    public UpdatePictureMyProfileThread(ProfileActivity profileActivity, Bitmap bitmap) {
        // TODO Auto-generated constructor stub
        super("UpdatePictureMyProfileThread");

        this.profileActivity = profileActivity;

        this.services = new Services(profileActivity);
        this.bundle = new Bundle();

        this.bitmap = bitmap;
    }

    @Override
    public void run() {
        // TODO Auto-generated method stub
        super.run();

        try {
            result = services.onUpdatePictureProfile(bitmap);
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

        Message msg = profileActivity.updatePictureMyProfileHandler.obtainMessage();
        msg.setData(bundle);
        profileActivity.updatePictureMyProfileHandler.sendMessage(msg);
    }
}