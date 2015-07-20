package com.mopub.mobileads;

import static com.mopub.mobileads.MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR;
import static com.mopub.mobileads.MoPubErrorCode.NETWORK_NO_FILL;

import java.util.Map;

import android.content.Context;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.InterstitialAd;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

/*
 * Compatible with version 5.0.89 of the Google Play Services SDK.
 */

// Note: AdMob ads will now use this class as Google has deprecated the AdMob SDK.

public class GooglePlayServicesInterstitial extends CustomEventInterstitial {
    /*
     * These keys are intended for MoPub internal use. Do not modify.
     */
    private static final String AD_UNIT_ID_KEY = "adUnitID";

    private CustomEventInterstitialListener mInterstitialListener;
    private InterstitialAd mGoogleInterstitialAd;
    
    
    ///////////////////
    // MOPUB ADAPTER //
    ///////////////////

    @Override
    protected void loadInterstitial(Context context, CustomEventInterstitialListener interstitialListener, Map<String, Object> localExtras, Map<String, String> serverExtras) {

    	MoPubExtension.log("Creating an AdMob interstitial ad ...");
        mInterstitialListener = interstitialListener;

        // Get ad unit :
        final String adUnitId;
        if (serverExtras.containsKey(AD_UNIT_ID_KEY)) {
            adUnitId = serverExtras.get(AD_UNIT_ID_KEY);
        } else {
        	MoPubExtension.log("Server extras are missing key : " + AD_UNIT_ID_KEY + ". Aborting.");
            mInterstitialListener.onInterstitialFailed(ADAPTER_CONFIGURATION_ERROR);
            return;
        }
        MoPubExtension.log("Using ad unit ID : " + adUnitId + ".");
        
        mGoogleInterstitialAd = new InterstitialAd(context);
        mGoogleInterstitialAd.setAdListener(new AdMobAdListener());
        mGoogleInterstitialAd.setAdUnitId(adUnitId);

        try {
        	MoPubExtension.log("Loading an AdMob interstitial ad ...");
            mGoogleInterstitialAd.loadAd(AdMobUtils.getAdRequest(context));
        } catch (NoClassDefFoundError e) {
            // This can be thrown by Play Services on Honeycomb.
            mInterstitialListener.onInterstitialFailed(NETWORK_NO_FILL);
        }
    }

    @Override
    protected void showInterstitial() {
        if (mGoogleInterstitialAd.isLoaded()) {
        	MoPubExtension.log("Showing an AdMob interstitial ad ...");
            mGoogleInterstitialAd.show();
        } else {
        	MoPubExtension.log("Tried to show an AdMob interstitial ad before it finished loading. Aborting.");
        }
    }

    @Override
    protected void onInvalidate() {
        if (mGoogleInterstitialAd != null) {
            mGoogleInterstitialAd.setAdListener(null);
            mGoogleInterstitialAd = null;
            MoPubExtension.log("AdMob interstitial ad disposed.");
        }
    }
    
    
    ///////////////////////////////////
    // GOOGLE PLAY SERVICES LISTENER //
    ///////////////////////////////////

    private class AdMobAdListener extends AdListener {
        /*
    	 * Google Play Services AdListener implementation
    	 */
        @Override
        public void onAdClosed() {
            MoPubExtension.log("AdMob interstitial ad dismissed.");
            if (mInterstitialListener != null) {
                mInterstitialListener.onInterstitialDismissed();
            }
        }

        @Override
        public void onAdFailedToLoad(int errorCode) {
        	MoPubExtension.log("AdMob interstitial ad failed to load.");
            if (mInterstitialListener != null) {
                mInterstitialListener.onInterstitialFailed(NETWORK_NO_FILL);
            }
        }

        @Override
        public void onAdLeftApplication() {
        	MoPubExtension.log("AdMob interstitial ad clicked.");
            if (mInterstitialListener != null) {
                mInterstitialListener.onInterstitialClicked();
            }
        }

        @Override
        public void onAdLoaded() {
        	MoPubExtension.log("AdMob ad loaded successfully.");
            if (mInterstitialListener != null) {
                mInterstitialListener.onInterstitialLoaded();
            }
        }

        @Override
        public void onAdOpened() {
        	MoPubExtension.log("AdMob interstitial ad shown.");
            if (mInterstitialListener != null) {
                mInterstitialListener.onInterstitialShown();
            }
        }
    }
}
