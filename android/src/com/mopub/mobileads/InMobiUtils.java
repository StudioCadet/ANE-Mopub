package com.mopub.mobileads;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import android.app.Activity;
import android.content.Context;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.WindowManager;

import com.inmobi.commons.InMobi;
import com.inmobi.monetization.IMBanner;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.utils.ExtraUtils;
import com.sticksports.nativeExtensions.utils.PackageUtils;

/**
 * Common tools to ease working with InMobi.
 */
public class InMobiUtils {
	
	/** The meta-data entry key that should contain the default property ID. */
	private static final String META_DATA_PROPERTY_ID_KEY = "IN_MOBI_PROPERTY_ID";
	
	/** The meta-data entry key that should contain the list of Mopub ad units that should display ads without Mopub, but through InMobi directly. */
	private static final String META_DATA_BYPASS_MOPUB_AD_UNITS_KEY = "IN_MOBI_BYPASS_MOPUB_AD_UNITS";
	
	/** The name of the custom network data used on MoPub to pass a SlotID to a particular AdUnit. */
	private static final String CUSTOM_DATA_PROPERTY_ID_KEY = "property";
	
	
	/** The property catched from the Android manifest. */
	public static String inMobiPropertyId;
	private static Boolean isAppInitialized = false;
	
	/**
	 * Initializes InMobi from the given context. If InMobi is already initialized, does nothing.
	 */
	public static void init(Context context, Activity activity) {
		if (!isAppInitialized) {
			
			inMobiPropertyId = (String) PackageUtils.getMetaData(context, META_DATA_PROPERTY_ID_KEY);
			if(inMobiPropertyId == null) {
				MoPubExtension.logE("The manifest is missing the InMobi needed property : \"" + META_DATA_PROPERTY_ID_KEY + "\" ! Aborting InMobi SDK initializing.");
				return;
			}
			
			MoPubExtension.log("Initializing InMobi with property ID : " + inMobiPropertyId);
			InMobi.initialize(activity, inMobiPropertyId);
			InMobi.setLogLevel(InMobi.LOG_LEVEL.DEBUG);
            isAppInitialized = true;
            MoPubExtension.log("InMobi initialized.");
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
		return ExtraUtils.getString(serverExtras, CUSTOM_DATA_PROPERTY_ID_KEY);
	}
	
	/**
	 * Returns true if the given ad unit is configured to bypass mopub and use InMobi directly.
	 */
	public static boolean isInMobiAdUnit(Context context, String adUnit) {
		String adUnits = PackageUtils.getMetaDataAsString(context, META_DATA_BYPASS_MOPUB_AD_UNITS_KEY);
		if(adUnits == null || adUnits.length() == 0)
			return false;
		
		List<String> adUnitsList = Arrays.asList(adUnits.split(","));
		return adUnitsList.indexOf(adUnit) != -1;
	}
}
