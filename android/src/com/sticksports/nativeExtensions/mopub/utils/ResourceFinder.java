package com.sticksports.nativeExtensions.mopub.utils;

import android.content.Context;

public class ResourceFinder
{
	public static Context context;
	
	public static int getResourceId( String type, String name )
	{
		if( context != null )
		{
			return context.getResources().getIdentifier( name, type, context.getPackageName() );
		}
		return 0;
	}
}
