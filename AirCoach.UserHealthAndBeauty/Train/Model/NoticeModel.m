//
//  NoticeModel.m
//  AirCoach.UserHealthAndBeauty
//
//  Created by wei on 16/11/16.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import "NoticeModel.h"

@implementation NoticeModel

+(NSArray *)copyNoticeArr
{
    
    NSDictionary *dic1 = @{@"url":@"http://image-test.aircoach.cn/media/4b91b9492d3dcfcc658a8f8b1b062993.png",
                           @"name":@"联系护理师",
                           @"videoUrl":@"http://image-test.aircoach.cn/media/d77da2fd4788ef36a372b6020dc062d2.mp4",
                           @"videoDetail":@"你可以通过多种方法找到您的护理师。\n如果你的设备是iPhone 6s或更新的机型，可用力按下”光合塑形”的图标，选择“与护理师沟通”后即可立即与您的护理师交流。\n你也可以在App的首页右上角找到与护理师交流页面的入口。\n为了与护理师保持畅通的联系，并更好的为你服务，请保持你的iPhone设置中，光合塑形的通知权限打开（设置->通知->光合塑形，打开“允许通知”开关与其下的子开关）。"};
    
    NSDictionary *dic2 = @{@"url":@"http://image-test.aircoach.cn/media/d62af2f5dc972c8a96877a1fe0e8bd72.png",
                           @"name":@"查看我的训练计划",
                           @"videoUrl":@"http://image-test.aircoach.cn/media/230ad1d6639ce75056f3905148db8191.mp4",
                           @"videoDetail":@"在首页中，点击左上角的小图标，可以看到你在整个光合塑形服务期间的训练规划。"};
    
    NSDictionary *dic3 = @{@"url":@"http://image-test.aircoach.cn/media/0feefcf455bb28c9949457f4bcdfb4cb.png",
                           @"name":@"下载训练视频",
                           @"videoUrl":@"http://image-test.aircoach.cn/media/9a4e44ccc05f30cc5604917e406cc232.mp4",
                           @"videoDetail":@"每当你的训练方案有更新时，App在你训练前都会下载新的训练方案视频。由于训练视频较大，我们建议在WIFI网络环境下下载。"};
    
    NSDictionary *dic4 = @{@"url":@"http://image-test.aircoach.cn/media/a3b7a6e1e93103d2983d619aadb85541.png",
                           @"name":@"学习训练视频中的动作",
                           @"videoUrl":@"http://image-test.aircoach.cn/media/a0024b7b0fd70b61ab3103ebc0d15f0f.mp4",
                           @"videoDetail":@"你可以通过点击训练方案页面的动作，来查看每个动作的讲解。你也可以在训练中轻点屏幕，查看正在训练动作的讲解。我们建议在训练过程中遵守动作讲解视频中提到的要点，这样可以达到最高的健身效率。"};
    
    NSDictionary *dic5 = @{@"url":@"http://image-test.aircoach.cn/media/03a0e29f63090d1175f108deea44590b.png",
                           @"name":@"完成一次训练",
                           @"videoUrl":@"http://image-test.aircoach.cn/media/135f85490d7ed86d3b8cd01886f3db20.mp4",
                           @"videoDetail":@"在训练视频播放完后，我们会记录一次你的训练进度并反馈给你的护理师与塑形师。因此在训练期间我们建议保持设备的网络畅通。"};
    
    NSDictionary *dic6 = @{@"url":@"http://image-test.aircoach.cn/media/f9046b576d59263312b66405d6c7146a.png",
                           @"name":@"清除缓存",
                           @"videoUrl":@"http://image-test.aircoach.cn/media/f2482ce0c7e648a6782035dae2383553.mp4",
                           @"videoDetail":@"在你每下载完一个训练方案的视频后，App将会保留其缓存。在清除缓存的功能中，你可以选择保留正在训练的方案缓存并清除旧方案缓存，或清除全部训练方案的视频缓存。"};
    
    NSDictionary *dic7 = @{@"url":@"http://image-test.aircoach.cn/media/72c9ba16e5c84fe332d2ce8dfebac037.png",
                           @"name":@"暂停服务",
                           @"videoUrl":@"http://image-test.aircoach.cn/media/e4682fb905077dac126bbb5898e31352.mp4",
                           @"videoDetail":@"如果你最近没有时间锻炼，可以暂停一段时间的服务，这样我们的对你服务的计时会暂停。不过当你暂停服务后，你的护理师将无法与你保持联系，所以为了你的塑形训练，我们期待你早日调整好时间，继续训练。"};
    NSDictionary *dic8 = @{@"url":@"http://image-test.aircoach.cn/media/f9dce700d6cb69b644934746069a504d.png",
                           @"name":@"语音控制训练的开始",
                           @"videoUrl":@"http://image-test.aircoach.cn/media/409e61431458b77a227df6eeae5aa49c.mp4",
                           @"videoDetail":@"在播放训练视频前，你可以先做好准备姿势，然后对手机说出“开始”，训练视频即可自动播放（需要将设备联网）。"};
    
    NSArray *arr = @[dic1,dic2,dic3,dic4,dic5,dic6,dic7,dic8];
    
    return arr;
    
}

@end
