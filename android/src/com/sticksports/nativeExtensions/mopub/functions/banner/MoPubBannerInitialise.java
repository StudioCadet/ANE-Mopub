package com.sticksports.nativeExtensions.mopub.functions.banner;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubBannerContext;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class MoPubBannerInitialise implements FREFunction {

	@Override
	public FREObject call(FREContext ctx, FREObject[] args) {

		try
		{
			MoPubBannerContext context = (MoPubBannerContext) ctx;
			String adUnitId = args[0].getAsString();
			context.getBanner().setAdUnitId( adUnitId );
			int size = args[1].getAsInt();
			double density = ctx.getActivity().getResources().getDisplayMetrics().density;
			
			switch( size )
			{
				case 1:
					context.getBanner().setPlannedWidth( (int) Math.ceil( 320 * density ) );
					context.getBanner().setPlannedHeight( (int) Math.ceil( 50 * density ) );
					break;
				case 2:
					context.getBanner().setPlannedWidth( (int) Math.ceil( 300 * density ) );
					context.getBanner().setPlannedHeight( (int) Math.ceil( 250 * density ) );
					break;
				case 3:
					context.getBanner().setPlannedWidth( (int) Math.ceil( 728 * density ) );
					context.getBanner().setPlannedHeight( (int) Math.ceil( 90 * density ) );
					break;
				case 4:
					context.getBanner().setPlannedWidth( (int) Math.ceil( 160 * density ) );
					context.getBanner().setPlannedHeight( (int) Math.ceil( 600 * density ) );
					break;
			}
			MoPubExtension.log("Banner initialized (size set to " + context.getBanner().getPlannedWidth() + "x" + context.getBanner().getPlannedHeight() + ")");
		}
		catch ( Exception exception )
		{
			MoPubExtension.logW(exception.toString());
			exception.printStackTrace();
		}
		return null;
	}

}
