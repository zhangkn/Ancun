//
//  BeinDangerHeader.h
//  Car
//
//  Created by Start on 11/24/15.
//  Copyright © 2015 Ancun. All rights reserved.
//

@interface BeinDangerHeader : UITableViewCell

@property (strong,nonatomic)UIScrollView *scrollView;
@property (strong,nonatomic)XLLabel *lblAddress;
@property (strong,nonatomic)UIImageView *ivStepOne;
@property (strong,nonatomic)UIImageView *ivStepTwo;
@property (strong,nonatomic)UIImageView *ivStepThree;
@property (strong,nonatomic)XLLabel *lblStepOne;
@property (strong,nonatomic)XLLabel *lblStepTwo;
@property (strong,nonatomic)XLLabel *lblStepThree;

- (void)setCurrentType:(NSInteger)type;
- (void)addSubImage:(NSString*)imageNamed;

@end
