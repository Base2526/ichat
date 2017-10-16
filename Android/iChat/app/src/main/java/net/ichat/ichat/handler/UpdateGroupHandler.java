package net.ichat.ichat.handler;

import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import net.ichat.ichat.CreateGroupActivity;
import net.ichat.ichat.ManageGroupActivity;

/**
 * Created by somkid on 15/10/2017 AD.
 */

public class UpdateGroupHandler extends Handler {
    private String TAG = CreateGroupHandler.class.getName();
    private ManageGroupActivity manageGroupActivity;

    public UpdateGroupHandler(ManageGroupActivity manageGroupActivity) {
        // TODO Auto-generated constructor stub
        this.manageGroupActivity = manageGroupActivity;
    }

    @Override
    public void handleMessage(Message msg) {
        // TODO Auto-generated method stub
        super.handleMessage(msg);
        try {
            if(msg.getData().getBoolean("status")){
                manageGroupActivity.finish();
            }else{
                Toast.makeText(manageGroupActivity.getApplicationContext(), msg.getData().getString("message"), Toast.LENGTH_SHORT).show();
            }
            manageGroupActivity.dismissDialog(manageGroupActivity.DIALOG_WAIT);
        } catch (Exception e) {
            // TODO: handle exception
            Log.e(TAG, e.toString());
        }
    }
}