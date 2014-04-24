package com.sticksports.nativeExtensions.mopub;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.mopub.mobileads.MoPubConversionTracker;
import com.sticksports.nativeExtensions.mopub.functions.MoPubGetAdScaleFactor;

public class MoPubExtensionContext extends FREContext
{
	
	// CONSTRUCTOR :
	public MoPubExtensionContext() {
		super();
		
		// Conversion tracking call
	    new MoPubConversionTracker().reportAppOpen(getActivity());
	}
	
	
	@Override
	public void dispose() {
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		
		functionMap.put("getAdScaleFactor", new MoPubGetAdScaleFactor());
		
		return functionMap;
	}
}
