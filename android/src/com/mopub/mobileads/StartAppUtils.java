package com.mopub.mobileads;

import android.app.Activity;

import com.startapp.android.publish.StartAppSDK;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.utils.PackageUtils;

/**
 * An utility class to ease working with StartApp on MoPub.
 */
public class StartAppUtils {
	
	/** The meta-data entry key that should contain the developer ID. */
	private static final String META_DATA_DEV_ID_KEY = "START_APP_DEV_ID";
	/** The meta-data entry key that should contain the App ID. */
	private static final String META_DATA_APP_ID_KEY = "START_APP_APP_ID";
	
	
	private static Boolean isInitialized = false;
	
	/**
	 * Initializes the StartApp SDK if not already initialized.
	 */
	public static void init(Activity activity) {
		if(isInitialized)
			return;
		
		String developerId = PackageUtils.getMetaDataAsString(activity, META_DATA_DEV_ID_KEY);
		String appId = PackageUtils.getMetaDataAsString(activity, META_DATA_APP_ID_KEY);
		
		if(developerId == null) {
			MoPubExtension.logE("The manifest is missing the StartApp needed property : \"" + META_DATA_DEV_ID_KEY + "\" ! Aborting StartApp SDK initializing.");
			return;
		}
		if(appId == null) {
			MoPubExtension.logE("The manifest is missing the StartApp needed property : \"" + META_DATA_APP_ID_KEY + "\" ! Aborting StartApp SDK initializing.");
			return;
		}
		
		MoPubExtension.log("Initializing StartApp SDK with developer ID " + developerId + " and app ID " + appId + " ...");
		StartAppSDK.init(activity, developerId, appId, false);
		isInitialized = true;
		MoPubExtension.log("StartApp SDK initialized successfully.");
	}
	
}
