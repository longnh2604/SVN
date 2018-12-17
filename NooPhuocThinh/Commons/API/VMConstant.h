//
//  VMConstant.h
//  NooPhuocThinh
//
//  Created by Long Nguyen on 12/16/13.
//  Copyright (c) 2013 MAC_OSX. All rights reserved.
//


typedef NS_ENUM(NSInteger, FontSizeChangeType)
{
    FontSizeChangeTypeIncrease,
    FontSizeChangeTypeDecrease,
    FontSizeChangeTypeNone
};


#ifndef NooPhuocThinh_VMConstant_h
#define NooPhuocThinh_VMConstant_h
#endif

typedef enum {
    
    PlatformAndroid = 2,
    PlatformIOS = 4
    
}PlatformOS;

typedef enum {
    
    UpdateSourceViaAppStore,
    UpdateSourceViaWeb
    
} UpdateSource;

typedef enum {
    
    ContentTypeIDSinger = 9,
    ContentTypeIDSchedule = 11,
    ContentTypeIDMusic = 8,
    ContentTypeIDNews = 7,
    ContentTypeIDEvent = 10,
    ContentTypeIDAllVideo = 1214,
    ContentTypeIDVideo = 12,
    ContentTypeIDUnofficialVideo = 14,
    ContentTypeIDPhoto = 13,
    ContentTypeIDStore = 15
    
}ContentTypeID;


typedef enum {
    
 //-- news
 CategoryIDNewsNooPhuocThinh = 1,
 CategoryIDNewsTinTuc = 5,
 
 //-- videos
 CategoryIDVideosUnOfficialBehindScene= 7,
 CategoryIDVideosUnOfficialFanCam= 8
    
}CategoryID;

//-- type message
typedef enum {
    VMTypeMessageOk, // message have a button which name is OK
    VMTypeMessageOkAction,// message have a button which name is OK and implement action
    VMTypeMessageYesNo, //message have twos butotn which name is YES and NO,
    VMTypeMessageClose,
    VMTypeMessageUpdateNowUpdateLater,
    VMTypeMessageDownloadNowCancel,
    VMTypeMessageActiveDevice,
    VMTypeMessageDeleteOldFileInNote  // delete previous saved photo or voice memo when user start click choose them
} VMTypeMessage;

#define kTitleMessageApp @"Thông Báo"
#define userDefault [NSUserDefaults standardUserDefaults]

//----------------------------------------

/*** SETTING APP ***/

//#define SINGER_ID                                       @"639"
//#define PRODUCTION_ID                                   @"48"
//#define PRODUCTION_VERSION                              ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])
//#define DISTRIBUTOR_ID                                  @"25"
//#define DISTRIBUTOR_CHANNEL_ID                          @"15"
//#define CONTENT_PROVIDER_ID                             @""

#define SINGER_ID                                       @"723"
#define PRODUCTION_ID                                   @"522"
#define PRODUCTION_VERSION                              ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])
#define DISTRIBUTOR_ID                                  @"62"
#define DISTRIBUTOR_CHANNEL_ID                          @"66"
#define CONTENT_PROVIDER_ID                             @""

#define APP_ID                                          @"app_id"
#define APP_VERSION                                     @"app_version"
#define APP_RUN_FIRST                                   @"app_run_first"
#define SETTING_USER_TYPE_LIST                          @"setting_user_type_list"
#define CLEAR_CACHE_VERSION                             @"clear_cache_version"

#define URL_APP_STORE ([[NSUserDefaults standardUserDefaults] objectForKey:@"facebook_link_share"])

//#define URL_APP_STORE                                   @"http://myidol.info"
#define URL_DieuKhoan                                   @"http://myidol.info/site/dieukhoansudung"
#define API_DEF @"api_definition" //longnh
#define API_CONF @"api_config"

//add by TuanNM: luu log local
#define LOCAL_LOG @"local_log"
#define LOG_SIZE 32768

//************************ API Charging qua 3g *********************//

// DONGNHI:		agency_id=12, secretKey="8A3C4F4BCF23F44E67E853CA62E74CED"
// NOOPHUOCTHINH: 	agency_id=13, secretKey="E35A49809A0B55074647B77B362C6688"

#define KEY_SINGER_NAME             ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"MSSingerName"])//@"NOOPHUOCTHINH"
#define KEY_agency_id               ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"MSAgencyID"])//@"13"
#define KEY_secretKey               ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"MSSecretKey"])//@"E35A49809A0B55074647B77B362C6688"
#define KEY_FB_APP_ID             ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"FacebookAppID"])//@"NOOPHUOCTHINH"
#define KEY_FB_SINGER_DISPLAY_NAME             ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"FacebookDisplayName"])//@"NOOPHUOCTHINH"


#define TITLE_Registed              @"Số điện thoại đã được đăng ký với 1 acount FB khác. Loggin bằng account FB trước đó hoặc liên hệ với ban quản trị."
#define TITLE_Registed_ExistFB      @"Tài khoản facebook này đã được đăng ký trên hệ thống, xin vui lòng đăng ký với một tài khoản facebook khác."
#define TITLE_Registed_Error        @"Quá trình đăng ký thất bại, xin vui lòng thử lại sau."
#define TITLE_InputPhoneNumber      @"Bạn vui lòng nhập số điện thoại và mã xác nhận."

#define TITLE_UpdateUserVip         @"Bạn cần nâng cấp lên tài khoản VIP để tiếp tục sử dụng dịch vụ này."

#define TITLE_FailPhoneNumber       @"Số điện thoại nhập vào không đúng, xin vui lòng nhập lại."
#define TITLE_EmptyPhoneNumber      @"Xin vui lòng nhập số điện thoại."
#define TITLE_FailVerify            @"Bạn vui lòng nhập đầy đủ thông tin yêu cầu."
#define TITLE_SearchEmtry           @"Xin vui lòng nhập nội dung bạn muốn tìm kiếm."
#define TITLE_SendSMSEmtry          @"Bạn vui lòng chọn trong danh sách bên dưới."

