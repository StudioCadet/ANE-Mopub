package com.mopub.mobileads;

import static com.mopub.mobileads.MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR;
import static com.mopub.mobileads.MoPubErrorCode.NETWORK_NO_FILL;

import java.util.Map;

import android.app.Activity;
import android.content.Context;
import android.location.Location;

import com.nexage.android.DeviceLocation;
import com.nexage.android.NexageAdManager;
import com.nexage.android.NexageInterstitial;
import com.nexage.android.NexageInterstitialListener;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class NexageAdapterInterstitial extends CustomEventInterstitial implements NexageInterstitialListener {

	private com.nexage.android.NexageInterstitial mInterstitialAd;
	private CustomEventInterstitialListener mInterstitialListener;
	public static final String LOCATION_KEY = "location";
	public static final String POSITION_KEY = "position";

	@Override
	protected void loadInterstitial(Context ctx, CustomEventInterstitialListener customEventInterstitialListener, final Map<String, Object> localParams,
			Map<String, String> serverParams) {
		mInterstitialListener = customEventInterstitialListener;
		MoPubExtension.log("MoPub calling Nexage for a Interstitial ad with position: " + (String) serverParams.get(POSITION_KEY));

		if (!(ctx instanceof Activity)) {
            mInterstitialListener.onInterstitialFailed(ADAPTER_CONFIGURATION_ERROR);
            return;
        }
		
		NexageAdManager.setIsMediation(true);

		Location location = extractLocation(localParams);
		if (location != null) {
			DeviceLocation myDeviceLocationImplementation = new DeviceLocation() {

				@Override
				public Location getLocation() {
					return (Location) localParams.get(LOCATION_KEY);
				}
			};
			
			NexageAdManager.setLocationAwareness(myDeviceLocationImplementation);
		}
		
		mInterstitialAd = new NexageInterstitial((String) serverParams.get(POSITION_KEY), (Activity) ctx, this);
		MoPubExtension.log("Creating a new Nexage Interstitial ID is " + mInterstitialAd.toString());
	}
	
	private Location extractLocation(Map<String, Object> localExtras) {
		Object location = localExtras.get(LOCATION_KEY);
		if (location instanceof Location) {
			return (Location) location;
		}
		return null;
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
