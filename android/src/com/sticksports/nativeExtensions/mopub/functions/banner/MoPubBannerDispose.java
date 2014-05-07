package com.sticksports.nativeExtensions.mopub.functions.banner;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubBannerContext;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class MoPubBannerDispose implements FREFunction {

	@Override
	public FREObject call(FREContext ctx, FREObject[] args) {
		
		try
		{
			MoPubBannerContext context = (MoPubBannerContext) ctx;
			context.disposeBanner();
			MoPubExtension.log("Banner disposed");
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		
		return null;
	}

}