//-- Title default
#define Key_Singer_Notice_Default       @"Singer_Notice_Default"
#define TITLE_Singer_Notice_Default     @"Chúc bạn và gia đình năm mới An Khang, Thịnh Vượng"
#define TITLE_NoData_Default            @"Dữ liệu đang được cập nhật"
#define TITLE_NoCommentFanZone_Default  @"Không tìm thấy thông điệp nào, xin vui lòng nhấn nút Refresh ở góc trên cùng bên phải để thử tải lại."
#define TITLE_System_Error              @"Lỗi kết nối, xin vui lòng thử lại"
#define TITLE_Facebook_Error            @"Lỗi kết nối facebook, xin vui lòng thử lại"

//-- singer Info
#define Key_Singer_Id                   @"Singer_Id"
#define Key_Singer_Name                 @"Singer_Name"
#define Key_Singer_Telco_code           @"Key_Singer_Telco_code"
#define Key_Singer_Agency_id            @"Key_Singer_Agency_id"
#define Key_Singer_Secret_key           @"Key_Singer_Secret_key"

//-- singer_fanzone
#define Key_Default_Message             @"Key_Default_Message"
#define Key_Refresh_Time                @"Key_Refresh_Time"
#define Key_Refresh_Now                 @"Key_Refresh_Now" //longnh: them vao de refresh ngay lap tuc neu =1

//-- feeds app
#define Key_Feed                        @"Key_Feed"
#define Title_NoData_Feed               @"Dữ liệu đang được cập nhật"

//-- free app
#define Key_Is_Free                     @"Key_Is_Free"
#define Key_Free_Time                   @"Key_Free_Time"
#define Key_Free_Regist_Message         @"Key_Free_Regist_Message"
#define Key_Free_Login_Api              @"Key_Free_Login_Api"


//-- Trailer info
#define Key_Trailer_Info_Video          @"Trailer_Info_Video"
#define Key_Trailer_Info_Music          @"Trailer_Info_Music"
#define TITLE_Message_Trailer_Info      @"Message_Trailer_Info"

//-- charg_facebook_info
#define Key_ChargFacebook_IsChargFacebookOn         @"Key_ChargFacebook_IsChargFacebookOn"
#define Key_ChargFacebook_MessageUpdateUserInfo     @"Key_ChargFacebook_MessageUpdateUserInfo"

//-- invite
#define Key_Invite_Message_Default      @"Key_Invite_Message_Default"


//-- download Photo
#define Key_downloadable_photo_number                        @"Key_downloadable_photo_number"
#define Key_downloadable_photo_start_time                    @"Key_downloadable_photo_start_time"
#define Key_downloadable_photo_period_time                   @"Key_downloadable_photo_period_time"
#define Key_downloadable_photo_message_wranning              @"Key_downloadable_photo_message_wranning"

//-- download Video
#define Key_downloadable_video_nubmer                        @"Key_downloadable_video_nubmer"
#define Key_downloadable_video_start_time                    @"Key_downloadable_video_start_time"
#define Key_downloadable_video_period_time                   @"Key_downloadable_video_period_time"
#define Key_downloadable_video_message_wranning              @"Key_downloadable_video_message_wranning"

//-- download Music
#define Key_downloadable_music_nubmer                        @"Key_downloadable_music_nubmer"
#define Key_downloadable_music_start_time                    @"Key_downloadable_music_start_time"
#define Key_downloadable_music_period_time                   @"Key_downloadable_music_period_time"
#define Key_downloadable_music_message_wranning              @"Key_downloadable_music_message_wranning"


//-- ringback_tone
#define Key_ringbackCode                        @"Key_ringbackCode"
#define Key_ringbackName                        @"Key_ringbackName"
#define Key_ringbackMessage                     @"Key_ringbackMessage"
#define Key_ringbackCommand_gateway             @"Key_ringbackCommand_gateway"
#define Key_ringbackCommand_body                @"Key_ringbackCommand_body"
#define Key_ringbackApi                         @"Key_ringbackApi"


#define Key_is_lock_device                      @"Key_is_lock_device"

//-- SMS Register
#define Key_telco_id                            @"Key_telco_id"
#define Key_telco_global_code                   @"Key_telco_global_code"
#define Key_telco_key                           @"Key_telco_key"
#define Key_telco_name                          @"Key_telco_name"
#define Key_payment_type                        @"Key_payment_type"
#define Key_wifi_payment_type                   @"Key_wifi_payment_type"
#define Key_mobile_network_payment_type         @"Key_mobile_network_payment_type"
#define Key_telco_phone_number_list             @"Key_telco_phone_number_list"
#define Key_get_phone_number_service_api        @"Key_get_phone_number_service_api"
#define Key_check_active_account                @"Key_check_active_account"

//-- SMS Dang Ky
#define Key_sms_DK_id                           @"Key_sms_DK_id"
#define Key_sms_DK_body                         @"Key_sms_DK_body"
#define Key_sms_DK_name                         @"Key_sms_DK_name"
#define Key_sms_DK_command_gateway              @"Key_sms_DK_command_gateway"
#define Key_sms_DK_command_body                 @"Key_sms_DK_command_body"
#define Key_sms_DK_message                      @"Key_sms_DK_message"
#define Key_sms_DK_message_verify               @"Key_sms_DK_message_verify"
#define Key_sms_DK_success_message              @"Key_sms_DK_success_message"
#define Key_sms_DK_fail_message                 @"Key_sms_DK_fail_message"

//-- SMS Huy
#define Key_sms_Huy_id                           @"Key_sms_Huy_id"
#define Key_sms_Huy_body                         @"Key_sms_Huy_body"
#define Key_sms_Huy_name                         @"Key_sms_Huy_name"
#define Key_sms_Huy_command_gateway              @"Key_sms_Huy_command_gateway"
#define Key_sms_Huy_command_body                 @"Key_sms_Huy_command_body"
#define Key_sms_Huy_message                      @"Key_sms_Huy_message"
#define Key_sms_Huy_message_verify               @"Key_sms_Huy_message_verify"
#define Key_sms_Huy_success_message              @"Key_sms_Huy_success_message"
#define Key_sms_Huy_fail_message                 @"Key_sms_Huy_fail_message"

