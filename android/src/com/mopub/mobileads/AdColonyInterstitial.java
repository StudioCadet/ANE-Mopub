/*
* Copyright (c) 2010-2013, MoPub Inc.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are
* met:
*
* Redistributions of source code must retain the above copyright
* notice, this list of conditions and the following disclaimer.
*
* Redistributions in binary form must reproduce the above copyright
* notice, this list of conditions and the following disclaimer in the
* documentation and/or other materials provided with the distribution.
*
* Neither the name of 'MoPub Inc.' nor the names of its contributors
* may be used to endorse or promote products derived from this software
* without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
* TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
* PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package com.mopub.mobileads;

import static com.mopub.mobileads.MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR;

import java.util.Map;
import java.util.concurrent.Executor;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.AsyncTask;
import android.util.Log;

import com.jirbo.adcolony.*;
import com.mopub.common.util.Json;

/* 
* Tested with AdColony SDK 2.0.3.
* Currently installed SDK : 2.1.1
*/
public class AdColonyInterstitial extends CustomEventInterstitial implements AdColonyAdListener {
    /*
* We recommend passing the AdColony client options, app ID, all zone IDs, and current zone ID
* in the serverExtras Map by specifying Custom Event Data in MoPub's web interface.
*
* Please see AdColony's documentation for more information:
* https://github.com/AdColony/AdColony-Android-SDK/wiki/API-Details#configure-activity-activity-string-client_options-string-app_id-string-zone_ids-
*/
    private static final String DEFAULT_CLIENT_OPTIONS = "version:1.21,store:google";
    private static final String DEFAULT_APP_ID = "appd1be74c48c1b4ff28d";
    private static final String[] DEFAULT_ALL_ZONE_IDS = {"vz8efc58bf67ea42e3a7"};
    private static final String DEFAULT_ZONE_ID = "vz8efc58bf67ea42e3a7";
    private static final int MAX_RETRY_ATTEMPTS = 3;
    private static final int ATTEMPT_DELAY = 200;

    /*
* These keys are intended for MoPub internal use. Do not modify.
*/
    private static final String CLIENT_OPTIONS_KEY = "clientOptions";
    private static final String APP_ID_KEY = "appId";
    private static final String ALL_ZONE_IDS_KEY = "allZoneIds";
    private static final String ZONE_ID_KEY = "zoneId";

    private static boolean isAdColonyConfigured = false;

    private CustomEventInterstitialListener mCustomEventInterstitialListener;
    private final Handler mHandler;
    private AdColonyVideoAd mAdColonyVideoAd;
    private final ScheduledThreadPoolExecutor mScheduledThreadPoolExecutor;
    private boolean mIsLoading;
    /** A count of the attempts to show an add when calling showInterstitial(). */
    private int retryCount = 0;

    public AdColonyInterstitial() {
        mScheduledThreadPoolExecutor = new ScheduledThreadPoolExecutor(10);
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

        String clientOptions = DEFAULT_CLIENT_OPTIONS;
        String appId = DEFAULT_APP_ID;
        String[] allZoneIds = DEFAULT_ALL_ZONE_IDS;
        String zoneId = DEFAULT_ZONE_ID;

        mCustomEventInterstitialListener = customEventInterstitialListener;

        if (extrasAreValid(serverExtras)) {
            clientOptions = serverExtras.get(CLIENT_OPTIONS_KEY);
            appId = serverExtras.get(APP_ID_KEY);
            allZoneIds = extractAllZoneIds(serverExtras);
            zoneId = serverExtras.get(ZONE_ID_KEY);
        }

        if (!isAdColonyConfigured) {
        	
        	// Note : tries to instantiate the native libraries needed in AdColony.configure() to avoid crashes inside the SDK.
        	// If one of this libraries is unavailable, a UnsatisfiedLinkError will be thrown and caught
        	Log.d("MoPub", "Trying to initialize native libraries ...");
        	try {
	        	new Handler();
	        	Executor test = AsyncTask.THREAD_POOL_EXECUTOR;
	        	test.getClass();
	        	Log.d("MoPub", "Native libraries successfully initialized!");
	        	
	        	Log.d("MoPub", "AdColony not configured yet... configuring ...");
	        	AdColony.configure((Activity)context, clientOptions, appId, allZoneIds);
	            Log.d("MoPub", "AdColony successfully configured!");
	            isAdColonyConfigured = true;
        	}
        	catch(Error e) {
        		Log.d("MoPub", "Failed to load native libraries! aborting ...");
        		Log.d("MoPub", e.toString());
        		mCustomEventInterstitialListener.onInterstitialFailed(ADAPTER_CONFIGURATION_ERROR);
        		return;
        	}
        }

        mAdColonyVideoAd = new AdColonyVideoAd(zoneId);
        mAdColonyVideoAd.withListener(AdColonyInterstitial.this);

        scheduleOnInterstitialLoaded();
    }

