package com.mopub.mobileads;

import java.util.Map;

import android.content.Context;

import com.jirbo.adcolony.AdColonyAd;
import com.jirbo.adcolony.AdColonyAdListener;
import com.jirbo.adcolony.AdColonyVideoAd;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class AdColonyInterstitial extends CustomEventInterstitial implements AdColonyAdListener {

	// PROPERTIES :
	/** The listener used by MoPub to monitor banner's lifecycle. */
	private CustomEventInterstitialListener listener;
	/** The Zone ID this ad is for. */
	private String zoneId;
	/** The AdColonyAd instance used to display an ad. */
	private AdColonyVideoAd ad;
	
	
	//////////////////////////
	// CUSTOM EVENT METHODS //
	//////////////////////////
	
	@Override
	protected void loadInterstitial(Context context, final CustomEventInterstitialListener listener, Map<String, Object> localExtras, Map<String, String> serverExtras) {
		
		this.listener = listener;
		
		// Get Zone ID :
		MoPubExtension.log("Getting AdColony's zone ID from server data ...");
		zoneId = AdColonyUtils.getZoneIdFromServerExtras(serverExtras);
		
		if(zoneId == null) {
			MoPubExtension.logE("Invalid AdColony parameters ! Configure network on MoPub to provide custom data : {\"zoneId\":\"YOUR_ZONE_ID\"}");
			listener.onInterstitialFailed(MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR);
			return;
		}
		
		// Create an Ad :
		MoPubExtension.log("Creating an AdColonyVideoAd for zone " + zoneId + " ...");
		ad = new AdColonyVideoAd(zoneId);
		ad.withListener(this);
		
		if(ad.isReady()) {
			MoPubExtension.log("An interstitial video ad is available.");
			listener.onInterstitialLoaded();
			return;
		}
		
		// Wait for an interstitial video ad :
		MoPubExtension.log("Waiting for an available video for zone " + zoneId + " ...");
		AdColonyUtils.onAdAvailable(zoneId, new Runnable() {
			@Override
			public void run() {
				MoPubExtension.log("AdColony interstitial video ad available for zone " + zoneId + ".");
				listener.onInterstitialLoaded();
			}
		});
	}

	@Override
	protected void onInvalidate() {
		if(ad != null) 
			ad.withListener(null);
		ad = null;
		listener = null;
	}
	
	@Override
	protected void showInterstitial() {
		MoPubExtension.log("Displaying AdColony video ad ...");
		ad.show();
	}
	
	
	///////////////////////////////////
	// AD COLONY AD LISTENER METHODS //
	///////////////////////////////////

	@Override
	public void onAdColonyAdAttemptFinished(AdColonyAd ad) {
		if(ad.shown()) {
			MoPubExtension.log("AdColony interstitial video ad displayed successfully.");
			listener.onInterstitialDismissed();
		}
		else {
			String adState = ad.noFill() ? "no fill" : ad.canceled() ? "cancelled" : ad.skipped() ? "skipped" : "unknown";
			MoPubExtension.log("AdColony interstitial video ad displaying attempt failed (" + adState + ").");
			listener.onInterstitialFailed(ad.noFill() ? MoPubErrorCode.NETWORK_NO_FILL : ad.canceled() ? MoPubErrorCode.CANCELLED : MoPubErrorCode.NETWORK_INVALID_STATE);
		}
	}

	@Override
	public void onAdColonyAdStarted(AdColonyAd ad) {
		MoPubExtension.log("AdColony interstitial video ad started playing.");
		listener.onInterstitialShown();
	}

}
