//
//  CertModel.h
//  Opt_master
//
//  Created by 瑞宁科技02 on 16/9/27.
//  Copyright © 2016年 reining. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface CertModel : JSONModel
/**
 *   createdby = 10000012;
 createdon = 1474966788;
 id = 31;
 images = "upload/certification/person/cert_14749667873561291210300.png";
 title = 123;
 type = person;
 verifiedby = 222;
 verifiedon = 111;

 */

@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *type;  // verifiedby
@property (nonatomic ,copy )NSString *verifiedon;
@property (nonatomic ,copy)NSString *id;



@end