//-- SMS Nap Tien
#define Key_sms_Nap_id                           @"Key_sms_Nap_id"
#define Key_sms_Nap_body                         @"Key_sms_Nap_body"
#define Key_sms_Nap_name                         @"Key_sms_Nap_name"
#define Key_sms_Nap_command_gateway              @"Key_sms_Nap_command_gateway"
#define Key_sms_Nap_command_body                 @"Key_sms_Nap_command_body"
#define Key_sms_Nap_message                      @"Key_sms_Nap_message"
#define Key_sms_Nap_message_verify               @"Key_sms_Nap_message_verify"
#define Key_sms_Nap_success_message              @"Key_sms_Nap_success_message"
#define Key_sms_Nap_fail_message                 @"Key_sms_Nap_fail_message"

//-- SMS Dang Ky Chung Thuc
#define Key_sms_DKCT_id                           @"Key_sms_DKCT_id"
#define Key_sms_DKCT_body                         @"Key_sms_DKCT_body"
#define Key_sms_DKCT_name                         @"Key_sms_DKCT_name"
#define Key_sms_DKCT_command_gateway              @"Key_sms_DKCT_command_gateway"
#define Key_sms_DKCT_command_body                 @"Key_sms_DKCT_command_body"
#define Key_sms_DKCT_api                          @"Key_sms_DKCT_api"
#define Key_sms_DKCT_message                      @"Key_sms_DKCT_message"
#define Key_sms_DKCT_message_verify               @"Key_sms_DKCT_message_verify"
#define Key_sms_DKCT_success_message              @"Key_sms_DKCT_success_message"
#define Key_sms_DKCT_fail_message                 @"Key_sms_DKCT_fail_message"

#define Key_wifi_nosim_DKCT_api                         @"Key_wifi_nosim_DKCT_api"
#define Key_wifi_nosim_DKCT_message                     @"Key_wifi_nosim_DKCT_message"
#define Key_wifi_nosim_command_gateway_get_password     @"Key_wifi_nosim_command_gateway_get_password"
#define Key_wifi_nosim_command_body_get_password        @"Key_wifi_nosim_command_body_get_password"

#define Key_Message_System_Error                        @"Key_Message_System_Error"

//-- SUB SMS Dang Ky
#define Key_subSms_DK_id                           @"Key_subSms_DK_id"
#define Key_subSms_DK_body                         @"Key_subSms_DK_body"
#define Key_subSms_DK_name                         @"Key_subSms_DK_name"
#define Key_subSms_DK_command_gateway              @"Key_subSms_DK_command_gateway"
#define Key_subSms_DK_command_body                 @"Key_subSms_DK_command_body"
#define Key_subSms_DK_message                      @"Key_subSms_DK_message"
#define Key_subSms_DK_message_verify               @"Key_subSms_DK_message_verify"
#define Key_subSms_DK_success_message              @"Key_subSms_DK_success_message"
#define Key_subSms_DK_fail_message                 @"Key_subSms_DK_fail_message"

//-- SUB SMS Huy
#define Key_subSms_Huy_id                           @"Key_subSms_Huy_id"
#define Key_subSms_Huy_body                         @"Key_subSms_Huy_body"
#define Key_subSms_Huy_name                         @"Key_subSms_Huy_name"
#define Key_subSms_Huy_command_gateway              @"Key_subSms_Huy_command_gateway"
#define Key_subSms_Huy_command_body                 @"Key_subSms_Huy_command_body"
#define Key_subSms_Huy_message                      @"Key_subSms_Huy_message"
#define Key_subSms_Huy_message_verify               @"Key_subSms_Huy_message_verify"
#define Key_subSms_Huy_success_message              @"Key_subSms_Huy_success_message"
#define Key_subSms_Huy_fail_message                 @"Key_subSms_Huy_fail_message"

//-- SUB SMS Nap Tien
#define Key_subSms_Nap_id                           @"Key_subSms_Nap_id"
#define Key_subSms_Nap_body                         @"Key_subSms_Nap_body"
#define Key_subSms_Nap_name                         @"Key_subSms_Nap_name"
#define Key_subSms_Nap_command_gateway              @"Key_subSms_Nap_command_gateway"
#define Key_subSms_Nap_command_body                 @"Key_subSms_Nap_command_body"
#define Key_subSms_Nap_message                      @"Key_subSms_Nap_message"
#define Key_subSms_Nap_message_verify               @"Key_subSms_Nap_message_verify"
#define Key_subSms_Nap_success_message              @"Key_subSms_Nap_success_message"
#define Key_subSms_Nap_fail_message                 @"Key_subSms_Nap_fail_message"

//-- SUB SMS Dang Ky Chung Thuc
#define Key_subSms_DKCT_id                           @"Key_subSms_DKCT_id"
#define Key_subSms_DKCT_body                         @"Key_subSms_DKCT_body"
#define Key_subSms_DKCT_name                         @"Key_subSms_DKCT_name"
#define Key_subSms_DKCT_command_gateway              @"Key_subSms_DKCT_command_gateway"
#define Key_subSms_DKCT_command_body                 @"Key_subSms_DKCT_command_body"
#define Key_subSms_DKCT_api                          @"Key_subSms_DKCT_api"
#define Key_subSms_DKCT_message                      @"Key_subSms_DKCT_message"
#define Key_subSms_DKCT_message_verify               @"Key_subSms_DKCT_message_verify"
#define Key_subSms_DKCT_success_message              @"Key_subSms_DKCT_success_message"
#define Key_subSms_DKCT_fail_message                 @"Key_subSms_DKCT_fail_message"


//-- WAPSUB Dang Ky
#define Key_wapSub_DK_id                           @"Key_wapSub_DK_id"
#define Key_wapSub_DK_body                         @"Key_wapSub_DK_body"
#define Key_wapSub_DK_api                          @"Key_wapSub_DK_api"
#define Key_wapSub_DK_message                      @"Key_wapSub_DK_message"
#define Key_wapSub_DK_message_verify               @"Key_wapSub_DK_message_verify"
#define Key_wapSub_DK_success_message              @"Key_wapSub_DK_success_message"
#define Key_wapSub_DK_fail_message                 @"Key_wapSub_DK_fail_message"

