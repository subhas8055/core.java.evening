class WicketsMen2{
public static void main (String S[]){
String bowlers[] ={"southee","shakib","rashid","sodhi","malinga","afridi","shabad","rahman","A rashid","jordan","bhuvi","santner","silva","sandeep","umar"} ;
int wickets [] = {129,128,122,109,107,98,97,97,90,90,89,88,86,85,85};
System.out.println("THE TOP WICKET TAKERS AND WICKETS");
System.out.println(bowlers.length);
for (int i=0; i< 14;i++){
	System.out.println(i +" = "+ wickets[i]+"= "+bowlers[i] );
}}}