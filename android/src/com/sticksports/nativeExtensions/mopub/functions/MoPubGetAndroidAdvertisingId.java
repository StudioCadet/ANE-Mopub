package com.sticksports.nativeExtensions.mopub.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubExtensionContext;

public class MoPubGetAndroidAdvertisingId implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		
		try {
			return FREObject.newObject(MoPubExtensionContext.advertisingId);
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}

}
