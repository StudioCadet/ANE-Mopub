package com.mopub.mobileads;

import java.util.Map;

import android.content.Context;
import android.view.View;

import com.smartadserver.android.library.SASInterstitialView;
import com.smartadserver.android.library.model.SASAdElement;
import com.smartadserver.android.library.ui.SASAdView;
import com.smartadserver.android.library.ui.SASAdView.StateChangeEvent;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class SASInterstitial extends CustomEventInterstitial implements SASAdView.AdResponseHandler, SASAdView.OnStateChangeListener, View.OnClickListener {

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


	//////////////////////////
	// CUSTOM EVENT METHODS //
	//////////////////////////

	@Override
	protected void loadInterstitial(Context context, CustomEventInterstitialListener listener, Map<String, Object> localExtras, Map<String, String> serverExtras) {

		this.listener = listener;

		MoPubExtension.log("Creating a SAS interstitial ...");
		this.interstitial = new SASInterstitialView(context);

		MoPubExtension.log("Getting interstitial parameters ...");
		siteId = SASUtils.getSiteIdFromServerExtras(serverExtras);
		pageId = SASUtils.getPageIdFromServerExtras(serverExtras);
		formatId = SASUtils.getFormatIdFromServerExtras(serverExtras);
		target = SASUtils.getTargetFromServerExtras(serverExtras);

		/////////////////////
		siteId = 64714;
		pageId = "497342";
		formatId = 9769;
		target = "";
		////////////////////		

		if(siteId == null || pageId == null || formatId == null || target == null) {
			MoPubExtension.logE("Invalid SmartAdServer parameters ! Configure network on MoPub to provide custom data : "
					+ "{\"siteId\":YOUR_SITE_ID, \"pageId\":YOUR_PAGE_ID, \"formatId\":YOUR_FORMAT_ID, \"target\":YOUR_TARGET}");
			listener.onInterstitialFailed(MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR);
			return;
		}

		MoPubExtension.log("Prepared to display a SAS interstitial with parameters : [siteId:" + siteId + ", pageId:" + pageId + ", formatId:" + formatId + ", target:" + target + "]");
		MoPubExtension.log("Faking a successful fetch.");
		listener.onInterstitialLoaded();
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
		if(interstitial != null) {
			interstitial.executeOnUIThread(new Runnable() {
				@Override public void run() {
					if(listener != null)
						listener.onInterstitialDismissed();
					//
					//listener.onInterstitialFailed(MoPubErrorCode.NETWORK_NO_FILL);
					// -> this cannot work because this is a "fetch failed" error type for MoPub, let MoPub think the 
					//	  ad is simply dismissed without being shown
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
