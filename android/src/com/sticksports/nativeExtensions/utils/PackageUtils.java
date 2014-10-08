package com.sticksports.nativeExtensions.utils;

import com.sticksports.nativeExtensions.mopub.MoPubExtension;

import android.content.Context;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;

public class PackageUtils {
	
	/**
	 * Returns the manifest meta-data content for the given key, or null if the key doesn't exist.
	 */
	public static Object getMetaData(Context context, String key) {
		
		try {
			return context.getPackageManager().getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA).metaData.get(key);
		} catch (NameNotFoundException e) {
			MoPubExtension.logE("The manifest is missing the required meta-data tag : <meta-data android:name=\"" + key + "\" android:value=\"YOUR_VALUE\" /> !");
		}
		
		return null;
	}

}