//-- WAPSUB Huy
#define Key_wapSub_Huy_id                           @"Key_wapSub_Huy_id"
#define Key_wapSub_Huy_body                         @"Key_wapSub_Huy_body"
#define Key_wapSub_Huy_api                          @"Key_wapSub_Huy_api"
#define Key_wapSub_Huy_command_gateway              @"Key_wapSub_Huy_command_gateway"
#define Key_wapSub_Huy_command_body                 @"Key_wapSub_Huy_command_body"
#define Key_wapSub_Huy_message                      @"Key_wapSub_Huy_message"
#define Key_wapSub_Huy_message_verify               @"Key_wapSub_Huy_message_verify"
#define Key_wapSub_Huy_success_message              @"Key_wapSub_Huy_success_message"
#define Key_wapSub_Huy_fail_message                 @"Key_wapSub_Huy_fail_message"

//-- WAPCharging Dang Ky
#define Key_wapCharging_DK_id                           @"Key_wapCharging_DK_id"
#define Key_wapCharging_DK_body                         @"Key_wapCharging_DK_body"
#define Key_wapCharging_DK_api                          @"Key_wapCharging_DK_api"
#define Key_wapCharging_DK_message                      @"Key_wapCharging_DK_message"
#define Key_wapCharging_DK_message_verify               @"Key_wapCharging_DK_message_verify"
#define Key_wapCharging_DK_success_message              @"Key_wapCharging_DK_success_message"
#define Key_wapCharging_DK_fail_message                 @"Key_wapCharging_DK_fail_message"

//-- WAPCharging Huy
#define Key_wapCharging_Huy_id                           @"Key_wapCharging_Huy_id"
#define Key_wapCharging_Huy_body                         @"Key_wapCharging_Huy_body"
#define Key_wapCharging_Huy_api                          @"Key_wapCharging_Huy_api"
#define Key_wapCharging_Huy_command_gateway              @"Key_wapCharging_Huy_command_gateway"
#define Key_wapCharging_Huy_command_body                 @"Key_wapCharging_Huy_command_body"
#define Key_wapCharging_Huy_message                      @"Key_wapCharging_Huy_message"
#define Key_wapCharging_Huy_message_verify               @"Key_wapCharging_Huy_message_verify"
#define Key_wapCharging_Huy_success_message              @"Key_wapCharging_Huy_success_message"
#define Key_wapCharging_Huy_fail_message                 @"Key_wapCharging_Huy_fail_message"

//-- NoCharging Dang Ky
#define Key_noCharging_DK_id                           @"Key_noCharging_DK_id"
#define Key_noCharging_DK_body                         @"Key_noCharging_DK_body"
#define Key_noCharging_DK_api                          @"Key_noCharging_DK_api"
#define Key_noCharging_DK_message                      @"Key_noCharging_DK_message"
#define Key_noCharging_DK_message_verify               @"Key_noCharging_DK_message_verify"
#define Key_noCharging_DK_success_message              @"Key_noCharging_DK_success_message"
#define Key_noCharging_DK_fail_message                 @"Key_noCharging_DK_fail_message"

//-- NoCharging Huy
#define Key_noCharging_Huy_id                           @"Key_noCharging_Huy_id"
#define Key_noCharging_Huy_body                         @"Key_noCharging_Huy_body"
#define Key_noCharging_Huy_api                          @"Key_noCharging_Huy_api"
#define Key_noCharging_Huy_command_gateway              @"Key_noCharging_Huy_command_gateway"
#define Key_noCharging_Huy_command_body                 @"Key_noCharging_Huy_command_body"
#define Key_noCharging_Huy_message                      @"Key_noCharging_Huy_message"
#define Key_noCharging_Huy_message_verify               @"Key_noCharging_Huy_message_verify"
#define Key_noCharging_Huy_success_message              @"Key_noCharging_Huy_success_message"
#define Key_noCharging_Huy_fail_message                 @"Key_noCharging_Huy_fail_message"


/*** TIME REFRESH DATA ***/

//-- keys for api and refresh time
#define Key_news_refresh_time                           @"news_refresh_time"
#define Key_news_list_refresh_time                      @"news_list_refresh_time"
#define Key_news_category_refresh_time                  @"news_category_refresh_time"
#define Key_music_refresh_time                          @"music_refresh_time"
#define Key_music_album_refresh_time                    @"music_album_refresh_time"
#define Key_video_refresh_time                          @"video_refresh_time"
#define Key_video_category_refresh_time                 @"video_category_refresh_time"
#define Key_store_refresh_time                          @"store_refresh_time"
#define Key_store_category_refresh_time                 @"store_category_refresh_time"
#define Key_event_refresh_time                          @"event_refresh_time"
#define Key_event_category_refresh_time                 @"event_category_refresh_time"
#define Key_image_refresh_time                          @"image_refresh_time"
#define Key_image_album_refresh_time                    @"image_album_refresh_time"
#define Key_top_user_refresh_time                       @"top_user_refresh_time"
#define Key_singer_info_refresh_time                    @"singer_info_refresh_time"

//-- count time
#define Count_time_news_list_refresh_time                      @"Count_time_news_list_refresh_time"
#define Count_time_news_category_refresh_time                  @"Count_time_news_category_refresh_time"
#define Count_time_music_refresh_time                          @"Count_time_music_refresh_time"
#define Count_time_music_album_refresh_time                    @"Count_time_music_album_refresh_time"
#define Count_time_video_refresh_time                          @"Count_time_video_refresh_time"
#define Count_time_video_category_refresh_time                 @"Count_time_video_category_refresh_time"
#define Count_time_store_refresh_time                          @"Count_time_store_refresh_time"
#define Count_time_store_category_refresh_time                 @"Count_time_store_category_refresh_time"
#define Count_time_event_refresh_time                          @"Count_time_event_refresh_time"
#define Count_time_event_category_refresh_time                 @"Count_time_event_category_refresh_time"
#define Count_time_image_refresh_time                          @"Count_time_image_refresh_time"
#define Count_time_image_album_refresh_time                    @"Count_time_image_album_refresh_time"
#define Count_time_top_user_refresh_time                       @"Count_time_top_user_refresh_time"
#define Count_time_singer_info_refresh_time                    @"Count_time_singer_info_refresh_time"

