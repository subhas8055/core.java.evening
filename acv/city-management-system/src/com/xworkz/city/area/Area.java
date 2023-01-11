package com.xworkz.city.area;

public class Area extends Object{
	private String areaId;
	private String areaName;
	private String city;
	private int pincode;
		public Area(String areaId,String areaName,String city,int pincode) {
			this.areaId=areaId;
			this.areaName=areaName;
			this.city=city;
			this.pincode=pincode;
			
			}
		public void setAreaId(String areaId) {
			this.areaId=areaId;
		}
		public String getAreaId() {
			return areaId;
		}
		public void setAreaName(String areaName) {
			this.areaName=areaName;
		}
		public String getAreaName() {
			return areaName;
		}
		public void setCity(String city) {
			this.city =city;
		}
		public String getCity() {
			return city;
		}
		public void setPincode(int pincode) {
			this.pincode =pincode;
		}
		public int getPincode() {
			return pincode;
		}
}
