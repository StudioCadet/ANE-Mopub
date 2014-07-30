package com.mopub.mobileads;

import java.util.HashMap;
import java.util.Map;

import android.app.Activity;
import android.content.Context;

import com.inmobi.commons.AnimationType;
import com.inmobi.commons.InMobi;
import com.inmobi.commons.InMobi.LOG_LEVEL;
import com.inmobi.monetization.IMBanner;
import com.inmobi.monetization.IMBannerListener;
import com.inmobi.monetization.IMErrorCode;
import com.mopub.common.MoPub;
import com.mopub.common.util.Views;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

/*
 * Tested with InMobi SDK 4.1.1
 */
public class InMobiBanner extends CustomEventBanner implements IMBannerListener {
	
	private CustomEventBannerListener mBannerListener;
	private IMBanner iMBanner;
	private Activity activity;
	
	@Override
	protected void loadBanner(Context context, CustomEventBannerListener bannerListener, Map<String, Object> localExtras, Map<String, String> serverExtras) {
		
		MoPubExtension.log("Creating an InMobi banner ...");
		mBannerListener = bannerListener;

		activity = null;
		if (context instanceof Activity) {
			activity = (Activity) context;
		} else {
			// You may also pass in an Activity Context in the localExtras map
			// and retrieve it here.
		}
		if (activity == null) {
			mBannerListener.onBannerFailed(null);
			return;
		}
		
		InMobiUtils.init(context, activity);

		Integer slotSize = InMobiUtils.getOptimalSlotSize(activity);
		MoPubExtension.log("Creating banner with slot size " + slotSize + " ...");
		iMBanner = new IMBanner(activity, InMobiUtils.inMobiPropertyId, slotSize);
		
		Map<String, String> map = new HashMap<String, String>();
        map.put("tp", "c_mopub");
        map.put("tp-ver", MoPub.SDK_VERSION);
        iMBanner.setRequestParams(map);
		InMobi.setLogLevel(LOG_LEVEL.VERBOSE);
		iMBanner.setIMBannerListener(this);
		iMBanner.setRefreshInterval(-1);
		iMBanner.setAnimationType(AnimationType.ANIMATION_ALPHA);
		
		Long slotID = InMobiUtils.getSlotIdFromServerExtras(serverExtras);
		if(slotID != null) {
			MoPubExtension.log("Setting banner slot ID to " + slotID);
			iMBanner.setSlotId(slotID);
		}
		
		MoPubExtension.log("Loading InMobi banner ...");
		iMBanner.loadBanner();
	}

	/*
	 * Abstract methods from CustomEventBanner
	 */
	
	@Override
	public void onInvalidate() {
		if (iMBanner != null && activity != null) {
			activity.runOnUiThread(new Runnable() {
				@Override public void run() {
					
					MoPubExtension.log("Removing InMobi banner ...");
					iMBanner.setIMBannerListener(null);
					try {
		            	Views.removeFromParent(iMBanner);
		            }
		            catch(Exception e) {
		            	MoPubExtension.log("Exception while trying to remove an InMobiBanner : " + e);
		            }
					finally {
		            	iMBanner.destroy();
		            	iMBanner = null;
		            	MoPubExtension.log("InMobi banner removed.");
		            }
				}
			});
		}
	}

	@Override
	public void onBannerInteraction(IMBanner imBanner, Map<String, String> map) {
		MoPubExtension.log("InMobi Banner clicked.");
		mBannerListener.onBannerClicked();
	}

	@Override
	public void onBannerRequestFailed(IMBanner imBanner, IMErrorCode imErrorCode) {
		MoPubExtension.logW("InMobi banner request failed : " + imErrorCode);
		
		if (imErrorCode == IMErrorCode.INTERNAL_ERROR) {
			mBannerListener.onBannerFailed(MoPubErrorCode.INTERNAL_ERROR);
		} else if (imErrorCode == IMErrorCode.INVALID_REQUEST) {
			mBannerListener.onBannerFailed(MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR);
		} else if (imErrorCode == IMErrorCode.NETWORK_ERROR) {
			mBannerListener.onBannerFailed(MoPubErrorCode.NETWORK_INVALID_STATE);
		} else if (imErrorCode == IMErrorCode.NO_FILL) {
			mBannerListener.onBannerFailed(MoPubErrorCode.NO_FILL);
		} else {
			mBannerListener.onBannerFailed(MoPubErrorCode.UNSPECIFIED);
		}
	}

	@Override
	public void onBannerRequestSucceeded(IMBanner imBanner) {
		if (iMBanner != null) {
			MoPubExtension.log("InMobi banner loaded.");
			mBannerListener.onBannerLoaded(imBanner);
		} else {
			MoPubExtension.log("InMobi banner failed to load.");
			mBannerListener.onBannerFailed(null);
		}
	}

	@Override
	public void onDismissBannerScreen(IMBanner imBanner) {
		MoPubExtension.log("InMobi banner collapsed.");
		mBannerListener.onBannerCollapsed();
	}

	@Override
	public void onLeaveApplication(IMBanner imBanner) {

	}

	@Override
	public void onShowBannerScreen(IMBanner imBanner) {
		MoPubExtension.log("InMobi banner expanded.");
		mBannerListener.onBannerExpanded();
	}
}