//Key for ABOUT
#define ABOUT_INFO                                      @"about"
#define ABOUT_INFO_LIKE                                 @"about_like"

//--node
#define Node_news                                       @"news"
#define Node_music                                      @"music"
#define Node_photo                                      @"photo"
#define Node_singer                                      @"singer_info"

/*** IMAGE DEFAULTS ***/

#define IMG_DEFAULT_AVATAR                              @"img_avatar_default.png"

/*** MY ACCOUNT ***/
#define MY_PhonNumber_ID                                @"my_PhonNumber_id"
#define MY_Facebook_ID                                  @"my_facebook_id"
#define MY_Facebook_AccToken                            @"MY_Facebook_AccToken"
#define MY_ACCOUNT_ID                                   @"my_account_id"
#define TEMP_MY_ACCOUNT_ID                              @"TEMP_MY_ACCOUNT_ID"
#define MY_ACCOUNT_INFO                                 @"my_account_info"
#define MY_ACCOUNT_ACCESS_TOKEN_FB                      @"accessToken"
#define MY_STATUS                                       @"my_status"
#define NO_AVATAR                                       @"no_avatar.jpg"
#define USER_POINT                                      @"UserPoints"
#define MOBILE_NUMBER                                   @"PhoneNumberOfUser"

/*** COMMENT, LIKE, VIEW***/
#define TYPE_ID_NEWS                                    @"blog"
#define TYPE_ID_PHOTO                                   @"photo"
#define TYPE_ID_VIDEO                                   @"video"
#define TYPE_ID_EVENT                                   @"event"
#define TYPE_ID_FEED                                    @"feed"
#define TYPE_ID_PHOTO_ALBUM                             @"photo_album"
#define TYPE_ID_MUSIC_SONG                              @"music_song"
#define TYPE_ID_MUSIC_ALBUM                             @"music_album"
#define TYPE_ID_FANZONE                                 @"fanzone"
#define TYPE_ID_FANPAGE                                 @"pages"
#define TYPE_ID_FEED_PAGE                               @"pages_comment"
#define TYPE_ID_FEED_LINK                               @"link"
#define TYPE_ID_FEED_PHOTO                              @"photo"
#define TYPE_ID_FEED_VIDEO                              @"video"

#define kTypeComment                                    0
#define kTypeLike                                       1
#define kTypeUnLike                                     2
#define kTypeView                                       3
#define kTypeShare                                      4
#define kTypeFeed                                       5

/*** FOR DATA BASE ***/
#define DATABASE_NAME                                   @"data.sqlite"
#define DB_TABLE_SHOUTBOXDATA                           @"Comment"
#define DB_TABLE_NEWS                                   @"News"
#define DB_TABLE_CATEGORY_SINGER                        @"CategoryBySinger"
#define DB_TABLE_CATEGORY_VIDEO                         @"CategoryByVideo"
#define DB_TABLE_MUSIC_ALBUM                            @"MusicAlbum"
#define DB_TABLE_MUSIC_TRACK                            @"MusicTrack"

#define DB_TABLE_ALL_VIDEO                              @"AllVideoAlbum"
#define DB_TABLE_VIDEO_OffiCial_ALBUM                   @"VideoOffiCialOfAlbum"
#define DB_TABLE_VIDEO_UnOffiCial_ALBUM                 @"VideoUnOffiCialOfAlbum"

#define DB_TABLE_PHOTO_ALBUM                            @"ListAlbumPhoto"
#define DB_TABLE_PHOTO_DETAILS                          @"ListPhotosInAlbum"
#define DB_TABLE_SCHEDULE                               @"Schedule"
#define DB_TABLE_SINGER_INFO                            @"SingerInfo"
#define DB_TABLE_TOPUSER                                @"TopUser"
#define DB_TABLE_STORE                                  @"Store"

#define DB_TABLE_COMMENT                                @"CacheComment"

#define DB_TABLE_FEED                                   @"ListFeedData"
#define DB_TABLE_PHOTOLIST_FEED                         @"ListPhotoFeedData"
#define DB_TABLE_MEDIA                                  @"Media"

//-- Fanzone
#define kTimeStamp                                      @"time_stamp"

#define TITLE_NETWORK_ERROR             NSLocalizedString(@"Network Error", nil)
#define TITLE_CHECK_NETWORK_ERROR       NSLocalizedString(@"Check your network connection", nil)

//-- AppDelegate
//#define kTrackingId @"UA-50689050-1"
#define kTrackingId ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"MSGoogleAnalyticID"])//@"UA-54082858-1" //longnh

//-- BaseCommentsTableViewController
//#define COLOR_PLAY_CELL_BOLD [UIColor colorWithRed:31/255.0f green:57/255.0f blue:66/255.0f alpha:0.4]
//#define COLOR_PLAY_CELL_REGULAR [UIColor colorWithRed:38/255.0f green:97/255.0f blue:117/255.0f alpha:0.4]

//-- CommentsNewsViewController
#define FONT_SIZE_FOR_COMMENT 14.0f

//-- DetailCommentsViewController
#define FONT_SIZE_FOR_COMMENT_DETAIL 14.0f

//-- DetailsAlbumPhotoViewController
//#define COLOR_PHOTO_HEADER [UIColor colorWithRed:6/255.0f green:6/255.0f blue:6/255.0f alpha:0.6]



//-- FanZoneViewController
#define TIME_REPEATE 30

#if SINGER == 1 //NooPhuocThinh
//-- NewsViewController
    #define COLOR_BG_MENU [UIColor colorWithRed:29/255.0f green:54/255.0f blue:62/255.0f alpha:1]
    #define COLOR_NEWS_CELL_BOLD [UIColor colorWithRed:25/255.0f green:40/255.0f blue:51/255.0f alpha:0.9]
    #define COLOR_NEWS_CELL_REGULAR [UIColor colorWithRed:37/255.0f green:72/255.0f blue:82/255.0f alpha:0.9]
    #define COLOR_SELECT_INDICATOR [UIColor colorWithRed:15.0f/255.0f green:159.0f/255.0f blue:219.0f/255.0f alpha:1.0f]
    #define COLOR_SEPARATOR_CELL [UIColor clearColor]

