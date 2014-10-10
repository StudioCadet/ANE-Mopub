package com.sticksports.nativeExtensions.mopub.functions;

import android.provider.Settings;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class MoPubGetAndroidId implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		
		try {
			return FREObject.newObject(Settings.Secure.getString(context.getActivity().getContentResolver(), Settings.Secure.ANDROID_ID));
		}
		catch(Exception e) {
			MoPubExtension.logW("Exception trying to retrieve Android ID : " + e.toString());
			e.printStackTrace();
		}
		
		return null;
	}

}
