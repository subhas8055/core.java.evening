package extras.program.practice;

import java.io.File;
import java.io.IOException;
import java.util.Scanner;

public class Ghjk {
public Ghjk(int size) {
		
	}
	public static void main(String[] args) {
		
	
	Scanner s = new Scanner(System.in);
	System.out.println("please enter size");
	int size =s.nextInt();
	for(int i=1;i<=size;i++) {
	System.out.println("please enter file name");
	File file = new File(s.next());
	try {
		file.createNewFile();
		
		System.out.println("file created");
	} catch (IOException e) {
		
		e.printStackTrace();
	}
	}}
}