//-- MusicHomeViewController
    #define COLOR_HOME_CELL_BOLD [UIColor colorWithRed:11/255.0f green:127/255.0f blue:170/255.0f alpha:0.4]
    #define COLOR_HOME_CELL_REGULAR [UIColor colorWithRed:11/255.0f green:127/255.0f blue:170/255.0f alpha:0.2]

//-- MusicPlayViewController
    #define COLOR_PLAY_CELL_BOLD [UIColor colorWithRed:31/255.0f green:57/255.0f blue:66/255.0f alpha:0.4]
    #define COLOR_PLAY_CELL_REGULAR [UIColor colorWithRed:38/255.0f green:97/255.0f blue:117/255.0f alpha:0.4]
//-- MusicAlbumViewController
    #define COLOR_HOME_SEGMENT_BOLD [UIColor colorWithRed:29/255.0f green:54/255.0f blue:62/255.0f alpha:1]

//-- TableScheduleViewController
    #define COLOR_SCHEDULE_CELL_BOLD [UIColor colorWithRed:31/255.0f green:50/255.0f blue:61/255.0f alpha:0.9]
    #define COLOR_SCHEDULE_CELL_REGULAR [UIColor colorWithRed:37/255.0f green:72/255.0f blue:82/255.0f alpha:0.9]

//-- TableStoreViewController
    #define COLOR_CELL_0 [UIColor colorWithRed:37/255.0f green:76/255.0f blue:62/255.0f alpha:0.6]
    #define COLOR_CELL_1 [UIColor colorWithRed:37/255.0f green:63/255.0f blue:54/255.0f alpha:0.6]

//-- DetailsScheduleViewController
    #define COLOR_DETAIL_SCHEDULE_BOLD [UIColor colorWithRed:31/255.0f green:48/255.0f blue:61/255.0f alpha:0.89]
    #define COLOR_DETAIL_SCHEDULE_REGULAR [UIColor colorWithRed:40/255.0f green:54/255.0f blue:65/255.0f alpha:0.89]
    #define COLOR_DETAIL_SCHEDULE_INFO [UIColor colorWithRed:36/255.0f green:74/255.0f blue:62/255.0f alpha:1];
    #define COLOR_SCHEDULE_DETAIL_HEADER [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.3]
//-- DetailsCommentViewController
    #define COLOR_BG_CELL_0 [UIColor colorWithRed:38/255.0f green:75/255.0f blue:87/255.0f alpha:0.89]
    #define COLOR_BG_CELL_1 [UIColor colorWithRed:31/255.0f green:57/255.0f blue:66/255.0f alpha:0.89]
//-- PhotoViewController
#define COLOR_HOME_ALBUM_CELL_BOLD [UIColor colorWithRed:58/255.0f green:55/255.0f blue:55/255.0f alpha:0.6]
#define COLOR_HOME_ALBUM_CELL_REGULAR [UIColor colorWithRed:113/255.0f green:111/255.0f blue:111/255.0f alpha:0.4]
//-- ProfileViewController
#define COLOR_PROFILE_CELL_BOLD [UIColor colorWithRed:36/255.0f green:35/255.0f blue:35/255.0f alpha:0.7]
#define COLOR_PROFILE_CELL_REGULAR [UIColor colorWithRed:58/255.0f green:55/255.0f blue:55/255.0f alpha:0.7]
#define COLOR_BG_HEADER_VIEW [UIColor colorWithRed:127/255.0f green:137/255.0f blue:142/255.0f alpha:1]

//===================================================================================================
#elif SINGER == 2 //BaoThy
//-- NewsViewController
    #define COLOR_BG_MENU [UIColor colorWithRed:82/255.0f green:40/255.0f blue:106/255.0f alpha:1]
    #define COLOR_NEWS_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:31/255.0f green:50/255.0f blue:61/255.0f alpha:0.0]
    #define COLOR_NEWS_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:137/255.0f green:172/255.0f blue:182/255.0f alpha:0.0];
    #define COLOR_SELECT_INDICATOR [UIColor colorWithRed:196.0f/255.0f green:51.0f/255.0f blue:179.0f/255.0f alpha:1.0f]
    #define COLOR_SEPARATOR_CELL [UIColor colorWithRed:189.0f/255.0f green:113.0f/255.0f blue:166.0f/255.0f alpha:1.0f]

//-- MusicHomeViewController
    #define COLOR_HOME_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:11/255.0f green:127/255.0f blue:170/255.0f alpha:0.4]
    #define COLOR_HOME_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:11/255.0f green:127/255.0f blue:170/255.0f alpha:0.2];

//-- MusicPlayViewController
    #define COLOR_PLAY_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:31/255.0f green:57/255.0f blue:66/255.0f alpha:0.4]
    #define COLOR_PLAY_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:38/255.0f green:97/255.0f blue:117/255.0f alpha:0.4];
//-- MusicAlbumViewController
    #define COLOR_HOME_SEGMENT_BOLD [UIColor colorWithRed:82/255.0f green:40/255.0f blue:106/255.0f alpha:1]

//-- TableScheduleViewController
    #define COLOR_SCHEDULE_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:31/255.0f green:50/255.0f blue:61/255.0f alpha:0.9]
    #define COLOR_SCHEDULE_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:37/255.0f green:72/255.0f blue:82/255.0f alpha:0.9]

//-- TableStoreViewController
    #define COLOR_CELL_0 [UIColor clearColor] //[UIColor colorWithRed:37/255.0f green:76/255.0f blue:62/255.0f alpha:0.6]
    #define COLOR_CELL_1 [UIColor clearColor] //[UIColor colorWithRed:37/255.0f green:63/255.0f blue:54/255.0f alpha:0.6]

