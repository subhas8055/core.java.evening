package com.xworkz.airport;

import com.xworkz.airport.airport.Airport;
import com.xworkz.airport.airport.KIA;
import com.xworkz.airport.airport.Sambra;

public class Tester extends Object {
public static void main(String[] args) {
	Airport airport = new KIA();
	Airport sambra = new Sambra();
	KIA kia = (KIA)airport;
	kia.display();

}
}
