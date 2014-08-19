package com.mopub.mobileads;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.util.Log;

import java.util.*;

import com.appsfire.adUnitJAR.sdk.AFAdSDK;
import com.appsfire.adUnitJAR.sdk.AFAdSDK.AFAdSDKError;
import com.appsfire.adUnitJAR.sdk.AFAdSDK.AFAdSDKModalType;
import com.appsfire.adUnitJAR.sdk.AFAdSDK.AFSDKFeature;
import com.appsfire.adUnitJAR.sdk.AFAdSDKEventsDelegate;
import com.appsfire.adUnitJAR.sdkimpl.AFSDKFactory;
import com.appsfire.adUnitJAR.sdkimpl.DefaultAFAdSDK;
import com.appsfire.adUnitJAR.exceptions.AFAdAlreadyDisplayedException;

import static com.mopub.mobileads.MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR;

/*
 * Appsfire interstitial adapter for Mopub
 */
public class AppsFireInterstitial extends CustomEventInterstitial implements AFAdSDKEventsDelegate {
	/** Tag for logging messages */
	public static String CLASS_TAG = "AppsFireInterstitial";
	
    /*
     * These keys are intended for MoPub internal use. Do not modify.
     */
    private static final String AF_SDK_KEY = "sdkKey";
    private static final String AF_IS_DEBUG = "isDebug";

    private CustomEventInterstitialListener mCustomEventInterstitialListener;
    private final Handler mHandler;
    private Context mContext;
    
	// Ad sdk instance
	private static AFAdSDK adSdk;

    public AppsFireInterstitial() {
    	mHandler = new Handler();
    }

    @Override
    protected void loadInterstitial(Context context,
                                    CustomEventInterstitialListener customEventInterstitialListener,
                                    Map<String, Object> localExtras,
                                    Map<String, String> serverExtras) {
        if (!(context instanceof Activity)) {
            customEventInterstitialListener.onInterstitialFailed(ADAPTER_CONFIGURATION_ERROR);
            return;
        }

        String sdkKey = null;
        boolean isDebug = false;

        mCustomEventInterstitialListener = customEventInterstitialListener;
        mContext = context;
        
        if (serverExtras.containsKey(AF_SDK_KEY) && serverExtras.containsKey(AF_IS_DEBUG)) {
        	sdkKey = serverExtras.get(AF_SDK_KEY);
        	isDebug = serverExtras.get(AF_IS_DEBUG).equalsIgnoreCase("0") == false; 
        }
        else {
        	Log.e(CLASS_TAG, "Server extra parameters are missing! Ensure there is \"" + AF_SDK_KEY + "\" and \"" + AF_IS_DEBUG + "\" keys and retry.");
        	mCustomEventInterstitialListener.onInterstitialFailed(MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR);
        }

        if (adSdk == null) {
        	// Initialize SDK
        	Log.i(CLASS_TAG, "Initializing AppsFire SDK with key : " + sdkKey + " (isDebug ? " + isDebug + ") ...");
        	adSdk = AFSDKFactory.getAFAdSDK().
			        setFeatures(Arrays.asList(AFSDKFeature.AFSDKFeatureMonetization)).
					setAPIKey(sdkKey).
					setEventsDelegate(this).
		        	setDebugModeEnabled(isDebug);
        	adSdk.prepare(context);
        }
    }

    @Override
    protected void showInterstitial() {
    	// Check if a modal ad of type Sushi is available
		if (adSdk.isAModalAdOfTypeAvailable(AFAdSDKModalType.AFAdSDKModalTypeSushi)) {
			Log.i(CLASS_TAG, "A Sushi ad is ready, trying to request it ...");
			try {
				// Request modal ad
        	    adSdk.requestModalAd(AFAdSDKModalType.AFAdSDKModalTypeSushi, mContext);
        	    Log.i(CLASS_TAG, "Sushi ad requested.");
			} catch (AFAdAlreadyDisplayedException e) {
				Log.w(CLASS_TAG, "Exception : " + e);
				e.printStackTrace();
			}
		}
		else {
			Log.i(CLASS_TAG, "No Sushi ad available !");
			mCustomEventInterstitialListener.onInterstitialFailed(MoPubErrorCode.NO_FILL);
		}
    }

    @Override
    protected void onInvalidate() {
    	Log.i(CLASS_TAG, "onInvalidate");
    }

    /*
     * AFAdSDKEventsDelegate implementation
     */

	@Override
	public void onEngageSDKInitialized() {
		// SDK initialized
		Log.i (CLASS_TAG, "onEngageSDKInitialized");
	}

	@Override
	public void onAdUnitInitialized() {
		// Ad unit initialized
		Log.i (CLASS_TAG, "AppsFire SDK initialized (" + adSdk.isInitialized() + "). Starting it ...");
		adSdk.onStart(mContext);
	}
	
	@Override
	public void onAdsLoaded() {
		// Ads metadata downloaded
		Log.i (CLASS_TAG, "onAdsLoaded");
	}

	@Override
	public void onModalAdAvailable() {
		// A modal ad (sushi interstitial) is available
		Log.i (CLASS_TAG, "onModalAdAvailable");
		
		mHandler.post(new Runnable() {
            @Override
            public void run() {
                mCustomEventInterstitialListener.onInterstitialLoaded();
            }
        });
	}
	
	@Override
	public void onInStreamAdAvailable() {
		// One or more in-stream (sashimi) ads are available
		Log.i (CLASS_TAG, "onInStreamAdAvailable");
	}
		
	@Override
	public void onModalAdPreDisplay() {
		// A modal ad is about to display
		Log.i (CLASS_TAG, "onModalAdPreDisplay");
	}

	@Override
	public void onModalAdDisplayed() {
		// A modal ad is displayed
		Log.i (CLASS_TAG, "onModalAdDisplayed");
		
		mHandler.post(new Runnable() {
            @Override
            public void run() {
                mCustomEventInterstitialListener.onInterstitialShown();
            }
        });
	}

	@Override
	public void onModalAdFailedToDisplay(AFAdSDKError errCode) {
		// A modal ad failed to display
		Log.i (CLASS_TAG, "onModalAdFailedToDisplay [" + errCode.getCode() + "] " + errCode.getDescription());
		
		mHandler.post(new Runnable() {
            @Override
            public void run() {
                mCustomEventInterstitialListener.onInterstitialFailed(MoPubErrorCode.INTERNAL_ERROR);
            }
        });
	}

	@Override
	public void onModalAdPreDismiss() {
		// A modal ad is about to close
		Log.i (CLASS_TAG, "onModalAdPreDismiss");
		
    	new Thread() {
    		public void run() {
    			((DefaultAFAdSDK) adSdk).publishEvents();
    		}
    	}.run();
	}

	@Override
	public void onModalAdDismissed() {
		// A modal ad has closed
		Log.i (CLASS_TAG, "onModalAdDismissed");
		
		mHandler.post(new Runnable() {
            @Override
            public void run() {
                mCustomEventInterstitialListener.onInterstitialDismissed();
            }
        });
	}
}
