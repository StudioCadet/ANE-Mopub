package com.sticksports.nativeExtensions.mopub.functions.banner;

import android.widget.FrameLayout;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubBannerContext;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class MoPubBannerSetHeight implements FREFunction {

	@Override
	public FREObject call(FREContext ctx, FREObject[] args) {
		try
		{
			MoPubBannerContext context = (MoPubBannerContext) ctx;
			int height = args[0].getAsInt();
			context.getBanner().setPlannedHeight( height );
			
			FrameLayout.LayoutParams params = ( FrameLayout.LayoutParams ) context.getBanner().getLayoutParams();
		    if( params != null )
		    {
		    	params.height = height;
			   	context.getBanner().setLayoutParams(params);
		    }
		    
		    MoPubExtension.log("Banner height set to " + height);
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		return null;
	}

}