    @Override
    protected void showInterstitial() {
        if (mAdColonyVideoAd.isReady()) {
            mAdColonyVideoAd.show();
        } else {
            Log.d("MoPub", "Tried to show a AdColony interstitial ad before it finished loading. Please try again.");
            
            if(retryCount < MAX_RETRY_ATTEMPTS) {
            	retryCount++;
            	Log.d("MoPub", "Retrying, attempt " + retryCount + " ...");
            	
            	Runnable showAttempt = new Runnable() {
					@Override
					public void run() {
						showInterstitial();
					}
				};
				
				Handler delayedCall = new Handler();
				delayedCall.postDelayed(showAttempt, ATTEMPT_DELAY);
            }
            else {
            	Log.d("MoPub", "Too many attempts have failed, aborting");
            	retryCount = 0;
            	// Aborting the video by dissmissing the interstitial. This will trigger onComplete() even if we don't have watched a video.
            	mCustomEventInterstitialListener.onInterstitialDismissed();
            }
        }
    }

    @Override
    protected void onInvalidate() {
        if (mAdColonyVideoAd != null) {
            mAdColonyVideoAd.withListener(null);
        }

        mScheduledThreadPoolExecutor.shutdownNow();
        mIsLoading = false;
    }

    private boolean extrasAreValid(Map<String, String> extras) {
        return extras.containsKey(CLIENT_OPTIONS_KEY)
                && extras.containsKey(APP_ID_KEY)
                && extras.containsKey(ALL_ZONE_IDS_KEY)
                && extras.containsKey(ZONE_ID_KEY);
    }

    private String[] extractAllZoneIds(Map<String, String> serverExtras) {
        String[] result = Json.jsonArrayToStringArray(serverExtras.get(ALL_ZONE_IDS_KEY));

        // AdColony requires at least one valid String in the allZoneIds array.
        if (result.length == 0) {
            result = new String[]{""};
        }

        return result;
    }

    private void scheduleOnInterstitialLoaded() {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                if (mAdColonyVideoAd.isReady()) {
                    Log.d("MoPub", "AdColony interstitial ad successfully loaded.");
                    mIsLoading = false;
                    mScheduledThreadPoolExecutor.shutdownNow();
                    mHandler.post(new Runnable() {
                        @Override
                        public void run() {
                            mCustomEventInterstitialListener.onInterstitialLoaded();
                        }
                    });
                }
            }
        };

        if (!mIsLoading) {
            mScheduledThreadPoolExecutor.scheduleAtFixedRate(runnable, 1, 1, TimeUnit.SECONDS);
            mIsLoading = true;
        }
    }

    /*
* AdColonyAdListener implementation
*/

    @Override
    public void onAdColonyAdStarted(AdColonyAd adColonyAd) {
        Log.d("MoPub", "AdColony interstitial ad shown.");
        mHandler.post(new Runnable() {
            @Override
            public void run() {
                mCustomEventInterstitialListener.onInterstitialShown();
            }
        });
    }

    @Override
    public void onAdColonyAdAttemptFinished(AdColonyAd adColonyAd) {
        Log.d("MoPub", "AdColony interstitial ad dismissed.");
        mHandler.post(new Runnable() {
            @Override
            public void run() {
                mCustomEventInterstitialListener.onInterstitialDismissed();
            }
        });
    }
}
