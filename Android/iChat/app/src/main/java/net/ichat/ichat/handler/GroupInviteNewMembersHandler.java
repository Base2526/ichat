package net.ichat.ichat.handler;

import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import net.ichat.ichat.CreateGroupActivity;
import net.ichat.ichat.InviteFriendsActivity;

/**
 * Created by somkid on 15/10/2017 AD.
 */

public class GroupInviteNewMembersHandler extends Handler {
    private String TAG = GroupInviteNewMembersHandler.class.getName();
    private InviteFriendsActivity inviteFriendsActivity;

    public GroupInviteNewMembersHandler(InviteFriendsActivity inviteFriendsActivity) {
        // TODO Auto-generated constructor stub
        this.inviteFriendsActivity = inviteFriendsActivity;
    }

    @Override
    public void handleMessage(Message msg) {
        // TODO Auto-generated method stub
        super.handleMessage(msg);
        try {
            if(msg.getData().getBoolean("status")){
                inviteFriendsActivity.finish();
            }else{
                Toast.makeText(inviteFriendsActivity.getApplicationContext(), msg.getData().getString("message"), Toast.LENGTH_SHORT).show();
            }
            inviteFriendsActivity.dismissDialog(inviteFriendsActivity.DIALOG_WAIT);
        } catch (Exception e) {
            // TODO: handle exception
            Log.e(TAG, e.toString());
        }
    }
}