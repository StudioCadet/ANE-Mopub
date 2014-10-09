package com.sticksports.nativeExtensions.mopub.functions;

import java.io.IOException;

import android.app.Activity;
import android.os.AsyncTask;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;
import com.mopub.mobileads.AdColonyUtils;
import com.mopub.mobileads.ChartboostUtils;
import com.mopub.mobileads.InMobiUtils;
import com.smartadserver.android.library.ui.SASAdView;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.mopub.MoPubExtensionContext;

/**
 * A method used to initialize MoPub and 3rd party SDKs.
 */
public class MoPubInitFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		
		MoPubExtension.log("Initializing MoPub extension ...");
		
		// Gather usefull infos :
		final Activity activity = context.getActivity();
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
		
		// Google AdvertisingID :
		MoPubExtension.log("Retrieving Google Advertising ID in a background thread ...");
		(new AsyncTask<Void, Void, Void>() {
			@Override
			protected Void doInBackground(Void... params) {
				try {
					MoPubExtensionContext.advertisingId = AdvertisingIdClient.getAdvertisingIdInfo(activity).getId();
					MoPubExtension.log("Android Advertising ID available : " + MoPubExtensionContext.advertisingId);
				} catch (Exception e) {
					MoPubExtension.logW("Exception trying to retrieve Advertising ID : " + e.toString());
					e.printStackTrace();
				}
				return null;
			}
		}).execute();
		
		MoPubExtension.log("MoPub extension initialized successfully.");
		
		return null;
	}

}
