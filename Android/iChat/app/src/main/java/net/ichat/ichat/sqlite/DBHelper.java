package net.ichat.ichat.sqlite;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import net.ichat.ichat.configs.Configs;
import net.ichat.ichat.configs.Messages;

/**
 * Created by somkid on 13/10/2017 AD.
 */

public class DBHelper extends SQLiteOpenHelper {
    //version number to upgrade database version
    //each time if you Add, Edit table, you need to change the
    //version number.
    private static final int DATABASE_VERSION = 1;

    public static String DATABASE_NAME =  "ichat.db";

    public DBHelper(Context context ) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    /*
    @Override
    public void onConfigure(SQLiteDatabase db) {
        db.execSQL("PRAGMA encoding = \"UTF-8\"");
    }
    */

    @Override
    public void onCreate(SQLiteDatabase db) {
        //All necessary tables you like to create will create here
        // Messages
        String CREATE_TABLE_MESSAGES = "CREATE TABLE " + Messages.TABLE  + "("
                + Messages.KEY_ID  + " INTEGER PRIMARY KEY AUTOINCREMENT ,"
                + Messages.KEY_chat_id  + " TEXT,"
                + Messages.KEY_object_id + " TEXT, "
                + Messages.KEY_sender_id + " TEXT, "
                + Messages.KEY_receive_id + " BLOB, "
                + Messages.KEY_text + " TEXT, "
                + Messages.KEY_type + " TEXT, "
                + Messages.KEY_status + " TEXT, "
                + Messages.KEY_reader + " TEXT, "
                + Messages.KEY_create + " TEXT, "
                + Messages.KEY_update + " TEXT )";
        db.execSQL(CREATE_TABLE_MESSAGES);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // Drop older table if existed, all data will be gone!!!
        //db.execSQL("DROP TABLE IF EXISTS " + Student.TABLE);

        // Create tables again

//        db.execSQL("DROP TABLE IF EXISTS " + Recent.TABLE );
//        db.execSQL("CREATE TABLE " +  Recent.TABLE);

        // v2->v3
//        if (newVersion == 3) {
//            db.execSQL("ALTER TABLE "+ MyProfiles.TABLE +" ADD COLUMN "+ MyProfiles.KEY_fcmToken +" TEXT");
//        }

        // v2->v3
        /*
        public String chat_type;
            public String roomid;
            public int is_block;
        */
//        if (newVersion == 3) {
//            db.execSQL("ALTER TABLE "+ Messages.TABLE +" ADD COLUMN "+ Messages.KEY_chat_type +" TEXT");
//            db.execSQL("ALTER TABLE "+ Messages.TABLE +" ADD COLUMN "+ Messages.KEY_roomid +" TEXT");
//            db.execSQL("ALTER TABLE "+ Messages.TABLE +" ADD COLUMN "+ Messages.KEY_is_block +" INTEGER");
//        }
        //onCreate(db);
    }
}
