package com.mopub.mobileads;

import java.util.Map;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.WindowManager;

import com.inmobi.commons.InMobi;
import com.inmobi.monetization.IMBanner;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

/**
 * Common tools to ease working with InMobi.
 */
public class InMobiUtils {
	
	/** The name of the custom network data used on MoPub to pass a SlotID to a particular AdUnit. */
	private static final String SERVER_CUSTOM_DATA_PROPERTY_ID_KEY = "property";
	
	
	/** The property catched from the Android manifest. */
	public static String inMobiPropertyId;
	private static Boolean isAppInitialized = false;
	
	/**
	 * Initializes InMobi from the given context. If InMobi is already initialized, does nothing.
	 */
	public static void init(Context context, Activity activity) {
		if (!isAppInitialized) {
			
			try {
				inMobiPropertyId = (String) context.getPackageManager().getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA)
						.metaData.get("IN_MOBI_PROPERTY_ID");
				MoPubExtension.log("Initializing InMobi with property ID : " + inMobiPropertyId);
				InMobi.initialize(activity, inMobiPropertyId);
				InMobi.setLogLevel(InMobi.LOG_LEVEL.DEBUG);
	            isAppInitialized = true;
	            MoPubExtension.log("InMobi initialized.");
			}
			catch (NameNotFoundException e) {
				MoPubExtension.logE("The manifest is missing the InMobi needed property : \"IN_MOBI_PROPERTY_ID\" !");
			}
		}
	}
	
	/**
	 * Returns the optimal slot size based on the device display caracteristics.
	 */
	public static Integer getOptimalSlotSize(Activity context) {
		Display display = ((WindowManager) context.getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay();

		DisplayMetrics displayMetrics = new DisplayMetrics();
		display.getMetrics(displayMetrics);
		double density = displayMetrics.density;
		double width = displayMetrics.widthPixels;
		double height = displayMetrics.heightPixels;
		int[][] maparray = {
				{ IMBanner.INMOBI_AD_UNIT_728X90, 728, 90 }, 
//				{ IMBanner.INMOBI_AD_UNIT_468X60, 468, 60 }, 
				{ IMBanner.INMOBI_AD_UNIT_320X50, 320, 50 } 
			};
		
		for (int i = 0; i < maparray.length; i++) {
			if (maparray[i][1] * density <= width && maparray[i][2] * density <= height) {
				return maparray[i][0];
			}
		}
		return IMBanner.INMOBI_AD_UNIT_320X50;
	}
	
	/**
	 * Returns an eventual Property ID defined on MoPub.
	 */
	public static String getPropertyIdFromServerExtras(Map<String, String> serverExtras) {
		return ExtraUtils.getString(serverExtras, SERVER_CUSTOM_DATA_PROPERTY_ID_KEY);
	}
	
}
