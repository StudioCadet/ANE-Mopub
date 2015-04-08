package com.mopub.mobileads;

import static com.mopub.mobileads.MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR;
import static com.mopub.mobileads.MoPubErrorCode.NETWORK_NO_FILL;

import java.util.Map;

import android.app.Activity;
import android.content.Context;
import android.location.Location;

import com.mopub.common.LocationService;
import com.mopub.common.MoPub;
import com.nexage.android.DeviceLocation;
import com.nexage.android.NexageAdManager;
import com.nexage.android.NexageInterstitial;
import com.nexage.android.NexageInterstitialListener;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class NexageAdapterInterstitial extends CustomEventInterstitial implements NexageInterstitialListener {

	
	private static final String POSITION_KEY = "position";
	
	private NexageInterstitial mInterstitialAd;
	private CustomEventInterstitialListener mInterstitialListener;

	@Override
	protected void loadInterstitial(final Context context, CustomEventInterstitialListener customEventInterstitialListener, final Map<String, Object> localParams,
			Map<String, String> serverParams) {
		mInterstitialListener = customEventInterstitialListener;
		MoPubExtension.log("MoPub calling Nexage for a Interstitial ad with position: " + (String) serverParams.get(POSITION_KEY));

		if (!(context instanceof Activity)) {
            mInterstitialListener.onInterstitialFailed(ADAPTER_CONFIGURATION_ERROR);
            return;
        }
		
		NexageAdManager.setIsMediation(true);

		
		DeviceLocation deviceLocation = new DeviceLocation() {
			@Override
			public Location getLocation() {
				return LocationService.getLastKnownLocation(context, MoPub.getLocationPrecision(), MoPub.getLocationAwareness());
			}
		};
		NexageAdManager.setLocationAwareness(deviceLocation);
		
		mInterstitialAd = new NexageInterstitial((String) serverParams.get(POSITION_KEY), (Activity) context, this);
		NexageAdManager.setDCN((String) serverParams.get("dcn"));
		
		MoPubExtension.log("Creating a new Nexage Interstitial ID is " + mInterstitialAd.toString());
	}
	

	@Override
	protected void onInvalidate() {
		if (mInterstitialAd != null) {
			MoPubExtension.log("Destroying Nexage Interstitial ID is " + mInterstitialAd.toString());
            mInterstitialAd.setListener(null);
            mInterstitialAd = null;
            mInterstitialListener = null;
            MoPubExtension.log("Nexage interstitial removed.");
        }
	}

	@Override
	protected void showInterstitial() {
		if (mInterstitialAd != null)
			mInterstitialAd.display();
		else {
			MoPubExtension.log("Nexage mInterstitialAd is null! Aborting ...");
			mInterstitialListener.onInterstitialFailed(NETWORK_NO_FILL);
		}
	}

	@Override
	public void onInterstitialReceived(NexageInterstitial interstitial) {
		MoPubExtension.log("Nexage interstitial ad loaded successfully.");
		
		if (mInterstitialAd != null && mInterstitialListener != null)
			mInterstitialListener.onInterstitialLoaded();
	}

	@Override
	public void onInterstitialFailedToReceive(NexageInterstitial interstitial) {
		MoPubExtension.log("Nexage interstitial ad failed to load.");

		if (mInterstitialAd != null && mInterstitialListener != null)
			mInterstitialListener.onInterstitialFailed(NETWORK_NO_FILL);
	}

	@Override
	public void onInterstitialDisplay(NexageInterstitial interstitial) {
		MoPubExtension.log("Showing Nexage interstitial ad.");
		
		if (mInterstitialAd != null && mInterstitialListener != null)
			mInterstitialListener.onInterstitialShown();
	}

	@Override
	public void onInterstitialDismiss(NexageInterstitial interstitial) {
		MoPubExtension.log("Nexage interstitial ad dismissed.");
		
		if (mInterstitialAd != null && mInterstitialListener != null)
			mInterstitialListener.onInterstitialDismissed();
	}
	
	@Override
	public void onInterstitialClicked(NexageInterstitial interstitial) {
		MoPubExtension.log("Nexage interstitial clicked.");
		mInterstitialListener.onInterstitialClicked();
	}
	
	@Override
	public void onInterstitialCompleted(NexageInterstitial interstitial) {
		MoPubExtension.log("Nexage interstitial completed.");
	}
}
