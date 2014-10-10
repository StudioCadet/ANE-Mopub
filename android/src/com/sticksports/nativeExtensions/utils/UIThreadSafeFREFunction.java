package com.sticksports.nativeExtensions.utils;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

/**
 * Ensures the FREFunction call is called on the UIThread and surrounded by a try-catch.
 * Subclasses must implement safeCall() instead of call().
 */
public abstract class UIThreadSafeFREFunction implements FREFunction {
	
	/** The result of the safeCall() call. */
	private FREObject result;
	
	/**
	 * Override in subclasses to avoid UIThread problems.
	 */
	public abstract FREObject safeCall(FREContext context, FREObject[] args);
	
	@Override
	public FREObject call(final FREContext context, final FREObject[] args) {
		
		result = null;
		
		context.getActivity().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				try {
					result = safeCall(context, args);
				}
				catch(Exception exception) {
					MoPubExtension.logW(exception.toString());
					exception.printStackTrace();
				}
			}
		});
		
		return result;
		
	}
	
}
