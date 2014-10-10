package com.mopub.mobileads;

import java.util.Map;

import android.content.Context;
import android.view.View;

import com.smartadserver.android.library.SASBannerView;
import com.smartadserver.android.library.model.SASAdElement;
import com.smartadserver.android.library.ui.SASAdView;
import com.smartadserver.android.library.ui.SASAdView.StateChangeEvent;
import com.sticksports.nativeExtensions.mopub.MoPubExtension;

public class SASBanner extends CustomEventBanner implements View.OnClickListener, SASAdView.AdResponseHandler, SASAdView.OnStateChangeListener {

	// PROPERTIES :
	/** The listener used by MoPub to monitor banner's lifecycle. */
	private CustomEventBannerListener listener;
	/** The banner view. */
	private SASBannerView banner;
	
	
	//////////////////////////
	// CUSTOM EVENT METHODS //
	//////////////////////////
	
	@Override
	protected void loadBanner(Context context, CustomEventBannerListener listener, Map<String, Object> localExtras, Map<String, String> serverExtras) {
		
		this.listener = listener;
		
		MoPubExtension.log("Creating a SAS banner ...");
		this.banner = new SASBannerView(context);
		
		MoPubExtension.log("Getting banner parameters ...");
		Integer siteId = SASUtils.getSiteIdFromServerExtras(serverExtras);
		String pageId = SASUtils.getPageIdFromServerExtras(serverExtras);
		Integer formatId = SASUtils.getFormatIdFromServerExtras(serverExtras);
		String target = SASUtils.getTargetFromServerExtras(serverExtras);
		
		if(siteId == null || pageId == null || formatId == null || target == null) {
			MoPubExtension.logE("Invalid SmartAdServer parameters ! Configure network on MoPub to provide custom data : "
					+ "{\"siteId\":YOUR_SITE_ID, \"pageId\":YOUR_PAGE_ID, \"formatId\":YOUR_FORMAT_ID, \"target\":YOUR_TARGET}");
			listener.onBannerFailed(MoPubErrorCode.ADAPTER_CONFIGURATION_ERROR);
			return;
		}
		
		MoPubExtension.log("Loading a master banner with parameters : [siteId:" + siteId + ", pageId:" + pageId + ", formatId:" + formatId + ", target:" + target + "] ...");
		banner.addStateChangeListener(this);
		banner.setOnClickListener(this);
		banner.setVisibility(View.GONE);
		banner.loadAd(siteId, pageId, formatId, true, target, this);
	}

	@Override
	protected void onInvalidate() {
		MoPubExtension.log("Invalidating SAS banner ...");
		listener = null;
		if(banner != null) {
			MoPubExtension.log("Destroying SAS banner ...");
			banner.removeStateChangeListener(this);
			banner.onDestroy();
		}
		banner = null;
		MoPubExtension.log("SAS banner invalidated.");
	}
	
	
	/////////////////////////////
	// SAS AD RESPONSE METHODS //
	/////////////////////////////

	@Override
	public void adLoadingCompleted(SASAdElement adElement) {
		MoPubExtension.log("SAS banner loaded.");
		banner.setOnClickListener(this);
		banner.executeOnUIThread(new Runnable() {
			@Override public void run() {
				banner.setVisibility(View.VISIBLE);
				listener.onBannerLoaded(banner);
			}
		});
	}

	@Override
	public void adLoadingFailed(Exception e) {
		MoPubExtension.logW("SAS banner failed to load : " + e);
		if(banner != null) {
			banner.executeOnUIThread(new Runnable() {
				@Override public void run() {
					banner.setVisibility(View.GONE);
					if(listener != null)
						listener.onBannerFailed(MoPubErrorCode.NETWORK_NO_FILL);
				}
			});
		}
		else if(listener != null)
			listener.onBannerFailed(MoPubErrorCode.NETWORK_NO_FILL);
	}
	
	
	/////////////////////////////////
	// SAS AD STATE CHANGE METHODS //
	/////////////////////////////////

	@Override
	public void onStateChanged(StateChangeEvent event) {
		if(event.getType() == StateChangeEvent.VIEW_EXPANDED) {
			MoPubExtension.log("SAS banner expanded.");
			banner.executeOnUIThread(new Runnable() {
				@Override public void run() {
					listener.onBannerExpanded();
				}
			});
		}
		
		else if(event.getType() == StateChangeEvent.VIEW_DEFAULT) {
			MoPubExtension.log("SAS banner collapsed.");
			banner.executeOnUIThread(new Runnable() {
				@Override public void run() {
					listener.onBannerCollapsed();
				}
			});
		}
	}

	
	////////////////////
	// CLICK LISTENER //
	////////////////////
	
	@Override
	public void onClick(View v) {
		MoPubExtension.log("SAS banner clicked.");
		listener.onBannerClicked();
	}
}
