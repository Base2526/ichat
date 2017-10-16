package net.ichat.ichat.service;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.preference.PreferenceManager;
import android.provider.Settings;
import android.util.Base64;
import android.util.Log;

import net.ichat.ichat.application.App;
import net.ichat.ichat.configs.Configs;
import net.ichat.ichat.utils.JsonUtils;

import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

import okhttp3.FormBody;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

/**
 * Created by Somkid on 5/28/2017 AD.
 */
public class Services {
    private String TAG = Services.class.getName();

    private Context context;

    public Services(Context pcontext) {
        context = pcontext;
    }


    public Object[] onANNMOUSU() {
        Object[] result = new Object[4];

        try {
            String udid = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
            String platform = "android";
            String bundleidentifier = Configs.APPLICATION_ID;
            String version = "1.0";

            try {
                PackageInfo pInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
                version = pInfo.versionName;
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }

            // https://stackoverflow.com/questions/24233632/how-to-add-parameters-to-api-http-post-using-okhttp-library-in-android
            RequestBody formBody = new FormBody.Builder()
                    .add("udid", udid)
                    .add("platform", platform)
                    .add("bundleidentifier", bundleidentifier)
                    .add("version", version)
                    .build();

            OkHttpClient client = new OkHttpClient();
            Request request = new Request.Builder()
                    .url(Configs.ANNMOUSU)
                    .post(formBody)
                    .build();

            Response response = client.newCall(request).execute();

            JSONObject jsonresult = new JSONObject(response.body().string());

            if (jsonresult.getBoolean("result")) {
                result[0] = true;

                SharedPreferences appSharedPrefs = PreferenceManager.getDefaultSharedPreferences(context.getApplicationContext());
                SharedPreferences.Editor prefsEditor = appSharedPrefs.edit();
                prefsEditor.putString(Configs.USER, jsonresult.getJSONObject("data").toString());
                prefsEditor.commit();

                ((App) context.getApplicationContext()).synchronizeDataLogin();
            } else {
                result[0] = false;
            }
        } catch (Exception ex) {
            Log.e(TAG, ex.toString());

            result[0] = false;
            result[1] = ex.toString();
        }
        return result;
    }

    public Object[] onUpdatePictureProfile(Bitmap bmp) {
        Object[] result = new Object[4];

        try {
            String udid = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
            String platform = "android";
            String bundleidentifier = Configs.APPLICATION_ID;
            String version = "1.0";

            try {
                PackageInfo pInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
                version = pInfo.versionName;
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }

            // https://stackoverflow.com/questions/24233632/how-to-add-parameters-to-api-http-post-using-okhttp-library-in-android
            /*
            RequestBody formBody = new FormBody.Builder()
                    .add("udid", udid)
                    .add("platform", platform)
                    .add("bundleidentifier", bundleidentifier)
                    .add("version", version)
                    .build();
            */


            /**
             * OKHTTP3
             */
            // File sourceFile = new File("ImagePath");


            final MediaType MEDIA_TYPE_PNG = MediaType.parse("image/png");
            RequestBody formBody = new MultipartBody.Builder()
                    .setType(MultipartBody.FORM)
                    .addFormDataPart("image", JsonUtils.BitmapToString(bmp))
                    // .addFormDataPart("result", "my_image")
                    .addFormDataPart("uid", ((App) context.getApplicationContext()).getUserId())
                    .build();


            OkHttpClient client = new OkHttpClient();
            Request request = new Request.Builder()
                    .url(Configs.UPDATE_PICTURE_PROFILE)
                    .post(formBody)
                    .build();

            Response response = client.newCall(request).execute();

            JSONObject jsonresult = new JSONObject(response.body().string());

            if (jsonresult.getBoolean("result")) {
                result[0] = true;
                result[1] = jsonresult.getString("url");

//                SharedPreferences appSharedPrefs = PreferenceManager.getDefaultSharedPreferences(context.getApplicationContext());
//                SharedPreferences.Editor prefsEditor = appSharedPrefs.edit();
//                prefsEditor.putString(Configs.USER, jsonresult.getJSONObject("data").toString());
//                prefsEditor.commit();
            } else {
                result[0] = false;
            }
        } catch (Exception ex) {
            Log.e(TAG, ex.toString());

            result[0] = false;
            result[1] = ex.toString();
        }
        return result;
    }

    public Object[] onUpdateMyProfile(String name, String status_mss) {
        Object[] result = new Object[4];

        try {
            String udid = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
            String platform = "android";
            String bundleidentifier = Configs.APPLICATION_ID;
            String version = "1.0";

            try {
                PackageInfo pInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
                version = pInfo.versionName;
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }

            // https://stackoverflow.com/questions/24233632/how-to-add-parameters-to-api-http-post-using-okhttp-library-in-android
            RequestBody formBody = new FormBody.Builder()
                    .add("uid", ((App) context.getApplicationContext()).getUserId())
                    .add("name", name)
                    .add("status_message", status_mss)
                    .build();

            OkHttpClient client = new OkHttpClient();
            Request request = new Request.Builder()
                    .url(Configs.UPDATE_MY_PROFILE)
                    .post(formBody)
                    .build();

            Response response = client.newCall(request).execute();

            JSONObject jsonresult = new JSONObject(response.body().string());

            if (jsonresult.getBoolean("result")) {
                result[0] = true;

            } else {
                result[0] = false;
            }
        } catch (Exception ex) {
            Log.e(TAG, ex.toString());

            result[0] = false;
            result[1] = ex.toString();
        }
        return result;
    }

