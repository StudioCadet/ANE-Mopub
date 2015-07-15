package com.sticksports.nativeExtensions.mopub.functions;

import android.app.Activity;
import android.os.AsyncTask;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.mopub.mobileads.AdColonyUtils;
import com.mopub.mobileads.ChartboostUtils;
import com.mopub.mobileads.InMobiUtils;
import com.mopub.mobileads.StartAppUtils;
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
		
		// AdColony :
		AdColonyUtils.init(activity, appVersion);
		
		// StartApp :
		StartAppUtils.init(activity);
		
		// Google AdvertisingID :
		if(GooglePlayServicesUtil.isGooglePlayServicesAvailable(context.getActivity()) != ConnectionResult.SUCCESS) {
			MoPubExtension.log("The Google Play Services cannot be used to retrieve the Google Advertising ID.");
		}
		else {
			try {
				Class.forName("com.google.android.gms.ads.identifier.AdvertisingIdClient");
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
			}
			catch (Exception e) {
				MoPubExtension.logW("Exception trying to retrieve Advertising ID : " + e.toString());
				e.printStackTrace();
			}
		}
		
		MoPubExtension.log("MoPub extension initialized successfully.");
		
		return null;
	}

}
