//
//  PersonalModel.h
//  AirCoach.UserHealthAndBeauty
//
//  Created by xuan on 16/6/15.
//  Copyright © 2016年 xuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DictModel.h"
#import "CheckModel.h"
#import "TrainModel.h"
#import "MJExtension.h"

#import "NurseModel.h"
@interface PersonalModel : NSObject

@property (nonatomic,strong) NSString *address;//地址

@property (nonatomic,strong) NSString *figure;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *nickname;

@property (nonatomic,strong) NSString *expired;//过期时间
@property (nonatomic, strong) NSString *start;//开始时间

@property (nonatomic,strong) DictModel*cur_diet;

@property (nonatomic,strong)CheckModel *cur_checking;//进度条模型 及小红点

@property (nonatomic, strong) NurseModel*nurse;//护理师

@property(nonatomic,strong)NSArray *cur_training;//计划模型

@property (nonatomic) NSInteger length;//总天数
@property (nonatomic) NSInteger usage;//完成天数
@property (nonatomic) NSInteger usage_pass;//完成天数
@property (nonatomic) NSInteger cur_stage;//当前的阶段

@property (nonatomic, strong) NSString *status;

/*
{
    address = "\U62c9\U8428\U6daa\U57ce\U533a";
    birth = "2018-09-15 00:00:00";
    birthday = "1984-02-17";
    "created_at" = "2018-09-15 00:00:00";
    "cur_checking" = 0;
    "cur_diet" =     (
                      {
                          backgroud = "http://lorempixel.com/640/200/?70908";
                          "coach_id" = 1;
                          complete = 0;
                          "created_at" = "2016-06-14 16:01:46";
                          "custom_id" = 17;
                          description =             {
                              note = "Alice thought over all the children she knew that it was over at last: 'and I wish you would have called him Tortoise because he was gone, and the second verse of the hall: in fact she was now about.";
                              target = "\U65e5\U5e38\U996e\U98df\U63a7\U5236";
                          };
                          end = "2019-01-03";
                          id = 160;
                          length = "<null>";
                          name = "\U8ba1\U5212\U6a21\U677f-\U65e5\U5e38\U996e\U98df\U63a7\U5236_\U7ae5\U7545";
                          "parent_id" = 5;
                          "stage_id" = 56;
                          start = "2019-01-04";
                          total = 1;
                          type = diet;
                          "updated_at" = "2016-06-14 16:01:46";
                      }
                      );
    "cur_stage" = 0;
    "cur_training" =     {
        backgroud = "http://lorempixel.com/640/200/?41554";
        "coach_id" = 1;
        complete = 0;
        "created_at" = "2016-06-14 16:01:46";
        "custom_id" = 17;
        description =         {
            note = "I'LL soon make you grow taller, and the others all joined in chorus, 'Yes, please do!' but the tops of the Lobster Quadrille, that she had finished, her sister was reading, but it had been. But her.";
            target = "\U9996\U5929\U4f53\U9a8c\U6027\U8bad\U7ec3";
        };
        end = "2019-01-04";
        id = 159;
        length = 11599;
        name = "\U8ba1\U5212\U6a21\U677f-\U9996\U5929\U4f53\U9a8c\U6027\U8bad\U7ec3_\U7ae5\U7545";
        "parent_id" = 1;
        "stage_id" = 56;
        start = "2018-12-30";
        total = 5;
        type = training;
        "updated_at" = "2016-06-14 16:01:46";
    };
    description =     {
        email = "rin@gmail.com";
        notes = "Eos tempore illo voluptatem voluptatem fugiat.";
    };
    expired = "2018-12-07 23:59:59";
    figure = "http://lorempixel.com/200/200/?57717";
    length = 30;
    name = "\U7ae5\U7545";
    nickname = "impedit_neque";
    "nurse_id" = 6;
    province = "\U5185\U8499\U53e4\U81ea\U6cbb\U533a";
    start = "2018-11-07";
    status = prepared;
    "updated_at" = "2018-09-15 00:00:00";
    usage = 0;
}

 */
@end
