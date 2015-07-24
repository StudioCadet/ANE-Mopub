package com.mopub.mobileads;

import java.util.HashMap;
import java.util.Map;

import android.app.Activity;
import android.content.Context;

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

		String propertyID = InMobiUtils.getPropertyIdFromServerExtras(serverExtras);
		Integer slotSize = InMobiUtils.getOptimalSlotSize(activity);
		
		if(propertyID == null) {
			propertyID = InMobiUtils.inMobiPropertyId;
			MoPubExtension.log("Using default property ID : " + propertyID);
		}
		else
			MoPubExtension.log("Using custom property ID : " + propertyID);
		
		MoPubExtension.log("Creating banner with property ID " + propertyID + " and slot size " + slotSize + " ...");
		iMBanner = new IMBanner(activity, propertyID, slotSize);
		
		Map<String, String> map = new HashMap<String, String>();
        map.put("tp", "c_mopub");
        map.put("tp-ver", MoPub.SDK_VERSION);
        map.put("reftag", "AndroidBanner");
        map.put("ref-tag", "AndroidBanner");
        iMBanner.setRequestParams(map);
		iMBanner.setIMBannerListener(this);
		iMBanner.setRefreshInterval(IMBanner.REFRESH_INTERVAL_OFF);
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
		            	MoPubExtension.log("InMobi banner view removed.");
		            }
		            catch(Exception e) {
		            	MoPubExtension.log("Exception while trying to remove an InMobiBanner : " + e);
		            }
					finally {
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
		MoPubExtension.log("Application leaved.");
	}

	@Override
	public void onShowBannerScreen(IMBanner imBanner) {
		MoPubExtension.log("InMobi banner expanded.");
		mBannerListener.onBannerExpanded();
	}
}
