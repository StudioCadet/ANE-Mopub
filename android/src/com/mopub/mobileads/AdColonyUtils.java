package com.mopub.mobileads;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.Activity;

import com.jirbo.adcolony.AdColony;
import com.jirbo.adcolony.AdColonyAdAvailabilityListener;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.utils.ExtraUtils;
import com.sticksports.nativeExtensions.utils.PackageUtils;

public class AdColonyUtils {
	
	// CONSTANTS :
	/** The meta-data key containing AdColony's App ID. */
	private static final String META_DATA_APP_ID_KEY = "AD_COLONY_APP_ID";
	/** The meta-data key containing AdColony's zone IDs list. */
	private static final String META_DATA_ZONE_IDS_KEY = "AD_COLONY_ZONE_IDS";
	
	/** The custom event data key containing an ad's zone ID. */
	private static final String CUSTOM_DATA_ZONE_ID_KEY = "zoneId";
	
	// PROPERTIES :
	/** The ad availability listener instance used to monitor AdColony's ads availability. */
	private static AdColonyAvailabilityListener availabilityListener;
	
	
	/**
	 * Inits AdColony SDK.
	 */
	public static void init(Activity activity, String appVersion) {
		
		MoPubExtension.log("Initializing AdColony ...");
		
		// Get informations from package :
		String appId = (String) PackageUtils.getMetaData(activity, META_DATA_APP_ID_KEY);
		String zoneIds = (String) PackageUtils.getMetaData(activity, META_DATA_ZONE_IDS_KEY);
		if(appId == null || zoneIds == null) {
			MoPubExtension.logE("The manifest is missing the AdColony needed properties : \"" + META_DATA_APP_ID_KEY + "\" or \"" + META_DATA_ZONE_IDS_KEY + "\" ! Aborting AdColony SDK initializing.");
			return;
		}
		
		String clientOptions = "version:" + appVersion + ",store:google";
		
		MoPubExtension.log("Initializing AdColony SDK with : [appId:" + appId + ", zoneIds:[" + zoneIds + "], clientOptions:" + clientOptions + "] ...");
		AdColony.configure(activity, clientOptions, appId, zoneIds.split(","));
		
		// Watch ads availability events :
		MoPubExtension.log("Starting to watch for AdColony's ads availability ...");
		availabilityListener = new AdColonyAvailabilityListener(activity);
		AdColony.addAdAvailabilityListener(availabilityListener);
		
		MoPubExtension.log("AdColony initialized successfully.");
	}
	
	/**
	 * Returns the zone ID from the server extras, or null if none is found.
	 */
	public static String getZoneIdFromServerExtras(Map<String, String> extras) {
		return ExtraUtils.getString(extras, CUSTOM_DATA_ZONE_ID_KEY);
	}

	/**
	 * Returns true when ads are available for the given zone ID.
	 */
	public static boolean isAdAvailable(String zoneId) {
		return availabilityListener.isAdAvailable(zoneId);
	}
	
	/**
	 * Registers the given callback for when an ad becomes available for the desired zone ID.
	 * The Runnable will be executed on the Activity's UI thread.
	 */
	public static void onAdAvailable(String zoneId, Runnable interstitialFetchedRunnable) {
		availabilityListener.registerAdAvailableCallback(zoneId, interstitialFetchedRunnable);
	}
}


/**
 * An object that handles AdColony's ads availability changes.
 */
class AdColonyAvailabilityListener implements AdColonyAdAvailabilityListener {

	// PROPERTIES :
	/** A reference to the main activity. */
	private Activity activity;
	/** Stores ad availability for each zone. */
	private Map<String, Boolean> adAvailableForZone;
	/** Stores registered callbacks for ad availability for each zone. */
	private Map<String, List<Runnable>> callbacks;
	
	
	// CONSTRUCTOR 
	public AdColonyAvailabilityListener(Activity activity) {
		super();
		
		this.activity = activity;
		
		adAvailableForZone = new HashMap<String, Boolean>();
		callbacks = new HashMap<String, List<Runnable>>();
	}
	
	
	// METHODS :
	
	/**
	 * Returns true if an ad is available for the given zone ID.
	 */
	public boolean isAdAvailable(String zoneId) {
		Boolean available = adAvailableForZone.get(zoneId);
		return available != null && available;
	}
	
	/**
	 * Registers the given callback for when an ad becomes available for the given zone ID.
	 */
	public void registerAdAvailableCallback(String zoneId, Runnable interstitialFetchedRunnable) {
		List<Runnable> callbacksForZone = callbacks.get(zoneId);
		if(callbacksForZone == null) 
			callbacksForZone = new ArrayList<Runnable>();
		callbacksForZone.add(interstitialFetchedRunnable);
	}
	
	
	// AD COLONY AD AVAILABILITY LISTENER METHODS :
	
	@Override
	public void onAdColonyAdAvailabilityChange(boolean available, String zoneId) {
		MoPubExtension.log("AdColony's ad availability changed for zone ID " + zoneId + " : available ? " + available);
		adAvailableForZone.put(zoneId, available);
		
		if(!available) 
			return; // -> only call registered callbacks when an ad IS avaible
		
		List<Runnable> callbacksForZone = callbacks.get(zoneId);
		if(callbacksForZone == null || callbacksForZone.size() == 0)
			return;
		
		MoPubExtension.log("Calling " + callbacksForZone.size() + " registered callbacks ...");
		for(Runnable callback : callbacksForZone) {
			activity.runOnUiThread(callback);
		}
		
		callbacks.remove(zoneId);
	}
}
