package com.sticksports.nativeExtensions.mopub.functions.banner;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubBannerContext;
import com.sticksports.nativeExtensions.mopub.utils.ResourceFinder;

public class MoPubBannerInitialise implements FREFunction
{
	@Override
	public FREObject call( FREContext ctx, FREObject[] args )
	{
		if( ResourceFinder.context == null )
		{
			ResourceFinder.context = ctx.getActivity();
		}

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
		}
		catch ( Exception exception )
		{
			Log.w( "MoPub", exception );
		}
		return null;
	}

}
