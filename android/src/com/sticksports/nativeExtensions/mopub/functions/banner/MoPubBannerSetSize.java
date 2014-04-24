package com.sticksports.nativeExtensions.mopub.functions.banner;

import android.util.Log;
import android.widget.FrameLayout;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubBannerContext;

public class MoPubBannerSetSize implements FREFunction
{

	@Override
	public FREObject call( FREContext ctx, FREObject[] args )
	{
		try
		{
			MoPubBannerContext context = (MoPubBannerContext) ctx;
			int size = args[0].getAsInt();
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
			
		    FrameLayout.LayoutParams params = ( FrameLayout.LayoutParams ) context.getBanner().getLayoutParams();
		    if( params != null )
		    {
		    	params.width = context.getBanner().getPlannedWidth();
		    	params.height = context.getBanner().getPlannedHeight();
			   	context.getBanner().setLayoutParams(params);
		    }
		}
		catch ( Exception exception )
		{
			Log.w( "MoPub", exception );
		}
		return null;
	}

}
