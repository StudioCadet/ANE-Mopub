package com.mopub.mobileads;

import android.app.Activity;
import android.content.Context;
import android.text.TextUtils;

import com.mopub.common.MoPub;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.unity3d.ads.IUnityAdsListener;
import com.unity3d.ads.UnityAds;
import com.unity3d.ads.UnityAds.FinishState;

import java.util.Map;

public class UnityInterstitial extends CustomEventInterstitial implements IUnityAdsListener {

    private static boolean sInitialized = false;
    private CustomEventInterstitialListener mCustomEventInterstitialListener;
    private Activity mLauncherActivity;
    private String mPlacementId = UnityRouter.DEFAULT_PLACEMENT_ID;

    @Override
    protected void loadInterstitial(Context context, CustomEventInterstitialListener customEventInterstitialListener, Map<String, Object> localExtras, Map<String, String> serverExtras) {
        MoPubExtension.log("Trying to load a UnityAds interstitial ad ...");
    	
    	if (sInitialized) {
        	MoPubExtension.log("UnityAds is already initialized, skipping init.");
            return;
        }

        mCustomEventInterstitialListener = customEventInterstitialListener;

        if (context == null || !(context instanceof Activity)) {
            mCustomEventInterstitialListener.onInterstitialFailed(MoPubErrorCode.NETWORK_INVALID_STATE);
            return;
        }
        mLauncherActivity = (Activity) context;

        if (!UnityRouter.initUnityAds(serverExtras, mLauncherActivity, this, new Runnable() {
            public void run() {
            	MoPubExtension.logE("Failed to initialize UnityAds SDK.");
                mCustomEventInterstitialListener.onInterstitialFailed(MoPubErrorCode.NETWORK_INVALID_STATE);
            }
        })) {
            return;
        }

        mPlacementId = UnityRouter.placementIdForServerExtras(serverExtras);
        
        MoPubExtension.log("Initializing UnityAds placement with ID " + mPlacementId + " ...");
        UnityRouter.initPlacement(mPlacementId, new Runnable() {
            public void run() {
            	MoPubExtension.log("UnityAds interstitial failed to init placement!");
                mCustomEventInterstitialListener.onInterstitialFailed(MoPubErrorCode.NETWORK_INVALID_STATE);
            }
        }, new Runnable() {
            public void run() {
            	MoPubExtension.log("UnityAds interstitial loaded.");
                mCustomEventInterstitialListener.onInterstitialLoaded();
            }
        });

        sInitialized = true;
    }

    @Override
    protected void showInterstitial() {
        if (UnityAds.isReady(mPlacementId) && mLauncherActivity != null) {
        	MoPubExtension.log("Showing a UnityAds interstitial ad ...");
            UnityAds.show(mLauncherActivity, mPlacementId);
        }
        else
        	MoPubExtension.logW("UnityAds interstitial is not ready yet!");
    }

    @Override
    protected void onInvalidate() {

    }

    @Override
    public void onUnityAdsReady(String s) {
    	MoPubExtension.log("UnityAds interstitial loaded.");
        mCustomEventInterstitialListener.onInterstitialLoaded();
    }

    @Override
    public void onUnityAdsStart(String s) {
    	MoPubExtension.log("UnityAds interstitial showing.");
        mCustomEventInterstitialListener.onInterstitialShown();
    }

    @Override
    public void onUnityAdsFinish(String s, UnityAds.FinishState finishState) {
    	MoPubExtension.log("UnityAds interstitial ad displayed successfully. State :" + finishState + ".");
    	mCustomEventInterstitialListener.onInterstitialDismissed();
    }

    @Override
    public void onUnityAdsError(UnityAds.UnityAdsError unityAdsError, String s) {
    	MoPubErrorCode errorCode;
        switch (unityAdsError) {
            case VIDEO_PLAYER_ERROR:
                errorCode = MoPubErrorCode.VIDEO_PLAYBACK_ERROR;
                break;
            case INTERNAL_ERROR:
                errorCode = MoPubErrorCode.INTERNAL_ERROR;
                break;
            default:
                errorCode = MoPubErrorCode.NETWORK_INVALID_STATE;
                break;
        }
        MoPubExtension.logW("Error with UnityAds interstitial : " + unityAdsError + ", " + s);
        mCustomEventInterstitialListener.onInterstitialFailed(errorCode);
    }
}
