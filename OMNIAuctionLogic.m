#import "OMNIAuctionLogic.h"

@implementation OMNIAuctionLogic
+(BOOL)wasUndercutForDetails:(NSDictionary *)auc realm:(NSString *)realm {
  int currentPrice = [auc[@"buy"] intValue];
  int lowestPrice = [OMNIAuctionLogic queryLowestPriceOfItem:auc[@"id"] onRealm:realm];
  HBLogDebug(@"%@:\ncurrent auction price: %d \n lowest detected price:%d", auc[@"n"], currentPrice, lowestPrice);
  return (currentPrice > lowestPrice);
}

+(int)queryLowestPriceOfItem:(NSString *)apid onRealm:(NSString *)realm {
  NSString * f = [NSString stringWithFormat:@"https://theunderminejournal.com/api/item.php?house=%@&item=%@", realm, apid];
  NSURL * api = [NSURL URLWithString:f];
  NSMutableURLRequest * q = [NSMutableURLRequest requestWithURL:api cachePolicy:0 timeoutInterval:5.0];
  q.HTTPMethod = @"GET";
  NSData * r = [NSURLConnection sendSynchronousRequest:q returningResponse:nil error:nil];
  if (r) {
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:r options:kNilOptions error:nil];
    NSArray * listings = json[@"auctions"][@"data"];
    // HBLogDebug(@"listings %@", listings);
    return [listings.lastObject[@"buy"] intValue];
  }
  return 0;
}
@end
