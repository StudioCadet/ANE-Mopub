package com.mopub.mobileads;

import java.util.Map;

import android.app.Activity;
import android.content.Context;

import com.chartboost.sdk.Chartboost;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

class ChartboostInterstitial extends CustomEventInterstitial {

	// PROPERTIES :
	/** The Chartboost ad location this interstitial ad is for. */
	private String location;


	// CONSTRUCTOR :
	public ChartboostInterstitial() {
		super();
	}


	///////////////////////////////////////
	// CUSTOM EVENT INTERSTITIAL METHODS //
	///////////////////////////////////////

	@Override
	protected void loadInterstitial(Context context, CustomEventInterstitialListener interstitialListener, Map<String, Object> localExtras, Map<String, String> serverExtras) {

		// Check context :
		if (!(context instanceof Activity)) {
			MoPubExtension.log("Chartboost loadInterstitial() : the given context must be an instance of Activity ! (context:" + context + ")");
			interstitialListener.onInterstitialFailed(MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR);
			return;
		}

		// Get server extra data :
		this.location = ChartboostUtils.getLocationFromServerExtras(serverExtras);

		// Register the MoPub listener :
		if(!ChartboostUtils.registerListener(location, interstitialListener)) {
			MoPubExtension.log("Chartboost loadInterstitial() : a listener is already registered for the given location. Failing.");
			interstitialListener.onInterstitialFailed(MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR);
			return;
		}

		// Load the interstitial :
		final Activity activity = (Activity) context;
		activity.runOnUiThread(new Runnable() {
			@Override public void run() {
				MoPubExtension.log("Caching Chartboost interstitial ad for location " + location + ".");
				Chartboost.cacheInterstitial(location);
			}
		});
	}

	@Override
	protected void showInterstitial() {
		MoPubExtension.log("Showing Chartboost interstitial ad for location " + location + ".");
		Chartboost.showInterstitial(location);
	}

	@Override
	protected void onInvalidate() {
		MoPubExtension.log("Invalidating Chartboost interstitial ad for location " + location + ".");
		ChartboostUtils.unregisterListener(location);
	}
}
