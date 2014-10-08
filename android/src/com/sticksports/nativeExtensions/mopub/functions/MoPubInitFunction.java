package com.sticksports.nativeExtensions.mopub.functions;

import android.app.Activity;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.mopub.mobileads.AdColonyUtils;
import com.mopub.mobileads.ChartboostUtils;
import com.mopub.mobileads.InMobiUtils;
import com.smartadserver.android.library.ui.SASAdView;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

/**
 * A method used to initialize MoPub and 3rd party SDKs.
 */
public class MoPubInitFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		
		MoPubExtension.log("Initializing MoPub extension ...");
		
		// Gather usefull infos :
		Activity activity = context.getActivity();
		String appVersion = null;
		try {
			appVersion = args[0].getAsString();
		} catch (Exception e) {
			MoPubExtension.logE("AppVersion argument missing from init() call !");
		}
		
		// InMobi :
		InMobiUtils.init(activity, activity);
		
		// Chartboost :
		ChartboostUtils.init(activity);
		
		// SmartAdServer :
		SASAdView.enableLogging();
		
		// AdColony :
		AdColonyUtils.init(activity, appVersion);
		
		MoPubExtension.log("MoPub extension initialized successfully.");
		
		return null;
	}

}
