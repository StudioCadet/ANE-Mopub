package com.sticksports.nativeExtensions.mopub {
	
	/**
	 * 
	 */
	public class MoPubKeywords {
		
		public static const GENDER_M:String = "m";
		public static const GENDER_F:String = "f";
		
		public var age:int;
		public var gender:String;
		public var additionalKeywords:Object;
		
		// CONSTRUCTOR :
		public function MoPubKeywords() {
			additionalKeywords = {};
		}
		
		/**
		 * Returns the string to give to MoPub for targeting.
		 */
		public function toMoPubString():String {
			var s:String = "";
			for(var keyword:String in additionalKeywords) {
				s += keyword + ":" + additionalKeywords[keyword] + ",";
			}
			if(age > 0) s += "m_age:" + age + ",";
			if(gender != null) s += "m_gender:" + gender + ",";
			
			return s.substr(0, s.length - 1);
		}
	}
}