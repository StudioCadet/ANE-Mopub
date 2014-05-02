package com.mopub.mobileads;

import java.util.HashMap;
import java.util.Map;

import android.app.Activity;
import android.content.Context;

import com.chartboost.sdk.Chartboost;
import com.chartboost.sdk.Chartboost.CBAgeGateConfirmation;
import com.chartboost.sdk.ChartboostDelegate;
import com.chartboost.sdk.Model.CBError.CBClickError;
import com.chartboost.sdk.Model.CBError.CBImpressionError;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

/*
 * Tested with Chartboost SDK 3.1.5.
 */
class ChartboostInterstitial extends CustomEventInterstitial {
    /*
     * These keys are intended for MoPub internal use. Do not modify.
     */
    public static final String APP_ID_KEY = "appId";
    public static final String APP_SIGNATURE_KEY = "appSignature";
    public static final String LOCATION_KEY = "location";
    public static final String LOCATION_DEFAULT = "Default";
    
    private static boolean initialized = false;
    
    
    private String appId;
    private String appSignature;
    private String location;
    
    
    /**
     * Initializes Chartboost's global settings and starts a Chartboost session only once.
     */
    private static void initChartboost() {
    	if(initialized) return;
//    	Chartboost.sharedChartboost().getPreferences().setImpressionsUseActivities(false);
    	Chartboost.sharedChartboost().startSession();
        initialized = true;
    }
    
    /*
     * Note: Chartboost recommends implementing their specific Activity lifecycle callbacks in your
     * Activity's onStart(), onStop(), onBackPressed() methods for proper results. Please see their
     * documentation for more information.
     */

    ChartboostInterstitial() {
        location = LOCATION_DEFAULT;
    }

    static SingletonChartboostDelegate getDelegate() {
        return SingletonChartboostDelegate.instance;
    }

    /*
     * Abstract methods from CustomEventInterstitial
     */
    @Override
    protected void loadInterstitial(Context context, CustomEventInterstitialListener interstitialListener,
                                    Map<String, Object> localExtras, Map<String, String> serverExtras) {
    	
    	// Check context :
        if (!(context instanceof Activity)) {
        	MoPubExtension.log("Chartboost loadInterstitial() : the given context must be an instance of Activity ! (cotext:" + context + ")");
            interstitialListener.onInterstitialFailed(MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR);
            return;
        }
        
        // Check server extras :
        if (!extrasAreValid(serverExtras)) {
        	MoPubExtension.log("Chartboost loadInterstitial() : server extras are invalid !");
            interstitialListener.onInterstitialFailed(MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR);
            return;
        }
        
        Activity activity = (Activity) context;
        Chartboost chartboost = Chartboost.sharedChartboost();
        
        this.appId = serverExtras.get(APP_ID_KEY);
        this.appSignature = serverExtras.get(APP_SIGNATURE_KEY);
        this.location = serverExtras.containsKey(LOCATION_KEY) ? serverExtras.get(LOCATION_KEY) : LOCATION_DEFAULT;
        
        MoPubExtension.log("Chartboost loadInterstitial() : appID=" + appId + " ; appSignature=" + appSignature + " ; location=" + location);
        
        if (getDelegate().hasLocation(location) && getDelegate().getListener(location) != interstitialListener) {
        	MoPubExtension.log("Chartboost loadInterstitial() : a listener is already registered for the given location. Failing.");
            interstitialListener.onInterstitialFailed(MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR);
            return;
        }

        getDelegate().registerListener(location, interstitialListener);
        chartboost.onCreate(activity, appId, appSignature, getDelegate());
        chartboost.onStart(activity);
        initChartboost();
        
        MoPubExtension.log("Caching Chartboost interstitial ad for location " + location + ".");
        chartboost.cacheInterstitial(location);
    }

    @Override
    protected void showInterstitial() {
        MoPubExtension.log("Showing Chartboost interstitial ad for location " + location + ".");
        Chartboost.sharedChartboost().showInterstitial(location);
    }

    @Override
    protected void onInvalidate() {
    	MoPubExtension.log("Invalidating Chartboost interstitial ad for location " + location + ".");
        getDelegate().unregisterListener(location);
    }

    private boolean extrasAreValid(Map<String, String> serverExtras) {
        return serverExtras.containsKey(APP_ID_KEY) && serverExtras.containsKey(APP_SIGNATURE_KEY);
    }
    
    
    //////////////////////////
    // CHARTBOOST DELEGATES //
    //////////////////////////
    
