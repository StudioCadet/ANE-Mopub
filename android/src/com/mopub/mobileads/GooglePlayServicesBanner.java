package com.mopub.mobileads;

import static com.google.android.gms.ads.AdSize.BANNER;
import static com.google.android.gms.ads.AdSize.FULL_BANNER;
import static com.google.android.gms.ads.AdSize.LEADERBOARD;
import static com.google.android.gms.ads.AdSize.MEDIUM_RECTANGLE;
import static com.mopub.mobileads.MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR;
import static com.mopub.mobileads.MoPubErrorCode.NETWORK_NO_FILL;

import java.util.Map;

import android.content.Context;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

/*
 * Compatible with version 5.0.89 of the Google Play Services SDK.
 */

// Note: AdMob ads will now use this class as Google has deprecated the AdMob SDK.

class GooglePlayServicesBanner extends CustomEventBanner {
    /*
     * These keys are intended for MoPub internal use. Do not modify.
     */
    private static final String AD_UNIT_ID_KEY = "adUnitID";
    private static final String AD_WIDTH_KEY = "adWidth";
    private static final String AD_HEIGHT_KEY = "adHeight";

    private CustomEventBannerListener mBannerListener;
    private AdView mGoogleAdView;
    
    
    ///////////////////
    // MOPUB ADAPTER //
    ///////////////////

    @Override
    protected void loadBanner(final Context context, final CustomEventBannerListener customEventBannerListener, final Map<String, Object> localExtras, final Map<String, String> serverExtras) {
        mBannerListener = customEventBannerListener;
        
        final String adUnitId;
        final int adWidth;
        final int adHeight;

        if (extrasAreValid(serverExtras)) {
            adUnitId = serverExtras.get(AD_UNIT_ID_KEY);
            adWidth = Integer.parseInt(serverExtras.get(AD_WIDTH_KEY));
            adHeight = Integer.parseInt(serverExtras.get(AD_HEIGHT_KEY));
        } else {
        	MoPubExtension.log("Invalid server extras! are missing key : " + AD_UNIT_ID_KEY + ". Aborting.");
            mBannerListener.onBannerFailed(ADAPTER_CONFIGURATION_ERROR);
            return;
        }
        MoPubExtension.log("Using ad unit ID : " + adUnitId + ".");
        
        mGoogleAdView = new AdView(context);
        mGoogleAdView.setAdListener(new AdViewListener());
        mGoogleAdView.setAdUnitId(adUnitId);
        
        final AdSize adSize = calculateAdSize(adWidth, adHeight);
        if (adSize == null) {
            mBannerListener.onBannerFailed(ADAPTER_CONFIGURATION_ERROR);
            return;
        }

        MoPubExtension.log("Setting ad size to " + adSize.toString() + " (requested size : " + adWidth + "x" + adHeight + ").");
        mGoogleAdView.setAdSize(adSize);
        
        try {
        	MoPubExtension.log("Loading an AdMob banner ...");
            mGoogleAdView.loadAd(AdMobUtils.getAdRequest(context));
        } catch (NoClassDefFoundError e) {
            // This can be thrown by Play Services on Honeycomb.
            mBannerListener.onBannerFailed(NETWORK_NO_FILL);
        }
    }

    @Override
    protected void onInvalidate() {
    	if(mGoogleAdView == null)
    		return;
    	
    	MoPubExtension.log("Removing AdMob banner ...");
    	mGoogleAdView.setAdListener(null);
		mGoogleAdView.destroy();
		mGoogleAdView = null;
		
		MoPubExtension.log("AdMob banner removed.");
    }

    private boolean extrasAreValid(Map<String, String> serverExtras) {
        try {
            Integer.parseInt(serverExtras.get(AD_WIDTH_KEY));
            Integer.parseInt(serverExtras.get(AD_HEIGHT_KEY));
        } catch (NumberFormatException e) {
            return false;
        }

        return serverExtras.containsKey(AD_UNIT_ID_KEY);
    }

    private AdSize calculateAdSize(int width, int height) {
        // Use the smallest AdSize that will properly contain the adView
        if (width <= BANNER.getWidth() && height <= BANNER.getHeight()) {
            return BANNER;
        } else if (width <= MEDIUM_RECTANGLE.getWidth() && height <= MEDIUM_RECTANGLE.getHeight()) {
            return MEDIUM_RECTANGLE;
        } else if (width <= FULL_BANNER.getWidth() && height <= FULL_BANNER.getHeight()) {
            return FULL_BANNER;
        } else if (width <= LEADERBOARD.getWidth() && height <= LEADERBOARD.getHeight()) {
            return LEADERBOARD;
        } else {
            return null;
        }
    }

    
    ///////////////////////////////////
    // GOOGLE PLAY SERVICES LISTENER //
    ///////////////////////////////////
    
    private class AdViewListener extends AdListener {
        /*
         * Google Play Services AdListener implementation
         */
        @Override
        public void onAdClosed() {

        }

        @Override
        public void onAdFailedToLoad(int errorCode) {
        	if(AdRequest.ERROR_CODE_INTERNAL_ERROR == errorCode) {
        		MoPubExtension.log("AdMob banner ad failed to load (internal error)");
                if (mBannerListener != null) {
                    mBannerListener.onBannerFailed(MoPubErrorCode.NETWORK_INVALID_STATE);
                }
        	}
        	else if(AdRequest.ERROR_CODE_INVALID_REQUEST == errorCode) {
        		MoPubExtension.log("AdMob banner ad failed to load (invalid request)");
                if (mBannerListener != null) {
                    mBannerListener.onBannerFailed(MoPubErrorCode.NETWORK_INVALID_STATE);
                }
        	}
        	else if(AdRequest.ERROR_CODE_NETWORK_ERROR == errorCode) {
        		MoPubExtension.log("AdMob banner ad failed to load (network error)");
                if (mBannerListener != null) {
                    mBannerListener.onBannerFailed(MoPubErrorCode.NETWORK_INVALID_STATE);
                }
        	}
        	else if(AdRequest.ERROR_CODE_NO_FILL == errorCode) {
        		MoPubExtension.log("AdMob banner ad failed to load (no fill)");
                if (mBannerListener != null) {
                    mBannerListener.onBannerFailed(MoPubErrorCode.NETWORK_NO_FILL);
                }
        	}
        	else {
        		MoPubExtension.log("AdMob banner ad failed to load (unknown error code : " + errorCode + ")");
                if (mBannerListener != null) {
                    mBannerListener.onBannerFailed(MoPubErrorCode.NETWORK_INVALID_STATE);
                }
        	}
        }

        @Override
        public void onAdLeftApplication() {
        	MoPubExtension.log("AdMob banner ad clicked.");
            if (mBannerListener != null) {
            	mBannerListener.onBannerClicked();
            }
        }

        @Override
        public void onAdLoaded() {
        	MoPubExtension.log("AdMob banner ad loaded successfully. Showing ad...");
            if (mBannerListener != null) {
                mBannerListener.onBannerLoaded(mGoogleAdView);
            }
        }

        @Override
        public void onAdOpened() {
        	MoPubExtension.log("AdMob banner ad clicked.");
            if (mBannerListener != null) {
                mBannerListener.onBannerClicked();
            }
        }
    }

    @Deprecated // for testing
    AdView getGoogleAdView() {
        return mGoogleAdView;
    }
}
