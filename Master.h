@interface ArmoryAccount : NSObject
-(void)cancelAuction:(id)arg1;
@end

@interface ArmoryManager : NSObject
@property (nonatomic, retain) ArmoryAccount * account;
+(ArmoryManager *)getInstance;
@end

@interface AuctionHouseMyAuctionsTableCell : UIView
@property (nonatomic, retain) NSDictionary * details;
-(BOOL)amIUndercut;
-(void)cancelAuction;
@end

@interface AuctionHouseBrowseTableCell: UIView
@property (nonatomic, retain) NSDictionary * details;
@end

@interface ArmoryTableView : UITableView
@end

@interface AuctionHouseMyAuctionsTableView : UITableView
@end
