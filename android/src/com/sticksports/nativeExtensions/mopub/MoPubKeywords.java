package com.sticksports.nativeExtensions.mopub;

import java.util.Date;
import java.util.HashMap;

/**
 * A data class used to store keywords.
 */
public class MoPubKeywords {
	
	// PROPERTIES :
	public Integer age;
	public Date dateOfBirth;
	public String gender;
	public String language;
	public HashMap<String, String> additionalKeywords;
	/** A String of interests keywords, connected with ',' */
	public String interests;

	
	// CONSTRUCTORS :
	public MoPubKeywords() {
		
	}
	
	/**
	 * Returns a concatenated string that Mopub can use to set its keywords.
	 */
	public String getForMopub() {
		String s = "";
		
		if(age != null && age > 0)
			s += "m_age:" + age + ",";
		
		if(gender != null)
			s += "m_gender:" + gender + ",";
		
		if(additionalKeywords != null) {
			for(String keyword : additionalKeywords.keySet()) {
				s += keyword + ":" + additionalKeywords.get(keyword) + ",";
			}
		}
		
		if(s.length() > 0)
			s = s.substring(0, s.length() - 1);
		
		return s;
	}
}
