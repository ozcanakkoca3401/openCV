//
//  CPP_Wrapper.h
//  openCViOS
//
//  Created by ozcan akkoca on 12/11/2016.
//  Copyright © 2016 ozcan akkoca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "CPP.hpp"

@interface CPP_Wrapper : NSObject
- (void)helloCPPWrapper:(NSString *)name;
+(UIImage *) makeGrayImage:(UIImage *) image number:(int) filterNumber;

@end

