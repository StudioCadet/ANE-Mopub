package com.sticksports.nativeExtensions.mopub.functions;

import android.app.Activity;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
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
		
		// Get the main activity, once :
		Activity activity = context.getActivity();
		
		
		// Trying to fix the CalledFromWrongThread exception
		// see: http://stackoverflow.com/questions/10426120/android-got-calledfromwrongthreadexception-in-onpostexecute-how-could-it-be
		try {
			Class.forName("android.os.AsyncTask");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		
		// InMobi :
		InMobiUtils.init(activity, activity);
		
		// Chartboost :
		ChartboostUtils.init(activity);
		
		// SmartAdServer :
		SASAdView.enableLogging();
		
		MoPubExtension.log("MoPub extension initialized successfully.");
		
		return null;
	}

}