//-- DetailsScheduleViewController
    #define COLOR_DETAIL_SCHEDULE_BOLD [UIColor clearColor] //[UIColor colorWithRed:31/255.0f green:48/255.0f blue:61/255.0f alpha:0.89]
    #define COLOR_DETAIL_SCHEDULE_REGULAR [UIColor clearColor] //[UIColor colorWithRed:40/255.0f green:54/255.0f blue:65/255.0f alpha:0.89]
    #define COLOR_DETAIL_SCHEDULE_INFO [UIColor clearColor] //[UIColor colorWithRed:36/255.0f green:74/255.0f blue:62/255.0f alpha:1];
    #define COLOR_SCHEDULE_DETAIL_HEADER [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.3]
//-- DetailsCommentViewController
    #define COLOR_BG_CELL_0 [UIColor clearColor] //[UIColor colorWithRed:38/255.0f green:75/255.0f blue:87/255.0f alpha:0.89]
    #define COLOR_BG_CELL_1 [UIColor clearColor] //[UIColor colorWithRed:31/255.0f green:57/255.0f blue:66/255.0f alpha:0.89]
//-- PhotoViewController
#define COLOR_HOME_ALBUM_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:58/255.0f green:55/255.0f blue:55/255.0f alpha:0.6]
#define COLOR_HOME_ALBUM_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:113/255.0f green:111/255.0f blue:111/255.0f alpha:0.4]
//-- ProfileViewController
#define COLOR_PROFILE_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:36/255.0f green:35/255.0f blue:35/255.0f alpha:0.7]
#define COLOR_PROFILE_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:58/255.0f green:55/255.0f blue:55/255.0f alpha:0.7]
#define COLOR_BG_HEADER_VIEW [UIColor clearColor] //[UIColor colorWithRed:127/255.0f green:137/255.0f blue:142/255.0f alpha:1]

//===================================================================================================
#elif SINGER == 3 //Van Mai Huong
    //-- NewsViewController
    #define COLOR_BG_MENU [UIColor colorWithRed:82/255.0f green:40/255.0f blue:106/255.0f alpha:1]
    #define COLOR_NEWS_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:31/255.0f green:50/255.0f blue:61/255.0f alpha:0.0]
    #define COLOR_NEWS_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:137/255.0f green:172/255.0f blue:182/255.0f alpha:0.0];
    #define COLOR_SELECT_INDICATOR [UIColor colorWithRed:196.0f/255.0f green:51.0f/255.0f blue:179.0f/255.0f alpha:1.0f]
    #define COLOR_SEPARATOR_CELL [UIColor colorWithRed:189.0f/255.0f green:113.0f/255.0f blue:166.0f/255.0f alpha:1.0f]

    //-- MusicHomeViewController
    #define COLOR_HOME_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:11/255.0f green:127/255.0f blue:170/255.0f alpha:0.4]
    #define COLOR_HOME_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:11/255.0f green:127/255.0f blue:170/255.0f alpha:0.2];

    //-- MusicPlayViewController
    #define COLOR_PLAY_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:31/255.0f green:57/255.0f blue:66/255.0f alpha:0.4]
    #define COLOR_PLAY_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:38/255.0f green:97/255.0f blue:117/255.0f alpha:0.4];
    //-- MusicAlbumViewController
    #define COLOR_HOME_SEGMENT_BOLD [UIColor colorWithRed:82/255.0f green:40/255.0f blue:106/255.0f alpha:1]

    //-- TableScheduleViewController
    #define COLOR_SCHEDULE_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:31/255.0f green:50/255.0f blue:61/255.0f alpha:0.9]
    #define COLOR_SCHEDULE_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:37/255.0f green:72/255.0f blue:82/255.0f alpha:0.9]

    //-- TableStoreViewController
    #define COLOR_CELL_0 [UIColor clearColor] //[UIColor colorWithRed:37/255.0f green:76/255.0f blue:62/255.0f alpha:0.6]
    #define COLOR_CELL_1 [UIColor clearColor] //[UIColor colorWithRed:37/255.0f green:63/255.0f blue:54/255.0f alpha:0.6]

    //-- DetailsScheduleViewController
    #define COLOR_DETAIL_SCHEDULE_BOLD [UIColor clearColor] //[UIColor colorWithRed:31/255.0f green:48/255.0f blue:61/255.0f alpha:0.89]
    #define COLOR_DETAIL_SCHEDULE_REGULAR [UIColor clearColor] //[UIColor colorWithRed:40/255.0f green:54/255.0f blue:65/255.0f alpha:0.89]
    #define COLOR_DETAIL_SCHEDULE_INFO [UIColor clearColor] //[UIColor colorWithRed:36/255.0f green:74/255.0f blue:62/255.0f alpha:1];
    #define COLOR_SCHEDULE_DETAIL_HEADER [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.3]
    //-- DetailsCommentViewController
    #define COLOR_BG_CELL_0 [UIColor clearColor] //[UIColor colorWithRed:38/255.0f green:75/255.0f blue:87/255.0f alpha:0.89]
    #define COLOR_BG_CELL_1 [UIColor clearColor] //[UIColor colorWithRed:31/255.0f green:57/255.0f blue:66/255.0f alpha:0.89]
    //-- PhotoViewController
    #define COLOR_HOME_ALBUM_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:58/255.0f green:55/255.0f blue:55/255.0f alpha:0.6]
    #define COLOR_HOME_ALBUM_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:113/255.0f green:111/255.0f blue:111/255.0f alpha:0.4]
//-- ProfileViewController
#define COLOR_PROFILE_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:36/255.0f green:35/255.0f blue:35/255.0f alpha:0.7]
#define COLOR_PROFILE_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:58/255.0f green:55/255.0f blue:55/255.0f alpha:0.7]
#define COLOR_BG_HEADER_VIEW [UIColor clearColor] //[UIColor colorWithRed:127/255.0f green:137/255.0f blue:142/255.0f alpha:1]

//===================================================================================================

