package com.xworkz.maven.boot;

import java.util.Scanner;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import com.xworkz.maven.configuration.SpringConfiguration;
import com.xworkz.maven.dto.FoodStallDTO;
import com.xworkz.maven.dto.GlassDTO;
import com.xworkz.maven.dto.LaptopDTO;
import com.xworkz.maven.dto.PersonDTO;
import com.xworkz.maven.dto.TrainDTO;
import com.xworkz.maven.dto.WireDTO;

public class Tester {
	public static void main(String[] args) {
		ApplicationContext app =new AnnotationConfigApplicationContext(SpringConfiguration.class);
		System.out.println("persondto");
		PersonDTO person = app.getBean("a",PersonDTO.class);
		System.out.println(person);
		PersonDTO person1 = app.getBean("b",PersonDTO.class);
		System.out.println(person1);
		PersonDTO person2 = app.getBean("c",PersonDTO.class);
		System.out.println(person2);
		PersonDTO person3 = app.getBean("d",PersonDTO.class);
		System.out.println(person3);
		PersonDTO person4 = app.getBean("e",PersonDTO.class);
		System.out.println(person4);
		System.out.println("stall dto");

		FoodStallDTO food = app.getBean("f",FoodStallDTO.class);
		System.out.println(food);
		FoodStallDTO food1 = app.getBean("g",FoodStallDTO.class);
		System.out.println(food1);
		FoodStallDTO food2 = app.getBean("h",FoodStallDTO.class);
		System.out.println(food2);
		FoodStallDTO food3 = app.getBean("i",FoodStallDTO.class);
		System.out.println(food3);
		FoodStallDTO food4 = app.getBean("j",FoodStallDTO.class);
		System.out.println(food4);
		System.out.println("glass dto");

		GlassDTO glass = app.getBean("k",GlassDTO.class);
		System.out.println(glass);
		GlassDTO glass1 = app.getBean("l",GlassDTO.class);
		System.out.println(glass1);
		GlassDTO glass2 = app.getBean("m",GlassDTO.class);
		System.out.println(glass2);
		GlassDTO glass3 = app.getBean("n",GlassDTO.class);
		System.out.println(glass3);
		GlassDTO glass4 = app.getBean("o",GlassDTO.class);
		System.out.println(glass4);
		System.out.println("Laptop dto");

		LaptopDTO laptop = app.getBean("p",LaptopDTO.class);
		System.out.println(laptop);
		LaptopDTO laptop1 = app.getBean("q",LaptopDTO.class);
		System.out.println(laptop1);
		LaptopDTO laptop2 = app.getBean("r",LaptopDTO.class);
		System.out.println(laptop2);
		LaptopDTO laptop3 = app.getBean("s",LaptopDTO.class);
		System.out.println(laptop3);
		LaptopDTO laptop4 = app.getBean("t",LaptopDTO.class);
		System.out.println(laptop4);
		System.out.println("traindto");

		TrainDTO dto = app.getBean("u",TrainDTO.class);
		System.out.println(dto);
		TrainDTO dto1 = app.getBean("v",TrainDTO.class);
		System.out.println(dto1);
		TrainDTO dto2 = app.getBean("w",TrainDTO.class);
		System.out.println(dto2);
		TrainDTO dto3 = app.getBean("x",TrainDTO.class);
		System.out.println(dto3);
		TrainDTO dto4 = app.getBean("y",TrainDTO.class);
		System.out.println(dto4);
		System.out.println("wiredto");

		WireDTO wire = app.getBean("z",WireDTO.class);
		System.out.println(wire);
		WireDTO wire1 = app.getBean("aa",WireDTO.class);
		System.out.println(wire1);
		WireDTO wire2 = app.getBean("ab",WireDTO.class);
		System.out.println(wire2);
		WireDTO wire3 = app.getBean("ac",WireDTO.class);
		System.out.println(wire3);
		WireDTO wire4 = app.getBean("ad",WireDTO.class);
		System.out.println(wire4);
		
		System.out.println("integer");
		Integer in = app.getBean("ae",Integer.class);
		System.out.println(in);
		Integer in1 = app.getBean("af",Integer.class);
		System.out.println(in1);
		Integer in2 = app.getBean("ag",Integer.class);
		System.out.println(in2);
		Integer in3 = app.getBean("ah",Integer.class);
		System.out.println(in3);
		Integer in4 = app.getBean("ai",Integer.class);
		System.out.println(in4);
		System.out.println("float");

		Float fl = app.getBean(Float.class);
		System.out.println(fl);
		System.out.println("byte");

		Byte by = app.getBean(Byte.class);
		System.out.println(by);
		System.out.println("char");

		Character cha = app.getBean("ao",Character.class);
		System.out.println(cha);
		Character cha1 = app.getBean("ap",Character.class);
		System.out.println(cha1);
		Character cha2 = app.getBean("aq",Character.class);
		System.out.println(cha2);
		Character cha3 = app.getBean("ar",Character.class);
		System.out.println(cha3);
		Character cha4 = app.getBean("as",Character.class);
		System.out.println(cha4);
		System.out.println("double");

		Double dou = app.getBean(Double.class);
		System.out.println(dou);
		System.out.println("short");

		Short sh = app.getBean("aj",Short.class);
		System.out.println(sh);
		Short sh1 = app.getBean("ak",Short.class);
		System.out.println(sh1);
		Short sh2 = app.getBean("al",Short.class);
		System.out.println(sh2);
		Short sh3 = app.getBean("am",Short.class);
		System.out.println(sh3);
		Short sh4 = app.getBean("an",Short.class);
		System.out.println(sh4);
		System.out.println("long");

		Long lo = app.getBean(Long.class);
		System.out.println(lo);
		System.out.println("boolean");

		Boolean bool = app.getBean(Boolean.class);
		System.out.println(bool);
		System.out.println("string");

		String  str = app.getBean("at",String.class);
		System.out.println(str);
		String  str1 = app.getBean("au",String.class);
		System.out.println(str1);
		String  str2 = app.getBean("av",String.class);
		System.out.println(str2);
		String  str3 = app.getBean("aw",String.class);
		System.out.println(str3);
		String  str4 = app.getBean("ax",String.class);
		System.out.println(str4);
		System.out.println("scanner");

		Scanner  sc = app.getBean(Scanner.class);
		System.out.println(sc);
		
	}

}
