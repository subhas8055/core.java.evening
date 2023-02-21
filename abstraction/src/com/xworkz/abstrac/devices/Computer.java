package com.xworkz.abstrac.devices;

import com.xworkz.abstrac.switchbutton.Switchbutton;

public class Computer implements Switchbutton{

	@Override
	public boolean onOrOff() {
		// TODO Auto-generated method stub
		System.out.println("computer on or off");
		return true;
	}

}
