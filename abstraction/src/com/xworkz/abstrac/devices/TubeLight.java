package com.xworkz.abstrac.devices;

import com.xworkz.abstrac.switchbutton.Switchbutton;

public class TubeLight implements Switchbutton {

	@Override
	public boolean onOrOff() {
		System.out.println("tubelight on or off");
		return true;
	}
	

}
