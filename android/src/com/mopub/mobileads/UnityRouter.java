package com.mopub.mobileads;

import android.app.Activity;
import android.text.TextUtils;

import com.mopub.common.MoPub;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.unity3d.ads.IUnityAdsListener;
import com.unity3d.ads.UnityAds;
import com.unity3d.ads.metadata.MediationMetaData;

import java.util.Map;

public class UnityRouter {
    private static final String GAME_ID_KEY = "gameId";
    private static final String ZONE_ID_KEY = "zoneId";
    private static final String PLACEMENT_ID_KEY = "placementId";
    static final String DEFAULT_PLACEMENT_ID = null;
    private static String sPlacementId;

    static boolean initUnityAds(Map<String, String> serverExtras, Activity launcherActivity, IUnityAdsListener unityAdsListener, Runnable onInitFailed) {
        String gameId;
        if (serverExtras.containsKey(GAME_ID_KEY)) {
            gameId = serverExtras.get(GAME_ID_KEY);
            if (TextUtils.isEmpty(gameId)) {
            	MoPubExtension.logE("Empty " + GAME_ID_KEY + " provided in server extras !");
                onInitFailed.run();
                return false;
            }
        } else {
        	MoPubExtension.logE("No " + GAME_ID_KEY + " provided in server extras !");
            onInitFailed.run();
            return false;
        }

        MediationMetaData mediationMetaData = new MediationMetaData(launcherActivity);
        mediationMetaData.setName("MoPub");
        mediationMetaData.setVersion(MoPub.SDK_VERSION);
        mediationMetaData.commit();

        MoPubExtension.log("Initializing UnityAds SDK with game ID " + gameId);
        UnityAds.initialize(launcherActivity, gameId, unityAdsListener);
        return true;
    }

    static String placementIdForServerExtras(Map<String, String> serverExtras) {
        String placementId = null;
        if (serverExtras.containsKey(PLACEMENT_ID_KEY)) {
            placementId = serverExtras.get(PLACEMENT_ID_KEY);
        } else if (serverExtras.containsKey(ZONE_ID_KEY)) {
            placementId = serverExtras.get(ZONE_ID_KEY);
        }
        return TextUtils.isEmpty(placementId) ? DEFAULT_PLACEMENT_ID : placementId;
    }

    static void initPlacement(String placementId, Runnable onInitFailure, Runnable onInitSuccess) {
        if (TextUtils.isEmpty(placementId)) {
            onInitFailure.run();
        } else if (hasVideoAvailable(placementId)) {
            onInitSuccess.run();
        }
    }

    static boolean hasVideoAvailable(String placementId) {
        return UnityAds.isReady(placementId);
    }

}