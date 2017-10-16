package net.ichat.ichat.handler;

import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import net.ichat.ichat.MainActivity;

/**
 * Created by Somkid on 7/23/2017 AD.
 */
public class AnNmousUHandler extends Handler {
    private String TAG = AnNmousUHandler.class.getName();
    private MainActivity mActivity;

    public AnNmousUHandler(MainActivity mActivity) {
        // TODO Auto-generated constructor stub
        this.mActivity = mActivity;
    }

    @Override
    public void handleMessage(Message msg) {
        // TODO Auto-generated method stub
        super.handleMessage(msg);
        try {
            if(msg.getData().getBoolean("status")){
                // tabGallerys.reloadData(msg.getData().getString("data"));
                // mActivity.UserLg();
            }else{
                Toast.makeText(mActivity.getApplicationContext(), msg.getData().getString("message"), Toast.LENGTH_SHORT).show();
            }
            // tabGallerys.dismissDialog(tabGallerys.DIALOG_LOADING);
        } catch (Exception e) {
            // TODO: handle exception
            Log.e(TAG, e.toString());
        }
    }
}
