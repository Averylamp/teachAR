
#ifndef io_agora_sdk2_h
#define io_agora_sdk2_h

#import <Foundation/Foundation.h>

#define AGORA_SDK_VERSION "1.3.3.1"



typedef NS_ENUM(NSUInteger, AgoraEcode){
    AgoraEcode_SUCCESS = 0,
    AgoraEcode_LOGOUT_E_OTHER = 100,
    AgoraEcode_LOGOUT_E_USER = 101,
    AgoraEcode_LOGOUT_E_NET = 102,
    AgoraEcode_LOGOUT_E_KICKED = 103,
    AgoraEcode_LOGOUT_E_PACKET = 104,
    AgoraEcode_LOGOUT_E_TOKENEXPIRED = 105,
    AgoraEcode_LOGOUT_E_OLDVERSION = 106,
    AgoraEcode_LOGOUT_E_TOKENWRONG = 107,
    AgoraEcode_LOGOUT_E_ALREADY_LOGOUT = 108,
    AgoraEcode_LOGIN_E_OTHER = 200,
    AgoraEcode_LOGIN_E_NET = 201,
    AgoraEcode_LOGIN_E_FAILED = 202,
    AgoraEcode_LOGIN_E_CANCEL = 203,
    AgoraEcode_LOGIN_E_TOKENEXPIRED = 204,
    AgoraEcode_LOGIN_E_OLDVERSION = 205,
    AgoraEcode_LOGIN_E_TOKENWRONG = 206,
    AgoraEcode_LOGIN_E_TOKEN_KICKED = 207,
    AgoraEcode_LOGIN_E_ALREADY_LOGIN = 208,
    AgoraEcode_LOGIN_E_INVALID_USER = 209,
    AgoraEcode_JOINCHANNEL_E_OTHER = 300,
    AgoraEcode_SENDMESSAGE_E_OTHER = 400,
    AgoraEcode_SENDMESSAGE_E_TIMEOUT = 401,
    AgoraEcode_QUERYUSERNUM_E_OTHER = 500,
    AgoraEcode_QUERYUSERNUM_E_TIMEOUT = 501,
    AgoraEcode_QUERYUSERNUM_E_BYUSER = 502,
    AgoraEcode_LEAVECHANNEL_E_OTHER = 600,
    AgoraEcode_LEAVECHANNEL_E_KICKED = 601,
    AgoraEcode_LEAVECHANNEL_E_BYUSER = 602,
    AgoraEcode_LEAVECHANNEL_E_LOGOUT = 603,
    AgoraEcode_LEAVECHANNEL_E_DISCONN = 604,
    AgoraEcode_INVITE_E_OTHER = 700,
    AgoraEcode_INVITE_E_REINVITE = 701,
    AgoraEcode_INVITE_E_NET = 702,
    AgoraEcode_INVITE_E_PEEROFFLINE = 703,
    AgoraEcode_INVITE_E_TIMEOUT = 704,
    AgoraEcode_INVITE_E_CANTRECV = 705,
    AgoraEcode_GENERAL_E = 1000,
    AgoraEcode_GENERAL_E_FAILED = 1001,
    AgoraEcode_GENERAL_E_UNKNOWN = 1002,
    AgoraEcode_GENERAL_E_NOT_LOGIN = 1003,
    AgoraEcode_GENERAL_E_WRONG_PARAM = 1004,
    AgoraEcode_GENERAL_E_LARGE_PARAM = 1005
};

__attribute__ ((visibility ("default"))) @interface AgoraAPI : NSObject

+ (AgoraAPI*) getInstanceWithoutMedia:(NSString*)vendorKey;
+ (AgoraAPI*) getSigInstance:(NSString*)vendorKey;
+ (AgoraAPI*) createSigInstance:(NSString*)vendorKey;



@property int uid ;

