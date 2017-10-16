package net.ichat.ichat.handler;

import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import net.ichat.ichat.CreateGroupActivity;
import net.ichat.ichat.MainActivity;

/**
 * Created by somkid on 14/10/2017 AD.
 */

public class CreateGroupHandler extends Handler {
    private String TAG = CreateGroupHandler.class.getName();
    private CreateGroupActivity createGroupActivity;

    public CreateGroupHandler(CreateGroupActivity createGroupActivity) {
        // TODO Auto-generated constructor stub
        this.createGroupActivity = createGroupActivity;
    }

    @Override
    public void handleMessage(Message msg) {
        // TODO Auto-generated method stub
        super.handleMessage(msg);
        try {
            if(msg.getData().getBoolean("status")){
                createGroupActivity.finish();
            }else{
                Toast.makeText(createGroupActivity.getApplicationContext(), msg.getData().getString("message"), Toast.LENGTH_SHORT).show();
            }
            createGroupActivity.dismissDialog(createGroupActivity.DIALOG_WAIT);
        } catch (Exception e) {
            // TODO: handle exception
            Log.e(TAG, e.toString());
        }
    }
}
