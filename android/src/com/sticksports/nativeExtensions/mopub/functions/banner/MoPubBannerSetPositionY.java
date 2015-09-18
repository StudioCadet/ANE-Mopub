package com.sticksports.nativeExtensions.mopub.functions.banner;

import android.widget.FrameLayout;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubBannerContext;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class MoPubBannerSetPositionY implements FREFunction {

	@Override
	public FREObject call(FREContext ctx, FREObject[] args) {
		try
		{
			MoPubBannerContext context = (MoPubBannerContext) ctx;
			int y = args[0].getAsInt();
			context.getBanner().setPosY( y );
			
		    FrameLayout.LayoutParams params = ( FrameLayout.LayoutParams ) context.getBanner().getLayoutParams();
		    if( params != null )
		    {
		    	params.topMargin = y;
		    	context.getBanner().setLayoutParams(params);
		    }
		    MoPubExtension.log("Banner Y position set to " + y);
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		return null;
	}

}