    private static class SingletonChartboostDelegate implements ChartboostDelegate {
        
    	
    	///////////////
    	// SINGLETON //
    	///////////////
    	
    	private static final CustomEventInterstitialListener NULL_LISTENER = new CustomEventInterstitialListener() {
            @Override public void onInterstitialLoaded() { }
            @Override public void onInterstitialFailed(MoPubErrorCode errorCode) { }
            @Override public void onInterstitialShown() { }
            @Override public void onInterstitialClicked() { }
            @Override public void onLeaveApplication() { }
            @Override public void onInterstitialDismissed() { }
        };
        
        static SingletonChartboostDelegate instance = new SingletonChartboostDelegate();
        
        private Map<String, CustomEventInterstitialListener> listenerForLocation = new HashMap<String, CustomEventInterstitialListener>();

        public void registerListener(String location, CustomEventInterstitialListener interstitialListener) {
        	MoPubExtension.log("Registering a Chartboost delegate for location " + location + " : " + interstitialListener);
            listenerForLocation.put(location, interstitialListener);
        }
        
        CustomEventInterstitialListener getListener(String location) {
        	CustomEventInterstitialListener listener = listenerForLocation.get(location);
        	return listener != null ? listener : NULL_LISTENER;
        }

        public boolean hasLocation(String location) {
            return listenerForLocation.containsKey(location);
        }
        
        public void unregisterListener(String location) {
        	MoPubExtension.log("Unregistering a Chartboost delegate for location " + location);
        	listenerForLocation.remove(location);
        }
        
        
        //////////////////////
        // DELEGATE METHODS //
        //////////////////////
        
        @Override
        public boolean shouldDisplayInterstitial(String location) {
            return true;
        }

        @Override
        public boolean shouldRequestInterstitial(String location) {
            return true;
        }

        @Override
        public boolean shouldRequestInterstitialsInFirstSession() {
            return true;
        }

        @Override
        public void didCacheInterstitial(String location) {
            MoPubExtension.log("Chartboost interstitial ad for location " + location + " loaded successfully.");
            getListener(location).onInterstitialLoaded();
        }

        @Override
        public void didDismissInterstitial(String location) {
            // Note that this method is fired before didCloseInterstitial and didClickInterstitial.
            MoPubExtension.log("Chartboost interstitial ad for location " + location + " dismissed.");
            getListener(location).onInterstitialDismissed();
        }

        @Override
        public void didCloseInterstitial(String location) {
        	MoPubExtension.log("Chartboost interstitial ad for location " + location + " closed.");
        }

        @Override
        public void didClickInterstitial(String location) {
            MoPubExtension.log("Chartboost interstitial ad for location " + location + " clicked.");
            getListener(location).onInterstitialClicked();
        }

        @Override
        public void didShowInterstitial(String location) {
            MoPubExtension.log("Chartboost interstitial ad for location " + location + " shown.");
            getListener(location).onInterstitialShown();
        }
        
        @Override
        public void didFailToLoadInterstitial(String location, CBImpressionError cbError) {
            MoPubExtension.log("Chartboost interstitial ad for location " + location + " failed to load : " + cbError.toString());
            getListener(location).onInterstitialFailed(MoPubErrorCode.NETWORK_NO_FILL);
        }
        
        @Override
		public void didFailToRecordClick(String location, CBClickError clickError) {
        	MoPubExtension.log("Chartboost interstitial ad for location " + location + " failed to receive click : " + clickError.toString());
		}

		@Override
		public boolean shouldPauseClickForConfirmation(CBAgeGateConfirmation arg0) {
			return false;
		}

        
        /*
         * More Apps delegate methods
         */
        @Override
        public boolean shouldDisplayLoadingViewForMoreApps() {
            return false;
        }

        @Override
        public boolean shouldRequestMoreApps() {
            return false;
        }

        @Override
        public boolean shouldDisplayMoreApps() {
            return false;
        }

        @Override
        public void didCacheMoreApps() {
        }

        @Override
        public void didDismissMoreApps() {
        }

        @Override
        public void didCloseMoreApps() {
        }

        @Override
        public void didClickMoreApps() {
        }

        @Override
        public void didShowMoreApps() {
        }

        @Override
		public void didFailToLoadMoreApps(CBImpressionError error) {
		}
    }
}
