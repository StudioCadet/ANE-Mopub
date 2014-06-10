package com.mopub.mobileads;

import java.util.HashMap;
import java.util.Map;

import android.app.Activity;
import android.content.Context;

import com.inmobi.monetization.IMErrorCode;
import com.inmobi.monetization.IMInterstitial;
import com.inmobi.monetization.IMInterstitialListener;
import com.mopub.common.MoPub;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

/*
 * Tested with InMobi SDK  4.1.1
 */
public class InMobiInterstitial extends CustomEventInterstitial implements IMInterstitialListener {

	private CustomEventInterstitialListener mInterstitialListener;
	private IMInterstitial iMInterstitial;
	
	@Override
	protected void loadInterstitial(Context context, CustomEventInterstitialListener interstitialListener, 
			Map<String, Object> localExtras, Map<String, String> serverExtras) 
	{
		MoPubExtension.log("Creating an InMobi interstitial ...");
		mInterstitialListener = interstitialListener;

		Activity activity = null;
		if (context instanceof Activity) {
			activity = (Activity) context;
		} else {
			// You may also pass in an Activity Context in the localExtras map
			// and retrieve it here.
		}

		if (activity == null) {
			mInterstitialListener.onInterstitialFailed(MoPubErrorCode.UNSPECIFIED);
			return;
		}

		InMobiUtils.init(context, activity);
		
		this.iMInterstitial = new IMInterstitial(activity, InMobiUtils.inMobiPropertyId);

        Map<String, String> map = new HashMap<String, String>();
        map.put("tp", "c_mopub");
        map.put("tp-ver", MoPub.SDK_VERSION);
        iMInterstitial.setRequestParams(map);
		iMInterstitial.setIMInterstitialListener(this);
		
		MoPubExtension.log("Loading an InMobi interstitial ...");
		iMInterstitial.loadInterstitial();
	}


	/*
	 * Abstract methods from CustomEventInterstitial
	 */

	@Override
	public void showInterstitial() {
		if (iMInterstitial != null && IMInterstitial.State.READY.equals(this.iMInterstitial.getState())) {
			MoPubExtension.log("Showing an InMobi interstitial ...");
			iMInterstitial.show();
		}
	}

	@Override
	public void onInvalidate() {
		if (iMInterstitial != null) {
			MoPubExtension.log("Removing an InMobi interstitial ...");
            iMInterstitial.setIMInterstitialListener(null);
			iMInterstitial.destroy();
			MoPubExtension.log("InMobi interstitial removed.");
		}
	}

	@Override
	public void onDismissInterstitialScreen(IMInterstitial imInterstitial) {
		MoPubExtension.log("InMobi interstitial dismissed.");
		mInterstitialListener.onInterstitialDismissed();
	}

	@Override
	public void onInterstitialFailed(IMInterstitial imInterstitial, IMErrorCode imErrorCode) {
		MoPubExtension.log("InMobi interstitial failed to load : " + imErrorCode);
		if (imErrorCode == IMErrorCode.INTERNAL_ERROR) {
			mInterstitialListener.onInterstitialFailed(MoPubErrorCode.INTERNAL_ERROR);
		} else if (imErrorCode == IMErrorCode.INVALID_REQUEST) {
			mInterstitialListener.onInterstitialFailed(MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR);
		} else if (imErrorCode == IMErrorCode.NETWORK_ERROR) {
			mInterstitialListener.onInterstitialFailed(MoPubErrorCode.NETWORK_INVALID_STATE);
		} else if (imErrorCode == IMErrorCode.NO_FILL) {
			mInterstitialListener.onInterstitialFailed(MoPubErrorCode.NO_FILL);
		} else {
			mInterstitialListener.onInterstitialFailed(MoPubErrorCode.UNSPECIFIED);
		}
	}

	@Override
	public void onInterstitialInteraction(IMInterstitial imInterstitial, Map<String, String> map) {
		MoPubExtension.log("InMobi interstitial clicked.");
		mInterstitialListener.onInterstitialClicked();
	}

	@Override
	public void onInterstitialLoaded(IMInterstitial imInterstitial) {
		MoPubExtension.log("InMobi interstitial loaded.");
		mInterstitialListener.onInterstitialLoaded();
	}

	@Override
	public void onLeaveApplication(IMInterstitial imInterstitial) {

	}

	@Override
	public void onShowInterstitialScreen(IMInterstitial imInterstitial) {
		MoPubExtension.log("InMobi interstitial shown.");
		mInterstitialListener.onInterstitialShown();
	}
}
