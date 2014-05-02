package com.sticksports.nativeExtensions.mopub.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.mopub.mobileads.MoPubConversionTracker;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class MoPubTrackConversion implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		
		try {
			new MoPubConversionTracker().reportAppOpen(context.getActivity());
			MoPubExtension.log("Conversion tracked successfully.");
		}
		catch (Exception e) {
			MoPubExtension.logW(e.toString());
			e.printStackTrace();
		}
		return null;
	}

}
