package net.ichat.ichat.handler;

import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import net.ichat.ichat.MainActivity;
import net.ichat.ichat.ProfileActivity;

/**
 * Created by somkid on 14/10/2017 AD.
 */

public class UpdatePictureMyProfileHandler extends Handler {
    private String TAG = AnNmousUHandler.class.getName();
    private ProfileActivity profileActivity;

    public UpdatePictureMyProfileHandler(ProfileActivity profileActivity) {
        // TODO Auto-generated constructor stub
        this.profileActivity = profileActivity;
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
                // Toast.makeText(mActivity.getApplicationContext(), msg.getData().getString("message"), Toast.LENGTH_SHORT).show();
            }
        } catch (Exception e) {
            // TODO: handle exception
            Log.e(TAG, e.toString());
        }
    }
}