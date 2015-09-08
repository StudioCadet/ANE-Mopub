package com.sticksports.nativeExtensions.mopub
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	public class MoPubBanner extends EventDispatcher
	{
// native method names

		private static const initialiseBanner : String = "mopub_initialiseBanner";
		
		private static const setAdUnitId : String = "mopub_setAdUnitId";
		private static const setAutorefresh : String = "mopub_setAutorefresh";
		private static const setTestMode : String = "mopub_setTestMode";
		private static const setLockNativeAdsToOrientation : String = "mopub_lockNativeAdsToOrientation";
		
		private static const getPositionX : String = "mopub_getPositionX";
		private static const setPositionX : String = "mopub_setPositionX";
		private static const getPositionY : String = "mopub_getPositionY";
		private static const setPositionY : String = "mopub_setPositionY";
		private static const getWidth : String = "mopub_getWidth";
		private static const setWidth : String = "mopub_setWidth";
		private static const getHeight : String = "mopub_getHeight";
		private static const setHeight : String = "mopub_setHeight";
		
		private static const setSize : String = "mopub_setSize";
		private static const getCreativeWidth : String = "mopub_getCreativeWidth";
		private static const getCreativeHeight : String = "mopub_getCreativeHeight";
		
		private static const loadBanner : String = "mopub_loadBanner";
		private static const showBanner : String = "mopub_showBanner";
		private static const removeBanner : String = "mopub_removeBanner";
		
		private static const disposeBanner : String = "mopub_disposeBanner";

// class variables

		private var extensionContext : ExtensionContext = null;

		private var _adUnitId : String;
		private var _testing : Boolean = false;
		private var _autoRefresh : Boolean = true;
		private var _nativeAdsOrientation : MoPubNativeAdOrientation = MoPubNativeAdOrientation.any;
		private var _size : MoPubSize;

// properties

		public function get adUnitId() : String
		{
			return _adUnitId;
		}

		public function set adUnitId( value : String ) : void
		{
			_adUnitId = value;
			extensionContext.call( setAdUnitId, value );
		}

		public function get autorefresh() : Boolean
		{
			return _autoRefresh;
		}

		public function set autorefresh( value : Boolean ) : void
		{
			_autoRefresh = value;
			extensionContext.call( setAutorefresh, value );
		}

		public function get testing() : Boolean
		{
			return _testing;
		}

		public function set testing( value : Boolean ) : void
		{
			_testing = value;
			extensionContext.call( setTestMode, value );
		}

		public function get nativeAdsOrientation() : MoPubNativeAdOrientation
		{
			return _nativeAdsOrientation;
		}

		public function set nativeAdsOrientation( value : MoPubNativeAdOrientation ) : void
		{
			_nativeAdsOrientation = value;
			extensionContext.call( setLockNativeAdsToOrientation, value.id );
		}

		public function get x() : int
		{
			return extensionContext.call( getPositionX ) as int;
		}

		public function set x( value : int ) : void
		{
			extensionContext.call( setPositionX, value );
		}

		public function get y() : int
		{
			return extensionContext.call( getPositionY ) as int;
		}

		public function set y( value : int ) : void
		{
			extensionContext.call( setPositionY, value );
		}

		public function get width() : int
		{
			return extensionContext.call( getWidth ) as int;
		}

		public function set width( value : int ) : void
		{
			_size = null;
			extensionContext.call( setWidth, value );
		}

		public function get height() : int
		{
			return extensionContext.call( getHeight ) as int;
		}

		public function set height( value : int ) : void
		{
			_size = null;
			extensionContext.call( setHeight, value );
		}

		public function get size() : MoPubSize
		{
			return _size;
		}

		public function set size( value : MoPubSize ) : void
		{
			_size = value;
			extensionContext.call( setSize, value.id );
		}

		public function get creativeWidth() : int
		{
			return extensionContext.call( getCreativeWidth ) as int;
		}

		public function get creativeHeight() : int
		{
			return extensionContext.call( getCreativeHeight ) as int;
		}

// methods

		public function MoPubBanner( adUnitId : String, size : MoPubSize )
		{
			extensionContext = ExtensionContext.createExtensionContext( "com.sticksports.nativeExtensions.MoPub", "banner" );
			extensionContext.addEventListener( StatusEvent.STATUS, handleStatusEvent );
			_adUnitId = adUnitId;
			_size = size;
			extensionContext.call( initialiseBanner, adUnitId, size.id );
		}
		
		private function handleStatusEvent( event : StatusEvent ) : void
		{
			switch( event.level )
			{
				case InternalMessages.bannerLoaded :
					dispatchEvent( new MoPubEvent( MoPubEvent.AD_LOADED ) );
					break;
				case InternalMessages.bannerFailedToLoad :
					dispatchEvent( new MoPubEvent( MoPubEvent.AD_FAILED_TO_LOAD ) );
					break;
				case InternalMessages.bannerAdClicked :
					NativeApplication.nativeApplication.addEventListener( Event.ACTIVATE, dispatchClose );
					dispatchEvent( new MoPubEvent( MoPubEvent.BANNER_CLICKED ) );
					break;
			}
		}
		

		private function dispatchClose( event : Event ) : void
		{
			NativeApplication.nativeApplication.removeEventListener( Event.ACTIVATE, dispatchClose );
			dispatchEvent( new MoPubEvent( MoPubEvent.AD_CLOSED ) );
		}
		
		public function load() : void
		{
			extensionContext.call( loadBanner );
		}

		public function show() : void
		{
			extensionContext.call( showBanner );
		}

		public function remove() : void
		{
			extensionContext.call( removeBanner );
		}
		
		public function dispose() : void
		{
			extensionContext.call( disposeBanner );
		}
		
		
		
		///////////
		// DEBUG //
		///////////
		
		public function setDebugSettings(failRate:Number, responseTime:Number):void {
			// Empty here, this is useful for default implementation only.
		}
	}
}

