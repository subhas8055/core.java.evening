class Wickets{

static String bowlersWomen[] ={"A Mohammed","S Ismail","EA Perry","Nida Dar","SFM Devine","M Schutt","KH Brunt","A Shrubsole","Poonam Yadav","SR Taylor","Sana Mir","JL Jonassen","D Hazell","Salma Khatun","S Ecclestone " };
static int wicketsWomen[] = {125,115,115,114,109,108,108,102,98,98,89,87,85,83,82};


static String bowlersMen[] ={"southee","shakib","rashid","sodhi","malinga","afridi","shabad","rahman","A rashid","jordan","bhuvi","santner","silva","sandeep","umar"} ;
static int wicketsMen [] = {129,128,122,109,107,98,97,97,90,90,89,88,86,85,85};
public static void main(String S[]){
mostWicketsMen();
mostWicketsWomen();
}
public static void mostWicketsMen(){
System.out.println("The highest wicket takers in t20 format are" +bowlersMen.length);
for(int i=0;i<bowlersMen.length;i++){
System.out.println(i+1 +"  "+bowlersMen[i] +"  "+wicketsMen[i]);
}
}
public static void mostWicketsWomen(){
System.out.println("The highest wicket takers in t20 format are" +bowlersWomen);
for(int i=0;i<bowlersWomen.length;i++){
System.out.println(i+1 +"  "+ bowlersWomen[i]+" "+wicketsWomen[i]);
}
}

}