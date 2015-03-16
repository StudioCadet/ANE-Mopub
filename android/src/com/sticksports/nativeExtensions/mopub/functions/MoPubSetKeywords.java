package com.sticksports.nativeExtensions.mopub.functions;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.google.android.gms.ads.AdRequest;
import com.inmobi.commons.GenderType;
import com.inmobi.commons.InMobi;
import com.mopub.mobileads.AdMobUtils;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.mopub.MoPubExtensionContext;
import com.sticksports.nativeExtensions.mopub.MoPubKeywords;
import com.sticksports.nativeExtensions.utils.FREUtils;

public class MoPubSetKeywords implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		
		// Get parameters :
		Integer age = FREUtils.getInteger(args, 0);
		Double dateOfBirthTimestamp = FREUtils.getDouble(args, 1);
		String gender = FREUtils.getString(args, 2);
		String language = FREUtils.getString(args, 3);
		String[] additionalKeywordsKeys = FREUtils.getStringArray(args, 4);
		String[] additionalKeywordsValues = FREUtils.getStringArray(args, 5);
		String inMobiInterests = FREUtils.getString(args, 6);
		
		// Prepare parameters :
		Date dateOfBirth = null;
		if(dateOfBirthTimestamp != null) 
			dateOfBirth = new Date(dateOfBirthTimestamp.longValue());
		
		HashMap<String, String> additionalKeywords = null;
		String additionalKeywordsString = "["; // -> for logging purpose only
		if(additionalKeywordsKeys != null && additionalKeywordsValues != null && additionalKeywordsKeys.length == additionalKeywordsValues.length) {
			additionalKeywords = new HashMap<String, String>();
			for(int i = 0 ; i < additionalKeywordsKeys.length ; i++) {
				additionalKeywords.put(additionalKeywordsKeys[i], additionalKeywordsValues[i]);
				additionalKeywordsString += additionalKeywordsKeys[i] + ":" + additionalKeywordsValues[i] + ";";
			}
			if(additionalKeywordsKeys.length > 0)
				additionalKeywordsString = additionalKeywordsString.substring(0, additionalKeywordsString.length() - 1);
			additionalKeywordsString += "]";
		}
		
		// Set Mopub keywords :
		MoPubExtension.log("Setting keywords : {age:" + age + "; dateOfBirth:" + dateOfBirth + "; gender:" + gender +"; language:" + language + "; "
				+ "additionnalKeywords:" + additionalKeywordsString + "}; inMobiInterests:[" + inMobiInterests + "]");
		if(MoPubExtensionContext.keywords == null)
			MoPubExtensionContext.keywords = new MoPubKeywords();
		
		MoPubExtensionContext.keywords.age = age;
		MoPubExtensionContext.keywords.dateOfBirth = dateOfBirth;
		MoPubExtensionContext.keywords.gender = gender;
		MoPubExtensionContext.keywords.language = language;
		MoPubExtensionContext.keywords.additionalKeywords = additionalKeywords;
		
		// Setting AdMob keywords :
		MoPubExtension.log("Passing targeting data to AdMob ...");
		int adMobGender = gender != null && gender.equals("m") ? AdRequest.GENDER_MALE : gender != null && gender.equals("f") ? AdRequest.GENDER_FEMALE : AdRequest.GENDER_UNKNOWN;
		AdMobUtils.setTargetingData(additionalKeywordsValues, dateOfBirth, adMobGender);
		MoPubExtension.log("AdMob targeting data set successfully.");
		
		// Setting InMobi keywords (in try/catch to avoid crashes for simple stuff like that) :
		MoPubExtension.log("Passing keywords to InMobi ...");
		if(age != null)
			try { InMobi.setAge(age); } 
			catch(Exception e) { MoPubExtension.log("	-> Failed to set InMobi age to " + age); }
		
		if(dateOfBirth != null) {
			try { 
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(dateOfBirth);
				InMobi.setDateOfBirth(calendar);
			}
			catch(Exception e) { MoPubExtension.log("	-> Failed to set InMobi dateOfBirth to " + dateOfBirth); }
		}
		
		try {
			InMobi.setGender(gender != null && gender.equals("m") ? GenderType.MALE : gender != null && gender.equals("f") ? GenderType.FEMALE : GenderType.UNKNOWN); 
		} 
		catch(Exception e) {  MoPubExtension.log("	-> Failed to set InMobi gender to " + gender);  }
		
		if(language != null)
			try { InMobi.setLanguage(language); }
			catch(Exception e) { MoPubExtension.log("	-> Failed to set InMobi language to " + language);  }
		
		if(inMobiInterests != null) {
			try { InMobi.setInterests(inMobiInterests); }
			catch(Exception e) { MoPubExtension.log("	-> Failed to set InMobi interests to " + inMobiInterests);  }
		}
		
		MoPubExtension.log("InMobi's keywords set successfully.");
		
		return null;
	}
}