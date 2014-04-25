package com.sticksports.nativeExtensions.mopub.functions;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.mopub.mobileads.MoPubConversionTracker;

public class MoPubTrackConversion implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		
		try {
			new MoPubConversionTracker().reportAppOpen(context.getActivity());
		}
		catch (Exception e) {
			Log.w("MoPub", e);
			e.printStackTrace();
		}
		return null;
	}

}
