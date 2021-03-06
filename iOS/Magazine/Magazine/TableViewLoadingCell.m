//
//  TableViewLoadingCell.m
//  Magazine
//
//  Created by Start on 5/27/14.
//  Copyright (c) 2014 Ancun. All rights reserved.
//

#import "TableViewLoadingCell.h"

@implementation TableViewLoadingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:CELLIDENTIFIERLOADINGCELL owner:self options: nil];
        // 如果路径不存在，return nil
        if(arrayOfViews.count < 1){return nil;}
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UITableViewCell class]]){
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        [self.load startAnimating];
    }
    return self;
}

@end
