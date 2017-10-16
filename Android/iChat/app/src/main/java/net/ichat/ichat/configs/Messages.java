package net.ichat.ichat.configs;

/**
 * Created by somkid on 13/10/2017 AD.
 */

public class Messages {
    public static final String TABLE = "Messages";
    public Messages(){}

    // Primary key
    public static final String KEY_ID = "id";

    // Labels Table Columns names
    public static final String KEY_chat_id      = "chat_id";
    public static final String KEY_object_id    = "object_id";
    public static final String KEY_sender_id    = "sender_id";
    public static final String KEY_receive_id   = "receive_id";
    public static final String KEY_text         = "text";
    public static final String KEY_type         = "type";
    public static final String KEY_status       = "status";
    public static final String KEY_reader       = "reader";
    public static final String KEY_create       = "tcreate";
    public static final String KEY_update       = "tupdate";

    public String chat_id;
    public String object_id;
    public String sender_id;
    public String receive_id;
    public String text;
    public String type;
    public String status;
    public String reader;
    public String create;
    public String update;
}
