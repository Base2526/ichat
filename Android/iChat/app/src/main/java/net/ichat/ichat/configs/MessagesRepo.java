package net.ichat.ichat.configs;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import net.ichat.ichat.sqlite.DBHelper;

import java.util.ArrayList;

/**
 * Created by somkid on 13/10/2017 AD.
 */

public class MessagesRepo {
    private String TAG = MessagesRepo.class.getName();

    private Context context;
    private DBHelper dbHelper;

    public MessagesRepo(Context context){
        this.context = context;
        dbHelper = new DBHelper(context);
    }

    /*
     * check is object == object_id ?
     */
    public int check(String object_id){
        SQLiteDatabase db = dbHelper.getReadableDatabase();
        String selectQuery =  "SELECT  *  FROM " + Messages.TABLE
                + " WHERE " +
                Messages.KEY_object_id + "=?";// It's a good practice to use parameter ?, instead of concatenate string

        Cursor cursor = db.rawQuery(selectQuery, new String[] { String.valueOf(object_id) } );
        int id = cursor.getCount();

        db.close();
        cursor.close();

        return id;
    }

    public ArrayList<Messages> getMessagesByChatId(String chat_id) {
        //Open connection to read only
        SQLiteDatabase db = dbHelper.getReadableDatabase();
        String selectQuery =  "SELECT  * FROM " + Messages.TABLE ;

        Cursor cursor = db.rawQuery(selectQuery, null );
        ArrayList<Messages> mList = new ArrayList<Messages>();
        if (cursor.moveToFirst()) {
            do {
                Messages _item = new Messages();
                _item.chat_id    = cursor.getString(cursor.getColumnIndex(Messages.KEY_chat_id));
                _item.object_id  = cursor.getString(cursor.getColumnIndex(Messages.KEY_object_id));
                _item.sender_id  = cursor.getString(cursor.getColumnIndex(Messages.KEY_sender_id));
                _item.receive_id = cursor.getString(cursor.getColumnIndex(Messages.KEY_receive_id));
                _item.text       = cursor.getString(cursor.getColumnIndex(Messages.KEY_text));
                _item.type       = cursor.getString(cursor.getColumnIndex(Messages.KEY_type));
                _item.status     = cursor.getString(cursor.getColumnIndex(Messages.KEY_status));
                _item.reader     = cursor.getString(cursor.getColumnIndex(Messages.KEY_reader));
                _item.create     = cursor.getString(cursor.getColumnIndex(Messages.KEY_create));
                _item.update     = cursor.getString(cursor.getColumnIndex(Messages.KEY_update));

                mList.add(_item);
            } while (cursor.moveToNext());
        }

        cursor.close();
        db.close();
        return mList;
    }

    public int insert(Messages ms) {
        //Open connection to write data
        SQLiteDatabase db = dbHelper.getWritableDatabase();
        // db.beginTransaction();

        ContentValues values = new ContentValues();

        values.put(Messages.KEY_chat_id,    ms.chat_id);
        values.put(Messages.KEY_object_id,  ms.object_id);
        values.put(Messages.KEY_sender_id,  ms.sender_id);
        values.put(Messages.KEY_receive_id, ms.receive_id);
        values.put(Messages.KEY_text,       ms.text);
        values.put(Messages.KEY_type,       ms.type);
        values.put(Messages.KEY_status,     ms.status);
        values.put(Messages.KEY_reader,     ms.reader);
        values.put(Messages.KEY_create,     ms.create);
        values.put(Messages.KEY_update,     ms.update);

        long id = db.insert(Messages.TABLE, null, values);
        db.close();

        return (int) id;
    }

    public int update(Messages ms) {
        SQLiteDatabase db = dbHelper.getWritableDatabase();
        ContentValues values = new ContentValues();

        values.put(Messages.KEY_chat_id,    ms.chat_id);
        values.put(Messages.KEY_object_id,  ms.object_id);
        values.put(Messages.KEY_sender_id,  ms.sender_id);
        values.put(Messages.KEY_receive_id, ms.receive_id);
        values.put(Messages.KEY_text,       ms.text);
        values.put(Messages.KEY_type,       ms.type);
        values.put(Messages.KEY_status,     ms.status);
        values.put(Messages.KEY_reader,     ms.reader);
        values.put(Messages.KEY_create,     ms.create);
        values.put(Messages.KEY_update,     ms.update);

        // It's a good practice to use parameter ?, instead of concatenate string
        int id =  db.update(Messages.TABLE, values, Messages.KEY_object_id + "= ?", new String[] { String.valueOf(ms.object_id) });
        db.close(); // Closing database connection

        return id;
    }

    public int delete(String objectId) {
        SQLiteDatabase db = dbHelper.getWritableDatabase();
        // It's a good practice to use parameter ?, instead of concatenate string
        int id = db.delete(Messages.TABLE, Messages.KEY_object_id + "= ?", new String[] { String.valueOf(objectId) });
        db.close(); // Closing database connection

        return id;
    }

    public int deleteAll() {
        SQLiteDatabase db = dbHelper.getWritableDatabase();
        // It's a good practice to use parameter ?, instead of concatenate string
        int id =  db.delete(Messages.TABLE, null, null);
        db.close(); // Closing database connection

        return id;
    }
}