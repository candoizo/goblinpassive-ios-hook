#import "Master.h"
#import "OMNIAuctionLogic.h"

%hook AuctionHouseMyAuctionsTableView
-(id)tableView:(id)arg1 viewForHeaderInSection:(int)arg2 {
  if (arg2 == 0) {
    UIView * v = %orig;
    NSString * titleText = nil;
    for (id o in v.subviews) {
      if ([o respondsToSelector:@selector(text)]) {
         titleText = [o text];
      }
    }
    if ([titleText hasPrefix:@"Active"]){
      UIButton *button = [%c(UIButton) buttonWithType:UIButtonTypeCustom];
      button.backgroundColor = [%c(UIColor) redColor];
      [button addTarget:self action:@selector(checkAllListingsForUndercutsWithAutoCancel:) forControlEvents:UIControlEventTouchUpInside];
      button.layer.masksToBounds = YES;
      button.layer.cornerRadius = 8;
      [button setTitle:@"Undercut Scan" forState:UIControlStateNormal];
      float third = v.bounds.size.width/3;
      button.frame = CGRectMake(third*2-5, 0, third, v.bounds.size.height);
      button.bounds = CGRectMake(0,0,button.bounds.size.width, button.bounds.size.height* 0.75);
      button.titleLabel.font = [button.titleLabel.font fontWithSize:12];
      [v addSubview:button];
    }
    return v;
  }
  else return %orig;
}

%new
-(void)checkAllListingsForUndercutsWithAutoCancel:(id)arg1 {
  for (AuctionHouseMyAuctionsTableCell * c in self.subviews) {
    if ([c respondsToSelector:@selector(amIUndercut)]) [c amIUndercut] ? [c cancelAuction] : HBLogWarn(@"%@ was not undercut.", c.details[@"n"]);
  }
}
%end

%hook AuctionHouseMyAuctionsTableCell
%new
-(void)cancelAuction {
  [[%c(ArmoryManager) getInstance].account cancelAuction:self.details[@"auc"]];
}

%new
-(BOOL)amIUndercut {
  return [OMNIAuctionLogic wasUndercutForDetails:self.details realm:@"115"];
}
%end

%hook ArmoryAccount
-(int)ahCreateStackLimit {
  return 1000;
}

// -(BOOL)validateAHError:(NSDictionary *)arg1 {
//   if ([arg1[@"auctionError"] intValue] == 100) return NO;
//   return %orig;
// }
%end
