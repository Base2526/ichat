package net.ichat.ichat.configs;

/**
 * Created by Somkid on 5/27/2017 AD.
 */
public class Configs {

    public static final boolean DEBUG = Boolean.parseBoolean("true");
    public static final String APPLICATION_ID = "satitpatumwan.test";
    public static final String BUILD_TYPE = "debug";
    public static final String FLAVOR = "";
    public static final int VERSION_CODE = 1;
    public static final String VERSION_NAME = "1.0";

    public static String API_URI        = "http://128.199.247.179";
    public static String END_POINT      = "/api";
    public static int SPLASH_TIME_OUT   = 2000;


    public static String DATA       = "DATA";
    public static String USER       = "USER";
    public static String PROFILES   = "profiles";
    public static String FRIENDS    = "friends";
    public static String FAVORITES  = "favorites";
    public static String GROUPS     = "groups";

    // self.ANNMOUSU               = [NSString stringWithFormat:@"%@%@", self.END_POINT, @"/annmousu"];
    public static String ANNMOUSU                  = API_URI + END_POINT +"/annmousu";
    public static String UPDATE_PICTURE_PROFILE    = API_URI + END_POINT +"/update_picture_profile";
    public static String UPDATE_MY_PROFILE         = API_URI + END_POINT +"/update_my_profile";
    public static String CREATE_GROUP_CHAT         = API_URI + END_POINT +"/create_group_chat";
    public static String UPDATE_GROUP_CHAT         = API_URI + END_POINT +"/update_profile_group";
    public static String GROUP_INVITE_NEW_MEMBERS  = API_URI + END_POINT +"/group_invite_new_members";


    // DB

}