@property (copy) void(^onReconnecting)(uint32_t nretry) ;
@property (copy) void(^onReconnected)(int fd) ;
@property (copy) void(^onLoginSuccess)(uint32_t uid,int fd) ;
@property (copy) void(^onLogout)(AgoraEcode ecode) ;
@property (copy) void(^onLoginFailed)(AgoraEcode ecode) ;
@property (copy) void(^onChannelJoined)(NSString* channelID) ;
@property (copy) void(^onChannelJoinFailed)(NSString* channelID,AgoraEcode ecode) ;
@property (copy) void(^onChannelLeaved)(NSString* channelID,AgoraEcode ecode) ;
@property (copy) void(^onChannelUserJoined)(NSString* account,uint32_t uid) ;
@property (copy) void(^onChannelUserLeaved)(NSString* account,uint32_t uid) ;
@property (copy) void(^onChannelUserList)(NSMutableArray* accounts, NSMutableArray* uids);
@property (copy) void(^onChannelQueryUserNumResult)(NSString* channelID,AgoraEcode ecode,int num) ;
@property (copy) void(^onChannelQueryUserIsIn)(NSString* channelID,NSString* account,int isIn) ;
@property (copy) void(^onChannelAttrUpdated)(NSString* channelID,NSString* name,NSString* value,NSString* type) ;
@property (copy) void(^onInviteReceived)(NSString* channelID,NSString* account,uint32_t uid,NSString* extra) ;
@property (copy) void(^onInviteReceivedByPeer)(NSString* channelID,NSString* account,uint32_t uid) ;
@property (copy) void(^onInviteAcceptedByPeer)(NSString* channelID,NSString* account,uint32_t uid,NSString* extra) ;
@property (copy) void(^onInviteRefusedByPeer)(NSString* channelID,NSString* account,uint32_t uid,NSString* extra) ;
@property (copy) void(^onInviteFailed)(NSString* channelID,NSString* account,uint32_t uid,AgoraEcode ecode,NSString* extra) ;
@property (copy) void(^onInviteEndByPeer)(NSString* channelID,NSString* account,uint32_t uid,NSString* extra) ;
@property (copy) void(^onInviteEndByMyself)(NSString* channelID,NSString* account,uint32_t uid) ;
@property (copy) void(^onInviteMsg)(NSString* channelID,NSString* account,uint32_t uid,NSString* msgType,NSString* msgData,NSString* extra) ;
@property (copy) void(^onMessageSendError)(NSString* messageID,AgoraEcode ecode) ;
@property (copy) void(^onMessageSendProgress)(NSString* account,NSString* messageID,NSString* type,NSString* info) ;
@property (copy) void(^onMessageSendSuccess)(NSString* messageID) ;
@property (copy) void(^onMessageAppReceived)(NSString* msg) ;
@property (copy) void(^onMessageInstantReceive)(NSString* account,uint32_t uid,NSString* msg) ;
@property (copy) void(^onMessageChannelReceive)(NSString* channelID,NSString* account,uint32_t uid,NSString* msg) ;
@property (copy) void(^onLog)(NSString* txt) ;
@property (copy) void(^onInvokeRet)(NSString* callID,NSString* err,NSString* resp) ;
@property (copy) void(^onMsg)(NSString* from,NSString* t,NSString* msg) ;
@property (copy) void(^onUserAttrResult)(NSString* account,NSString* name,NSString* value) ;
@property (copy) void(^onUserAttrAllResult)(NSString* account,NSString* value) ;
@property (copy) void(^onError)(NSString* name,AgoraEcode ecode,NSString* desc) ;
@property (copy) void(^onQueryUserStatusResult)(NSString* name,NSString* status) ;
@property (copy) void(^onDbg)(NSString* a,NSString* b) ;
@property (copy) void(^onBCCall_result)(NSString* reason,NSString* json_ret,NSString* callID) ;



- (void) login:(NSString*)vendorID account:(NSString*)account token:(NSString*)token uid:(uint32_t)uid deviceID:(NSString*)deviceID ;
- (void) login2:(NSString*)vendorID account:(NSString*)account token:(NSString*)token uid:(uint32_t)uid deviceID:(NSString*)deviceID retry_time_in_s:(int)retry_time_in_s retry_count:(int)retry_count ;
- (void) logout;

