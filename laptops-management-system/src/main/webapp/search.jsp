<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<style type="text/css">

body{
position:relative;
background-image: url("https://images.pexels.com/photos/7974/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2");
background-repeat: no-repeat;
background-size: cover;
background-position: top;
}
button {
	border-radius: 50px;
}
div{
position: absolute;
top: 470px;
left: 180px;
color: olive;				
font-size:3rem;
font-style: italic;
}

</style>

</head>
<body>

<form action="searchbyname" method="get">
Search By Name : <input type="text" name="names" placeholder="please enter the laptop brand name">

<button type="submit">search</button><br>

</form><br>
<form action="searchbyram" method="get">
Search By Ram : <input type="text" name="ram" placeholder="please enter the laptop ram">
<button type="submit">search</button>
</form><br>


<form action="searchbycolor" method="get">
Search By Color : <input type="text" name="color" placeholder="please enter the laptop color">
<button type="submit">search</button></form><br>


<form action="searchbyall" method="get">
Search By All : <input type="text" name="names" placeholder="enter the laptop name">
					<input type="text" name="rams" placeholder="enter the laptop ram">
					<input type="text" name="colors" placeholder="enter the laptop color">
<button type="submit">search</button>
<br><br>
<a href="index.jsp">home</a>
<div>Subhas</div>
</form><br>
</body>
</html>