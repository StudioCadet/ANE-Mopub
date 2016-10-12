#import "MPBannerCustomEvent.h"
#import "SASAdViewDelegate.h"
#import "SASBannerView.h"

@interface SASBannerCustomEvent : MPBannerCustomEvent

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UIWindow *window;

@property NSInteger formatId;
@property (nonatomic, copy) NSString* pageId;
@property float timeOut;

@property (nonatomic, strong) SASBannerView *banner;
@property (nonatomic) Boolean isFetch;

@end

@interface BannerRootViewController : UIViewController <UITableViewDelegate, SASAdViewDelegate>
@property (nonatomic, strong) SASBannerCustomEvent *mpCustomEvent;
@end
