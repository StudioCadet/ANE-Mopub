package com.sticksports.nativeExtensions.mopub.functions.banner;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubBannerContext;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class MoPubBannerSetTestMode implements FREFunction {

	@Override
	public FREObject call(FREContext ctx, FREObject[] args) {
		try
		{
			MoPubBannerContext context = (MoPubBannerContext) ctx;
			boolean testing = args[0].getAsBool();
			context.getBanner().setTesting( testing );
			
			MoPubExtension.log("Banner testing mode set to " + testing);
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		return null;
	}

}
