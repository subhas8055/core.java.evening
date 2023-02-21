package extras.program.practice;

public class Asdf {
	public static void main(String[] args) {
		
		
		try {
			Class cls = Class.forName("extras.program.practice.Asdf");
			System.out.println("class loaded");
		}catch (Exception e) {
			System.out.println("class not loaded");
		}
		
		int b[] = { 67, 34, 12, 23, 45, 56 };
		int x = b.length;
		int sum = 0;
		int a = 1;
		for (int i = 0; i < b.length; i++) {
			sum = sum + b[i];
			a = a * b[i];
		}
		System.out.println("=====");
		System.out.println("===SUM====");
		System.out.println(sum);
		System.out.println("=====");
		System.out.println("===PRODUCT====");
		System.out.println(a);
		System.out.println("=====");
		System.out.println("===NEXT ODD====");
		for (int i = 0; i < b.length; i++) {
			if (b[i] % 2 == 0) {
				b[i] = b[i] + 1;
				System.out.print(b[i] + " ");
			} else {
				System.out.print(b[i] + " ");
			}

		}
		System.out.println();
		System.out.println("=====");
		System.out.println("====REVERSE===");
		for (int i = b.length - 1; i >= 0; i--) {
			System.out.print(b[i] + " ");

		}
		System.out.println();
		System.out.println("=====");
		System.out.println("===ASCENDING====");
		for (int i = 0; i < b.length; i++) {
			for (int j = 0; j < b.length; j++) {
				if (b[i] < b[j]) {
					int small = b[i];
					b[i] = b[j];
					b[j] = small;

				}
			}
		}

		while (x >= 1) {
			System.out.print(b[b.length - x--] + " ");
		}
		System.out.println("=====");
		System.out.println("===DESCENDING====");
		for (int i = 0; i < b.length; i++) {
			for (int j = 0; j < b.length; j++) {
				if (b[i] > b[j]) {
					int large = b[i];
					b[i] = b[j];
					b[j] = large;

				}
			}
		}
x= b.length;
		while (x <=b.length && x>0 ) {
			System.out.print(b[b.length - x--] + " ");
		}
	}
}
