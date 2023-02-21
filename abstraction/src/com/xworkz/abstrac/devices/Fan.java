package com.xworkz.abstrac.devices;

import com.xworkz.abstrac.switchbutton.Switchbutton;

public class Fan implements Switchbutton {

	@Override
	public boolean onOrOff() {
		System.out.println("fan on or off");
		return true;
	}
	

}