//===================================================================================================
#elif SINGER == 4 //SongMaCa
//-- NewsViewController
#define COLOR_BG_MENU [UIColor colorWithRed:0.953f green:0.733f blue:0.173f alpha:1.00f]
#define COLOR_NEWS_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:31/255.0f green:50/255.0f blue:61/255.0f alpha:0.0]
#define COLOR_NEWS_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:137/255.0f green:172/255.0f blue:182/255.0f alpha:0.0];
#define COLOR_SELECT_INDICATOR [UIColor colorWithRed:196.0f/255.0f green:51.0f/255.0f blue:179.0f/255.0f alpha:1.0f]
#define COLOR_SEPARATOR_CELL [UIColor colorWithRed:189.0f/255.0f green:113.0f/255.0f blue:166.0f/255.0f alpha:1.0f]

//-- MusicHomeViewController
#define COLOR_HOME_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:11/255.0f green:127/255.0f blue:170/255.0f alpha:0.4]
#define COLOR_HOME_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:11/255.0f green:127/255.0f blue:170/255.0f alpha:0.2];

//-- MusicPlayViewController
#define COLOR_PLAY_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:31/255.0f green:57/255.0f blue:66/255.0f alpha:0.4]
#define COLOR_PLAY_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:38/255.0f green:97/255.0f blue:117/255.0f alpha:0.4];
//-- MusicAlbumViewController
#define COLOR_HOME_SEGMENT_BOLD [UIColor colorWithRed:0.953f green:0.733f blue:0.173f alpha:1.00f]

//-- TableScheduleViewController
#define COLOR_SCHEDULE_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:31/255.0f green:50/255.0f blue:61/255.0f alpha:0.9]
#define COLOR_SCHEDULE_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:37/255.0f green:72/255.0f blue:82/255.0f alpha:0.9]

//-- TableStoreViewController
#define COLOR_CELL_0 [UIColor clearColor] //[UIColor colorWithRed:37/255.0f green:76/255.0f blue:62/255.0f alpha:0.6]
#define COLOR_CELL_1 [UIColor clearColor] //[UIColor colorWithRed:37/255.0f green:63/255.0f blue:54/255.0f alpha:0.6]

//-- DetailsScheduleViewController
#define COLOR_DETAIL_SCHEDULE_BOLD [UIColor clearColor] //[UIColor colorWithRed:31/255.0f green:48/255.0f blue:61/255.0f alpha:0.89]
#define COLOR_DETAIL_SCHEDULE_REGULAR [UIColor clearColor] //[UIColor colorWithRed:40/255.0f green:54/255.0f blue:65/255.0f alpha:0.89]
#define COLOR_DETAIL_SCHEDULE_INFO [UIColor clearColor] //[UIColor colorWithRed:36/255.0f green:74/255.0f blue:62/255.0f alpha:1];
#define COLOR_SCHEDULE_DETAIL_HEADER [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.3]
//-- DetailsCommentViewController
#define COLOR_BG_CELL_0 [UIColor clearColor] //[UIColor colorWithRed:38/255.0f green:75/255.0f blue:87/255.0f alpha:0.89]
#define COLOR_BG_CELL_1 [UIColor clearColor] //[UIColor colorWithRed:31/255.0f green:57/255.0f blue:66/255.0f alpha:0.89]
//-- PhotoViewController
#define COLOR_HOME_ALBUM_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:58/255.0f green:55/255.0f blue:55/255.0f alpha:0.6]
#define COLOR_HOME_ALBUM_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:113/255.0f green:111/255.0f blue:111/255.0f alpha:0.4]
//-- ProfileViewController
#define COLOR_PROFILE_CELL_BOLD [UIColor clearColor] //[UIColor colorWithRed:36/255.0f green:35/255.0f blue:35/255.0f alpha:0.7]
#define COLOR_PROFILE_CELL_REGULAR [UIColor clearColor] //[UIColor colorWithRed:58/255.0f green:55/255.0f blue:55/255.0f alpha:0.7]
#define COLOR_BG_HEADER_VIEW [UIColor clearColor] //[UIColor colorWithRed:127/255.0f green:137/255.0f blue:142/255.0f alpha:1]

#endif
//===================================================================================================

//-- ProfileDetailViewController
//#define COLOR_BG_MENU [UIColor colorWithRed:29/255.0f green:54/255.0f blue:62/255.0f alpha:1]
//#define COLOR_BG_SCREEN [UIColor colorWithRed:24/255.0f green:42/255.0f blue:52/255.0f alpha:1]


//#define COLOR_BG_MENU_STORE [UIColor colorWithRed:29/255.0f green:54/255.0f blue:62/255.0f alpha:1]

//-- TableFanZoneViewController
//#define COLOR_FZ_CELL_BOLD [UIColor colorWithRed:31/255.0f green:50/255.0f blue:61/255.0f alpha:0.9]
//#define COLOR_FZ_CELL_REGULAR [UIColor colorWithRed:37/255.0f green:72/255.0f blue:82/255.0f alpha:0.9]


//-- TopUserViewController
//#define COLOR_TOPUSER_HEADER [UIColor colorWithRed:29/255.0f green:54/255.0f blue:62/255.0f alpha:1]
#define COLOR_CONTEST_BOLD [UIColor colorWithRed:31/255.0f green:48/255.0f blue:61/255.0f alpha:0.89]
#define COLOR_CONTEST_REGULAR [UIColor colorWithRed:40/255.0f green:54/255.0f blue:65/255.0f alpha:0.89]
#define COLOR_CONTEST_INFO [UIColor colorWithRed:36/255.0f green:74/255.0f blue:62/255.0f alpha:1]

//-- VideoViewController
//#define COLOR_BG_CELL_ALL [UIColor colorWithRed:57/255.0f green:57/255.0f blue:57/255.0f alpha:0.6]
#define COLOR_BG_CELL_FORMAL [UIColor colorWithRed:100/255.0f green:110/255.0f blue:114/255.0f alpha:0.6]
#define COLOR_BG_CELL_INFORMAL [UIColor colorWithRed:57/255.0f green:61/255.0f blue:62/255.0f alpha:0.6]

//-- ios device
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

//-- screen code
#define HOME_SCREEN             1
#define CHAT_SCREEN             2
#define NEWS_SCREEN             3
#define MEDIA_SCREEN            4
#define MUSIC_SCREEN            5
