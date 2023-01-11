package com.xworkz.theatre.screen;

public class Screen {
	private String screenId;
	private String movieName;
	private String timing ;
	private int noOfScreens;
	
	public Screen() {
	}
	
		public Screen(String screenId,String movieName,String timing,int noOfScreens) {
			this.screenId= screenId;
			this.movieName= movieName;
			this.timing= timing;
			this.noOfScreens=noOfScreens;
			
		}
		public void setScreenId(String screenId) {
			this.screenId = screenId;
						}
		public String getScreenId() {
			return screenId;
		}
		public void setMovieName(String movieName) {
			this.movieName = movieName;
						}
		public String getmovieName() {
			return movieName;
		}
		public void setTiming(String timing) {
			this.timing = timing;
						}
		public String getTiming() {
			return timing;
		}
		public void setNoOfScreens(int noOfScreens) {
			this.noOfScreens = noOfScreens;
						}
		public int getNoOfScreens() {
			return noOfScreens;
		}
		
}



