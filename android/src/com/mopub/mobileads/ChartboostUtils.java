package com.mopub.mobileads;

import java.util.HashMap;
import java.util.Map;

import android.app.Activity;

import com.chartboost.sdk.Chartboost;
import com.chartboost.sdk.Libraries.CBLogging.Level;
import com.mopub.mobileads.CustomEventInterstitial.CustomEventInterstitialListener;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.utils.ExtraUtils;
import com.sticksports.nativeExtensions.utils.PackageUtils;

/**
 * An utility class for Chartboost interstitials.
 */
public class ChartboostUtils {

	/** The meta-data entry key that should contain Chartboost's app ID. */
	private static final String META_DATA_APP_ID = "CHARTBOOST_APP_ID";
	/** The meta-data entry key that should contain Chartboost's app signature. */
	private static final String META_DATA_APP_SIGNATURE = "CHARTBOOST_APP_SIGNATURE";

	/** The key used by MoPub to pass the ad location in the custom event data. */
	private static final String LOCATION_KEY = "location";

	/** The default location for a Chartboost interstitial ad. */
	private static final String LOCATION_DEFAULT = "Default";

	/** The map of registered listeners. */
	private static Map<String, CustomEventInterstitialListener> listeners = new HashMap<String, CustomEventInterstitial.CustomEventInterstitialListener>();

	/** A no-op listener to be used instead when something goes wrong and no listener is found. */
	private static CustomEventInterstitialListener NULL_LISTENER;


	//////////
	// INIT //
	//////////

	/**
	 * Initializes Chartboost SDK with the App ID and Signature from the application's manifest.
	 */
	public static void init(Activity activity) {

		// Get app ID and signature from manifest :
		String appId = (String) PackageUtils.getMetaData(activity, META_DATA_APP_ID);
		String appSignature = (String) PackageUtils.getMetaData(activity, META_DATA_APP_SIGNATURE);

		if(appId == null || appSignature == null) {
			MoPubExtension.logE("Chartboost meta data is missing ! Aborting Chartboost initialization.");
			return;
		}
		
		// Prepare null listener :
		NULL_LISTENER = new CustomEventInterstitialListener() {
			@Override public void onInterstitialLoaded() { }
			@Override public void onInterstitialFailed(MoPubErrorCode errorCode) { }
			@Override public void onInterstitialShown() { }
			@Override public void onInterstitialClicked() { }
			@Override public void onLeaveApplication() { }
			@Override public void onInterstitialDismissed() { }
		};
		
		// Initialize chartboost :
		MoPubExtension.log("Initializing Chartboost SDK with app ID : " + appId + " (signature : " + appSignature + ") ...");
		Chartboost.startWithAppId(activity, appId, appSignature);
		Chartboost.setLoggingLevel(Level.ALL);
		Chartboost.setDelegate(new ChartboostDelegate());
		Chartboost.setImpressionsUseActivities(true); // -> use the declared activity in Android Manifest
		Chartboost.setShouldRequestInterstitialsInFirstSession(true); // -> allow Chartboost interstitial for the first session
		Chartboost.onCreate(activity);
		Chartboost.onStart(activity);
		
		MoPubExtension.log("Chartboost initialized.");
	}


	///////////////////////
	// CUSTOM EVENT DATA //
	///////////////////////

	/**
	 * Returns the ad location from MoPub's custom event data, or the default location if none is provided.
	 */
	public static String getLocationFromServerExtras(Map<String, String> extras) {
		String location = ExtraUtils.getString(extras, LOCATION_KEY);
		return location != null && location.length() > 0 ? location : LOCATION_DEFAULT; 
	}


	///////////////
	// LISTENERS //
	///////////////

	/**
	 * Registers the given listener for the given location and returns true on success. If another listener is already registered for the 
	 * location, false is returned.
	 */
	public static boolean registerListener(String location, CustomEventInterstitialListener listener) {
		if(listeners.containsKey(location) && listeners.get(location) != listener) 
			return false;

		MoPubExtension.log("Registering a MoPub listener for Chartboost location " + location + " : " + listener + ".");
		listeners.put(location, listener);
		return true;
	}

	/**
	 * Returns the registered listener for the given location. If no listener is registered, a no-op listener is returned.
	 */
	public static CustomEventInterstitialListener getListener(String location) {
		CustomEventInterstitialListener listener = listeners.get(location);
		if(listener == null) {
			MoPubExtension.logW("No registered MoPub listener for Chartboost location \"" + location + "\" !");
			return NULL_LISTENER;
		}
		return listener;
	}

	/**
	 * Unregisters any listener for the given location.
	 */
	public static void unregisterListener(String location) {
		MoPubExtension.log("Unregistering a MoPub listener for Chartboost location " + location + "...");
		listeners.remove(location);
	}
}
