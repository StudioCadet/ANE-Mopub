package com.sticksports.nativeExtensions.mopub;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.sticksports.nativeExtensions.mopub.functions.MoPubGetAdScaleFactor;
import com.sticksports.nativeExtensions.mopub.functions.MoPubInitFunction;
import com.sticksports.nativeExtensions.mopub.functions.MoPubTrackConversion;

public class MoPubExtensionContext extends FREContext
{
	
	// CONSTRUCTOR :
	public MoPubExtensionContext() {
		super();
	}
	
	@Override
	public void dispose() {
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		
		functionMap.put("mopub_init", new MoPubInitFunction());
		functionMap.put("mopub_getAdScaleFactor", new MoPubGetAdScaleFactor());
		functionMap.put("mopub_trackConversion", new MoPubTrackConversion());
		
		return functionMap;
	}
}
