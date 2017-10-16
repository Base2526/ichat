package net.ichat.ichat.thread;

import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Message;

import net.ichat.ichat.CreateGroupActivity;
import net.ichat.ichat.InviteFriendsActivity;
import net.ichat.ichat.service.Services;

/**
 * Created by somkid on 15/10/2017 AD.
 */

public class GroupInviteNewMembersThread extends Thread {
    private String TAG = GroupInviteNewMembersThread.class.getName();

    private InviteFriendsActivity inviteFriendsActivity;
    private Object[] result;
    private Bundle bundle;
    private Services services;

    private String group_id;
    private String[] members;

    public GroupInviteNewMembersThread(InviteFriendsActivity inviteFriendsActivity, String group_id, String[] members) {
        // TODO Auto-generated constructor stub
        super("LoginThread");

        this.inviteFriendsActivity = inviteFriendsActivity;

        this.services = new Services(inviteFriendsActivity);
        this.bundle = new Bundle();

        this.group_id = group_id;
        this.members = members;
    }

    @Override
    public void run() {
        // TODO Auto-generated method stub
        super.run();

        try {
            result = services.onGroupInviteNewMembers(group_id, members);
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

        Message msg = inviteFriendsActivity.groupInviteNewMembersHandler.obtainMessage();
        msg.setData(bundle);
        inviteFriendsActivity.groupInviteNewMembersHandler.sendMessage(msg);
    }
}