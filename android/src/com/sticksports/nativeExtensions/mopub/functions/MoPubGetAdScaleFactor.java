package com.sticksports.nativeExtensions.mopub.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;
import com.sticksports.nativeExtensions.utils.UIThreadSafeFREFunction;

public class MoPubGetAdScaleFactor extends UIThreadSafeFREFunction {
	
	public FREObject safeCall( FREContext ctx, FREObject[] args )
	{
		try
		{
			double density = ctx.getActivity().getResources().getDisplayMetrics().density;
			MoPubExtension.log("AdScaleFactor : " + density);
			return FREObject.newObject( density );
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		return null;
	}
}