- (void) channelJoin:(NSString*)channelID ;
- (void) channelJoin:(NSString*)channelID dynamicKey:(NSString*)dynamicKey ;

- (void) channelLeave:(NSString*)channelID ;
- (void) channelQueryUserNum:(NSString*)channelID ;
- (void) channelQueryUserIsIn:(NSString*)channelID account:(NSString*)account ;
- (void) channelSetAttr:(NSString*)channelID name:(NSString*)name value:(NSString*)value ;
- (void) channelDelAttr:(NSString*)channelID name:(NSString*)name ;
- (void) channelClearAttr:(NSString*)channelID ;
- (void) channelInviteUser:(NSString*)channelID account:(NSString*)account uid:(uint32_t)uid ;
- (void) channelInviteUser2:(NSString*)channelID account:(NSString*)account extra:(NSString*)extra ;
- (void) channelInvitePhone:(NSString*)channelID phoneNum:(NSString*)phoneNum uid:(uint32_t)uid ;
- (void) channelInvitePhone2:(NSString*)channelID phoneNum:(NSString*)phoneNum sourcesNum:(NSString*)sourcesNum ;
- (void) channelInvitePhone3:(NSString*)channelID phoneNum:(NSString*)phoneNum sourcesNum:(NSString*)sourcesNum extra:(NSString*)extra ;
- (void) channelInviteDTMF:(NSString*)channelID phoneNum:(NSString*)phoneNum dtmf:(NSString*)dtmf ;
- (void) channelInviteAccept:(NSString*)channelID account:(NSString*)account uid:(uint32_t)uid extra:(NSString*)extra ;
- (void) channelInviteRefuse:(NSString*)channelID account:(NSString*)account uid:(uint32_t)uid extra:(NSString*)extra ;
- (void) channelInviteEnd:(NSString*)channelID account:(NSString*)account uid:(uint32_t)uid ;
- (void) messageAppSend:(NSString*)msg msgID:(NSString*)msgID ;
- (void) messageInstantSend:(NSString*)account uid:(uint32_t)uid msg:(NSString*)msg msgID:(NSString*)msgID ;
- (void) messageInstantSend2:(NSString*)account uid:(uint32_t)uid msg:(NSString*)msg msgID:(NSString*)msgID options:(NSString*)options ;
- (void) messageChannelSend:(NSString*)channelID msg:(NSString*)msg msgID:(NSString*)msgID ;
- (void) messageChannelSendForce:(NSString*)channelID msg:(NSString*)msg msgID:(NSString*)msgID ;
- (void) messageChannelSend2:(NSString*)channelID msg:(NSString*)msg msgID:(NSString*)msgID extra:(NSString*)extra ;
- (void) messagePushSend:(NSString*)account uid:(uint32_t)uid msg:(NSString*)msg msgID:(NSString*)msgID ;
- (void) messageChatSend:(NSString*)account uid:(uint32_t)uid msg:(NSString*)msg msgID:(NSString*)msgID ;
- (void) messageDTMFSend:(uint32_t)uid msg:(NSString*)msg msgID:(NSString*)msgID ;
- (void) setBackground:(uint32_t)bOut ;
- (void) setNetworkStatus:(uint32_t)bOut ;
- (void) ping;
- (void) setAttr:(NSString*)name value:(NSString*)value ;
- (void) getAttr:(NSString*)name ;
- (void) getAttrAll;
- (void) getUserAttr:(NSString*)account name:(NSString*)name ;
- (void) getUserAttrAll:(NSString*)account ;
- (void) queryUserStatus:(NSString*)account ;
- (void) invoke:(NSString*)name req:(NSString*)req callID:(NSString*)callID ;
- (void) start;
- (void) stop;
- (bool) isOnline;
- (int) getStatus;
- (int) getSdkVersion;
- (void) bc_call:(NSString*)func json_args:(NSString*)json_args callID:(NSString*)callID ;
- (void) dbg:(NSString*)a b:(NSString*)b ;
- (void) destroy;

@end

#endif
