package com.sticksports.nativeExtensions.mopub.functions.banner;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubBannerContext;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.mopub.MoPubExtensionContext;

public class MoPubBannerLoad implements FREFunction {

	@Override
	public FREObject call(FREContext ctx, FREObject[] args) {
		try
		{
			MoPubBannerContext context = (MoPubBannerContext) ctx;
			MoPubExtension.log("Loading banner");
			if(MoPubExtensionContext.keywords != null)
				context.getBanner().setKeywords(MoPubExtensionContext.keywords.getForMopub());
			context.getBanner().loadAd();
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		return null;
	}

}
