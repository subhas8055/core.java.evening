package com.xworkz.abstrac;

import com.xworkz.abstrac.chair.Chair;
import com.xworkz.abstrac.chair.Table;
import com.xworkz.abstrac.devices.Computer;
import com.xworkz.abstrac.devices.Fan;
import com.xworkz.abstrac.devices.TubeLight;
import com.xworkz.abstrac.institute.Institute;
import com.xworkz.abstrac.institute.JuiceShop;
import com.xworkz.abstrac.plastic.Plastic;
import com.xworkz.abstrac.shop.Shop;
import com.xworkz.abstrac.switchbutton.Switchbutton;

public class Tester {
	public static void main(String[] args) {
		Shop shop = new Institute();
		Shop shop1 = new JuiceShop();
	
		Plastic pla1 =new Table();
		Switchbutton sw= new Computer();
		Switchbutton sw1 = new Fan();
		Switchbutton sw2 = new TubeLight();

		
		long x =shop.doBusiness();
		long x1 =shop1.doBusiness();
	//	String x2=pla.touse();
	//
		boolean x4 =sw.onOrOff();
		boolean x5=sw1.onOrOff();
		boolean x6=sw2.onOrOff();
		String x7=pla1.use();
	//	System.out.println(x7);
		System.out.println(x);
		System.out.println(x1);
		//System.out.println(x2);
		//System.out.println(x3);
		System.out.println(x4);
		System.out.println(x5);
		System.out.println(x6);

	}

}
