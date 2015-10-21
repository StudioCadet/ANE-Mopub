package com.mopub.mobileads;

import java.util.Date;
import java.util.Map;

import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.view.View;

import com.mopub.common.LocationService;
import com.mopub.common.MoPub;
import com.smartadserver.android.library.SASInterstitialView;
import com.smartadserver.android.library.model.SASAdElement;
import com.smartadserver.android.library.ui.SASAdView;
import com.smartadserver.android.library.ui.SASAdView.OnStateChangeListener;
import com.smartadserver.android.library.ui.SASAdView.StateChangeEvent;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

/**
 * Mopub adapter for Smart Ad Server.
 * Tested with Smart Ad Server 6.1
 */
public class SmartAdInterstitial extends CustomEventInterstitial implements SASAdView.AdResponseHandler, SASAdView.OnStateChangeListener, View.OnClickListener {

	// PROPERTIES :
	/** The listener used by MoPub to monitor interstitial ad's lifecycle. */
	private CustomEventInterstitialListener listener;
	/** The interstitial ad view. */
	private SASInterstitialView interstitial;

	/** The Site ID got from MoPub server. */
	private Integer siteId;
	/** The Page ID got from MoPub server. */
	private String pageId;
	/** The Format ID got from MoPub server. */
	private Integer formatId;
	/** The Target got from MoPub server. */
	private String target;
	/** The delay in seconds before retrying to show a Mobvious interstitial ad since the last impression failure. */
	private Integer retryDelay;
	
	/** The timestamp the last impression failed. */
	private static long lastImpressionFailedAt = 0;
	

	//////////////////////////
	// CUSTOM EVENT METHODS //
	//////////////////////////

	@Override
	protected void loadInterstitial(Context context, CustomEventInterstitialListener listener, Map<String, Object> localExtras, Map<String, String> serverExtras) {

		this.listener = listener;

		MoPubExtension.log("Creating a SAS interstitial ...");
		this.interstitial = new SASInterstitialView(context);

		MoPubExtension.log("Getting interstitial parameters ...");
		siteId = SmartAdUtils.getSiteIdFromServerExtras(serverExtras);
		pageId = SmartAdUtils.getPageIdFromServerExtras(serverExtras);
		formatId = SmartAdUtils.getFormatIdFromServerExtras(serverExtras);
		target = SmartAdUtils.getTargetFromServerExtras(serverExtras);
		retryDelay = SmartAdUtils.getRetryDelayFromServerExtras(serverExtras);

		if(siteId == null || pageId == null || formatId == null || target == null || retryDelay == null) {
			MoPubExtension.logE("Invalid SmartAdServer parameters ! Configure network on MoPub to provide custom data : "
					+ "{\"siteId\":YOUR_SITE_ID, \"pageId\":YOUR_PAGE_ID, \"formatId\":YOUR_FORMAT_ID, \"target\":YOUR_TARGET, \"retryDelay\":DELAY_IN_SECONDS}");
			listener.onInterstitialFailed(MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR);
			return;
		}
		
		if(lastImpressionFailedAt > 0 && (new Date().getTime() - lastImpressionFailedAt) < (retryDelay * 1000)) {
			MoPubExtension.log("Last SAS attempt failed too soon ago. Telling MoPub the fetch failed.");
			listener.onInterstitialFailed(MoPubErrorCode.NETWORK_NO_FILL);
		}
		else {
			MoPubExtension.log("Faking fetch of an SAS interstitial ad with parameters : "
					+ "[siteId:" + siteId + ", pageId:" + pageId + ", formatId:" + formatId + ", target:" + target + ", retryDelay:" + retryDelay + "]");
			lastImpressionFailedAt = 0;
			listener.onInterstitialLoaded();
		}
		
		this.interstitial.setLocation(LocationService.getLastKnownLocation(context, MoPub.getLocationPrecision(), MoPub.getLocationAwareness()));
	}

	@Override
	protected void showInterstitial() {
		MoPubExtension.log("Showing a master interstitial with parameters : [siteId:" + siteId + ", pageId:" + pageId + ", formatId:" + formatId + ", target:" + target + "] ...");
		interstitial.addStateChangeListener(this);
		interstitial.loadAd(siteId, pageId, formatId, true, target, this);
	}

	@Override
	protected void onInvalidate() {
		MoPubExtension.log("Invalidating SAS interstitial ...");
		listener = null;
		if(interstitial != null) {
			MoPubExtension.log("Destroying SAS interstitial ...");
			interstitial.removeStateChangeListener(this);
			interstitial.onDestroy();
		}
		interstitial = null;
		MoPubExtension.log("SAS interstitial invalidated.");
	}


	/////////////////////////////
	// SAS AD RESPONSE METHODS //
	/////////////////////////////

	@Override
	public void adLoadingCompleted(SASAdElement adElement) {
		MoPubExtension.log("SAS interstitial loaded and displayed.");
		if(interstitial != null) {
			interstitial.setOnClickListener(this);
			interstitial.executeOnUIThread(new Runnable() {
				@Override public void run() {
					if(listener != null)
						listener.onInterstitialShown();
				}
			});
		}
	}

	@Override
	public void adLoadingFailed(Exception e) {
		MoPubExtension.logW("SAS interstitial failed to load : " + e.toString());
		MoPubExtension.log("SAS interstitial ads will be disabled for " + retryDelay + " seconds.");
		lastImpressionFailedAt = new Date().getTime();
		
		if(interstitial != null) {
			interstitial.executeOnUIThread(new Runnable() {
				@Override public void run() {
					if(listener != null) 
						listener.onInterstitialDismissed();
				}
			});
		}
	}


	/////////////////////////////////
	// SAS AD STATE CHANGE METHODS //
	/////////////////////////////////

	@Override
	public void onStateChanged(StateChangeEvent event) {
		if(event.getType() == StateChangeEvent.VIEW_HIDDEN) {
			MoPubExtension.log("SAS interstitial dismissed.");
			if(interstitial != null) {
				interstitial.executeOnUIThread(new Runnable() {
					@Override public void run() {
						if(listener != null)
							listener.onInterstitialDismissed();
					}
				});
			}
		}
	}


	////////////////////
	// CLICK LISTENER //
	////////////////////

	@Override
	public void onClick(View v) {
		MoPubExtension.log("SAS interstitial clicked.");
		if(listener != null)
			listener.onInterstitialClicked();
	}
}
