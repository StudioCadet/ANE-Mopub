package com.mopub.mobileads;

import java.util.Date;

import android.content.Context;

import com.google.android.gms.ads.AdRequest;
import com.mopub.common.LocationService;
import com.mopub.common.MoPub;

/**
 * Eases working with AdMob.
 */
public class AdMobUtils {
	
	// PROPERTIES :
	private static String[] keywords = null;
	private static Date birthday = null;
	private static int gender = AdRequest.GENDER_UNKNOWN;
	
	
	/**
	 * Sets the current keywords and targeting data.
	 * 
	 * @param keywords	The list of keywords
	 * @param birthday	The birthday of the user
	 * @param gender	The gender of the user. One of the AdRequest.Gender
	 */
	public static void setTargetingData(String[] keywords, Date birthday, int gender) {
		AdMobUtils.keywords = keywords;
		AdMobUtils.birthday = birthday;
		AdMobUtils.gender = gender;
	}
	
	/**
	 * Returns an AdRequest instance with the registered targeting data.
	 */
	public static AdRequest getAdRequest(Context context) {
		AdRequest.Builder builder = new AdRequest.Builder();
		
		// Add keywords :
		if(keywords != null && keywords.length > 0) {
			for(int i = 0 ; i < keywords.length ; i++)
				builder.addKeyword(keywords[i]);
		}
		
		// Add birthday :
		if(birthday != null)
			builder.setBirthday(birthday);
		
		// Add gender :
		builder.setGender(gender);
		
		// Add location :
		builder.setLocation(LocationService.getLastKnownLocation(context, MoPub.getLocationPrecision(), MoPub.getLocationAwareness()));
		
		return builder.build();
	}

}
