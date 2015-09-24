#import "MPBannerCustomEvent.h"
#import "SASAdViewDelegate.h"
#import "SASBannerView.h"

@interface SASBannerCustomEvent : MPBannerCustomEvent

@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) UIWindow *window;

@property NSInteger formatId;
@property (nonatomic, copy) NSString* pageId;
@property float timeOut;

@property (nonatomic, retain) SASBannerView *banner;
@property (nonatomic) Boolean isFetch;

@end

@interface BannerRootViewController : UIViewController <UITableViewDelegate, SASAdViewDelegate>
@property (nonatomic, retain) SASBannerCustomEvent *mpCustomEvent;
@end