    public String getToString(String[] arrayData) {
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0; i < arrayData.length; i++) {
            stringBuilder.append(arrayData[i]);
            if (i < arrayData.length - 1) {
                stringBuilder.append(",");
            }
        }
        return stringBuilder.toString();
    }

    public Object[] onCreateGroup(Bitmap bitmap, String name, String[] members) {
        Object[] result = new Object[4];

        try {
//            RequestBody formBody = new MultipartBody.Builder()
//                    .setType(MultipartBody.FORM)
//                    .addFormDataPart("image", JsonUtils.BitmapToString(bitmap))
//                    .addFormDataPart("uid", ((App)context.getApplicationContext()).getUserId())
//                    .addFormDataPart("name", name)
//                    .addFormDataPart("members", getToString(members))
//                    .build();

            MultipartBody.Builder buildernew = new MultipartBody.Builder()
                    .setType(MultipartBody.FORM)
                    .addFormDataPart("image", JsonUtils.BitmapToString(bitmap))
                    .addFormDataPart("uid", ((App) context.getApplicationContext()).getUserId())
                    .addFormDataPart("name", name);

            for (int i = 0; i < members.length; i++) {
                buildernew.addFormDataPart("members[]", members[i]);
            }

            MultipartBody requestBody = buildernew.build();

            OkHttpClient client = new OkHttpClient();
            Request request = new Request.Builder()
                    .url(Configs.CREATE_GROUP_CHAT)
                    .post(requestBody)
                    .build();

            Response response = client.newCall(request).execute();
            JSONObject jsonresult = new JSONObject(response.body().string());

            if (jsonresult.getBoolean("result")) {
                result[0] = true;
//                result[1] = jsonresult.getString("url");
//                SharedPreferences appSharedPrefs = PreferenceManager.getDefaultSharedPreferences(context.getApplicationContext());
//                SharedPreferences.Editor prefsEditor = appSharedPrefs.edit();
//                prefsEditor.putString(Configs.USER, jsonresult.getJSONObject("data").toString());
//                prefsEditor.commit();
            } else {
                result[0] = false;
            }
        } catch (Exception ex) {
            Log.e(TAG, ex.toString());

            result[0] = false;
            result[1] = ex.toString();
        }
        return result;
    }

    public Object[] onUpdateGroup(String group_id, String name, Bitmap bitmap) {
        Object[] result = new Object[4];

        try {
//            RequestBody formBody = new MultipartBody.Builder()
//                    .setType(MultipartBody.FORM)
//                    .addFormDataPart("image", JsonUtils.BitmapToString(bitmap))
//                    .addFormDataPart("uid", ((App)context.getApplicationContext()).getUserId())
//                    .addFormDataPart("name", name)
//                    .addFormDataPart("members", getToString(members))
//                    .build();

            MultipartBody.Builder buildernew = new MultipartBody.Builder()
                    .setType(MultipartBody.FORM)
                    .addFormDataPart("uid", ((App) context.getApplicationContext()).getUserId())
                    .addFormDataPart("group_id", group_id)
                    .addFormDataPart("image", JsonUtils.BitmapToString(bitmap))
                    .addFormDataPart("name", name);

            MultipartBody requestBody = buildernew.build();

            OkHttpClient client = new OkHttpClient();
            Request request = new Request.Builder()
                    .url(Configs.UPDATE_GROUP_CHAT)
                    .post(requestBody)
                    .build();

            Response response = client.newCall(request).execute();
            JSONObject jsonresult = new JSONObject(response.body().string());

            if (jsonresult.getBoolean("result")) {
                result[0] = true;
//                result[1] = jsonresult.getString("url");
//                SharedPreferences appSharedPrefs = PreferenceManager.getDefaultSharedPreferences(context.getApplicationContext());
//                SharedPreferences.Editor prefsEditor = appSharedPrefs.edit();
//                prefsEditor.putString(Configs.USER, jsonresult.getJSONObject("data").toString());
//                prefsEditor.commit();
            } else {
                result[0] = false;
            }
        } catch (Exception ex) {
            Log.e(TAG, ex.toString());

            result[0] = false;
            result[1] = ex.toString();
        }
        return result;
    }

    public Object[] onGroupInviteNewMembers(String group_id, String[] members) {
        Object[] result = new Object[4];

        try {
            MultipartBody.Builder buildernew = new MultipartBody.Builder()
                    .setType(MultipartBody.FORM)
                    .addFormDataPart("uid", ((App) context.getApplicationContext()).getUserId())
                    .addFormDataPart("group_id", group_id);

            for (int i = 0; i < members.length; i++) {
                buildernew.addFormDataPart("members[]", members[i]);
            }

            MultipartBody requestBody = buildernew.build();

            OkHttpClient client = new OkHttpClient();
            Request request = new Request.Builder()
                    .url(Configs.GROUP_INVITE_NEW_MEMBERS)
                    .post(requestBody)
                    .build();

            Response response = client.newCall(request).execute();
            JSONObject jsonresult = new JSONObject(response.body().string());

            if (jsonresult.getBoolean("result")) {
                result[0] = true;
//                result[1] = jsonresult.getString("url");
//                SharedPreferences appSharedPrefs = PreferenceManager.getDefaultSharedPreferences(context.getApplicationContext());
//                SharedPreferences.Editor prefsEditor = appSharedPrefs.edit();
//                prefsEditor.putString(Configs.USER, jsonresult.getJSONObject("data").toString());
//                prefsEditor.commit();
            } else {
                result[0] = false;
            }
        } catch (Exception ex) {
            Log.e(TAG, ex.toString());

            result[0] = false;
            result[1] = ex.toString();
        }
        return result;
    }
}