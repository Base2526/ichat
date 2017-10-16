package net.ichat.ichat.thread;

import android.os.Bundle;
import android.os.Message;

import net.ichat.ichat.MainActivity;
import net.ichat.ichat.service.Services;


/**
 * Created by Somkid on 7/23/2017 AD.
 */
public class AnNmousUThread extends Thread {
    private String TAG = AnNmousUThread.class.getName();

    private MainActivity mainActivity;
    private Object[] result;
    private Bundle bundle;
    private Services services;

    public AnNmousUThread(MainActivity mainActivity) {
        // TODO Auto-generated constructor stub
        super("LoginThread");

        this.mainActivity = mainActivity;

        this.services = new Services(mainActivity);
        this.bundle = new Bundle();
    }

    @Override
    public void run() {
        // TODO Auto-generated method stub
        super.run();

        try {
            result = services.onANNMOUSU();
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

        Message msg = mainActivity.nmousUHandler.obtainMessage();
        msg.setData(bundle);
        mainActivity.nmousUHandler.sendMessage(msg);
    }
}