class Cricket{

static int points[] ={700,697,694,692,687,665,662,655,653,651,649,646,646,641,637};

static String topBowlersWomen[] ={"Sophie Ecclestone","Deepti Sharma","	Renuka Singh","	Sarah Glenn","	Shabnim Ismail","Hayley Matthews","Megan Schutt","Katherine Brunt","Jess Jonassen","Sneh Rana","Nonkululeko Mlaba","Amelia Kerr","Afy Fletcher","Salma Khatun","Inoka Ranaweera"};
static int pointsWomen[] ={756,742,737,737,707,705,704,694,691,681,669,635,633,630,609};

static String topBowlers [] ={"Rashid Khan","Wanindu Hasaranga","Tabraiz Shamsi","Josh Hazlewood","Mujeeb Ur Rahman","Sam Curran","Adam Zampa","Anrich Nortje","Maheesh Theekshana","Mitchell Santner","Bhuvneshwar Kumar","Adil Rashid","Trent Boult","Keshav Maharaj","Akeal Hosein"};
public static void main(String S[]){
getTopBowlers();
getTopBowlersWomen();

}
public static void getTopBowlers(){
System.out.println("The top ranked bowlers are "+topBowlers.length);
for(int i=0;i<topBowlers.length;i++){
System.out.println(i+1 +" "+ topBowlers[i] +" "+ points[i]);}
}
public static void getTopBowlersWomen(){
	System.out.println("The top ranked women bowlers are" +topBowlersWomen);
	for(int i=0;i<topBowlersWomen.length;i++){
		System.out.println(i+1 +"  "+ topBowlersWomen[i]+ " "+pointsWomen[i]);
	}
}


}