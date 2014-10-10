package com.sticksports.nativeExtensions.mopub.functions;

import android.content.Context;
import android.telephony.TelephonyManager;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class MoPubGetAndroidIMEI implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		
		try {
			return FREObject.newObject(((TelephonyManager) context.getActivity().getSystemService(Context.TELEPHONY_SERVICE)).getDeviceId());
		}
		catch(Exception e) {
			MoPubExtension.logW("Exception trying to retrieve IMEI : " + e.toString());
			e.printStackTrace();
		}
		
		return null;
	}

}
