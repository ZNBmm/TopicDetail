//
//  ZNBTableViewController.m
//  TopicDetail
//
//  Created by mac on 2017/3/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ZNBTableViewController.h"
#import "YYText.h"
#import "UIImageView+WebCache.h"
#import "UIView+Frame.h"
#import "YYFPSLabel.h"
#import "ZNBTableViewCell.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
//#import ""
@interface ZNBTableViewController ()<MWPhotoBrowserDelegate>
@property (nonatomic, copy)NSMutableAttributedString *contentAttr;
@property (strong, nonatomic) NSArray *imageUrl;
@property (strong, nonatomic) NSMutableArray *photos;
@end

@implementation ZNBTableViewController
- (NSMutableArray *)photos
{
    if (_photos == nil) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [YYFPSLabel new];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self dealData];
    });
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZNBTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
}
- (void)dealData {
    
    NSString *content = @"\r古人如梦,我见犹怜.人生如梦,见谁有脸.😁😁😁😁古人如梦,我见犹怜.人生如梦,见谁有脸.😁😁😁😁古人如梦,我见犹怜.人生如梦,见谁有脸.😁😁😁😁\n [-image0-]\n\n人生自古谁无死,哈哈,人生自古谁无死,哈哈\n1、前两天网购了两样东西：衣服和腊肠，结果粗心的我把给衣服的评论写在了腊肠上：尺寸刚好，很舒服。\n卖家回复我：注意安全！\n [-image1-]\n\n性命是一场宿命的缘，从起点到终点，从无到有，从有到无，虽注定灰飞烟灭，但是，纷繁的嚣尘，来过，爱过，痛过，便无邪地微笑了，故无悔。流年逝，芳华尽，几多惆怅，几多惘然，只因剪不断，理还乱。此情此景皆如梦，心动且意动，只为追寻这不解宿命的缘。——梦语（三）\n [-image2-]\n\n当心成为碎片，我们还能否将它们拾起，重新补好？——梦语（二）\n [-image3-]";
    self.imageUrl = @[
                          @"http://b267.photo.store.qq.com/psb?/V14FigKY37Aj94/kKKdkSg615*PLQrq9.CNCIWNqjvYAAg9c0D9uew8IoU!/b/dGS4LJ*YIgAA&bo=IANYAgAAAAABB1k!&rf=viewer_4",
                          @"http://b397.photo.store.qq.com/psb?/V14FigKY2wt7hr/wrg0IhbILptR5BhwBD6uqYgno*wkY2LqPt0la8AuYFM!/b/dI0BAAAAAAAA&bo=gAJxBIUDQAYFCBw!&rf=viewer_4",
                          @"http://b344.photo.store.qq.com/psb?/V14FigKY2wt7hr/D3u7BoFOIgUjyagoImsS88flkpg7Pb.A1ypTe.Ivt9A!/b/dFgBAAAAAAAA&bo=kQNUBgAAAAAFAOM!&rf=viewer_4",
                          @"http://b397.photo.store.qq.com/psb?/V14FigKY2wt7hr/mbai.mwApSdLV62w0XIFR16PUfW65BchSD0mgf61qLM!/b/dDQZpuwGJAAA&bo=gAJVAwAAAAABAPM!&rf=viewer_4"
                          ];
    
    NSArray *imageH = @[
                        @"266.5",
                        @"631",
                        @"630",
                        @"473.5"
                        ];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:content];
    UIFont *font = [UIFont systemFontOfSize:14];
    NSInteger count = [content componentsSeparatedByString:@"[-image"].count-1;
    for (int i=0; i<count; i++) {
        NSString *imageStr = [NSString stringWithFormat:@"[-image%d-]",i];
        UIImageView *imageView = [[UIImageView alloc] init];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_imageUrl[i]];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap:)];
        [imageView addGestureRecognizer:tapGes];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        CGFloat w = ScreenW - 20;
        CGFloat h = [imageH[i] floatValue];
        imageView.frame = CGRectMake(0, 0, w,h);
   
        if (image) {
            
            imageView.image = image;
            NSLog(@"从内存去图片");
        }else {
            NSLog(@"下载图片");
            [imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl[i]] placeholderImage:
             [UIImage imageNamed:@"placehodel"] options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                CGSize size = image.size;
                CGFloat w = ScreenW - 20;
                CGFloat h = (ScreenW-20)*size.height/size.width;
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), NO, 0);
                [image drawInRect:CGRectMake(0, 0, w, h)];
                image = UIGraphicsGetImageFromCurrentImageContext();
                [[SDImageCache sharedImageCache] storeImage:image forKey:_imageUrl[i] toDisk:YES];
                UIGraphicsEndImageContext();
                
                if (i==count-1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageView.image = image;
                        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                        [self.tableView reloadData];
                    });
                }
            }];
        }
       
        NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.frame.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        
        [text replaceCharactersInRange:[text.string rangeOfString:imageStr] withAttributedString:attachment];
        [text setYy_font:font];
        self.contentAttr = text;
        
        [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:self.imageUrl[i]]]];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ZNBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        YYLabel *label = cell.container;
        label.numberOfLines = 0;
        label.attributedText = self.contentAttr;
        
        [cell.contentView addSubview:label];
        
        label.displaysAsynchronously = YES; //开启异步绘制
        label.ignoreCommonProperties = YES; //忽略除了 textLayout 之外的其他属性
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // 创建文本容器
            YYTextContainer *container = [YYTextContainer new];
            container.size = CGSizeMake(ScreenW-20, CGFLOAT_MAX);
            container.maximumNumberOfRows = 0;
            
            // 生成排版结果
            YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:self.contentAttr];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                label.frame = layout.textBoundingRect;
                label.znb_x = 10;
                label.textLayout = layout;
            });
        });
        return cell;
    }else {
        UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];
        if (!Cell) {
            Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testCell"];
        }
        Cell.textLabel.text = @"测试数据";
        return Cell;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CGSize size = CGSizeMake(ScreenW-20, CGFLOAT_MAX);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:self.contentAttr];
//        NSLog(@"label---%@",NSStringFromCGRect(layout.textBoundingRect));
        return layout.textBoundingSize.height+70;
    }else {
    
        return 44;
    }
    
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)imageViewDidTap:(UITapGestureRecognizer *)tap {
    
    NSLog(@"%li",tap.view.tag);
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    
    // Customise selection images to change colours if required
    browser.customImageSelectedIconName = @"ImageSelected.png";
    browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:0];
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    
    // Present
    [self.navigationController pushViewController:browser animated:YES];
   
}
#pragma mark - MWPhotoBrowserDelegate 
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}
- (void)dealloc {
    for (int i=0; i<self.imageUrl.count; i++) {
        NSLog(@"将图片从内存中清出");
        [[SDImageCache sharedImageCache] removeImageForKey:self.imageUrl[i] fromDisk:NO];
    }
    NSLog(@"%s",__func__);
}
@end
