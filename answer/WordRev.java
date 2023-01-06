class WordRev{
public static void main(String S[]){
	String word="ABCD";

	char ab[]=word.toCharArray();
	for(int i=ab.length-1;i>=0;i--){
		System.out.print(ab[i]);
	}
	
	}
}


