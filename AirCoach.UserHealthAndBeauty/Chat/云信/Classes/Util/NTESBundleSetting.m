//
//  NTESBundleSetting.m
//  NIM
//
//  Created by chris on 15/7/1.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESBundleSetting.h"

@implementation NTESBundleSetting

+ (instancetype)sharedConfig
{
    static NTESBundleSetting *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESBundleSetting alloc] init];
    });
    return instance;
}


- (BOOL)removeSessionWheDeleteMessages{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled_remove_recent_session"] boolValue];
}

- (BOOL)localSearchOrderByTimeDesc{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"local_search_time_order_desc"] boolValue];
}


- (BOOL)autoRemoveRemoteSession{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"auto_remove_remote_session"] boolValue];
}

- (BOOL)autoRemoveSnapMessage{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"auto_remove_snap_message"] boolValue];
}

- (BOOL)needVerifyForFriend
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"add_friend_need_verify"] boolValue];
}

- (BOOL)showFps{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"show_fps_for_app"] boolValue];
}

- (BOOL)disableProximityMonitor
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"disable_proxmity_monitor"] boolValue];
}



- (BOOL)enableRotate
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"enable_rotate"] boolValue];
}

- (BOOL)usingAmr
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"using_amr"] boolValue];
}

- (NIMNetCallVideoQuality)preferredVideoQuality
{
    NSInteger videoQualitySetting = [[[NSUserDefaults standardUserDefaults] objectForKey:@"videochat_preferred_video_quality"] integerValue];
    if ((videoQualitySetting >= NIMNetCallVideoQualityDefault) &&
        (videoQualitySetting <= NIMNetCallVideoQualityHigh)) {
        return (NIMNetCallVideoQuality)videoQualitySetting;
    }
    return NIMNetCallVideoQualityDefault;
}

- (BOOL)serverRecordAudio
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"server_record_audio"] boolValue];
}

- (BOOL)serverRecordVideo
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"server_record_video"] boolValue];
}

- (NSArray *)ignoreTeamNotificationTypes
{
    static NSArray *types = nil;
    if (types == nil)
    {
        NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"ignore_team_types"];
        if ([value isKindOfClass:[NSString class]])
        {
            NSString *typeDescription = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([typeDescription length])
            {
                types = [typeDescription componentsSeparatedByString:@","];
            }
        }
    }
    if (types == nil)
    {
        types = [NSArray array];
    }
    return types;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n\n\nenabled_remove_recent_session %d\nlocal_search_time_order_desc %d\nauto_remove_remote_session %d\nauto_remove_snap_message %d\nadd_friend_need_verify %d\nshow app %d\ndisable_proxmity_monitor %d\nusing amr %d\nserver_record_audio %d\nserver_record_video %d\nvideochat_preferred_video_quality %zd\nignore_team_types %@\n\n\n",
                                        [self removeSessionWheDeleteMessages],
                                        [self localSearchOrderByTimeDesc],
                                        [self autoRemoveRemoteSession],
                                        [self autoRemoveSnapMessage],
                                        [self needVerifyForFriend],
                                        [self showFps],
                                        [self disableProximityMonitor],
                                        [self usingAmr],
                                        [self serverRecordAudio],
                                        [self serverRecordVideo],
                                        [self preferredVideoQuality],
                                        [self ignoreTeamNotificationTypes]];
}
@end
