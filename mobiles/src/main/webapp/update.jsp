<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Update</title>
<style type="text/css">

body{
height:92vh;
width:100%;
background-image: url("https://images.pexels.com/photos/7974/pexels-photo.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2");
background-repeat: no-repeat;
background-size: contain;
background-position: center;

}
div{
position: absolute;
top: 310px;
left: 345px;
color: black;
font-size:xx-large;
font-style: italic;
}

</style>
</head>
<body>
<center>
<form action="${pageContext.request.contextPath}/updateandsave" method="post" >
<table>
<tr><td>Id :</td><td><input type="number" value="${mob.getId()}" name="id"></td></tr>
<tr><td>Brand :</td><td><input type="text" value="${mob.getName()}" name="name"></td></tr>
<tr><td>Ram :</td><td><input type="text" value="${mob.getRam()}" name="ram"></td></tr>
<tr><td>Color :</td><td><input type="text" value="${mob.getColor()}" name="color"></td></tr>
<tr><td>Price :</td><td><input type="number" value="${mob.getPrice()}" name="price"></td></tr>

<!--<tr><td>Collection :</td><td><input type="number" name="collection"></td></tr>
<!-- <tr><td>Email :</td><td><input type="email" name="email"></td></tr> -->
<tr><td>

<input type="submit" value="Update"></td></tr>
</table>
</form>
</center>
<div>Subhas</div>
	
</body>
</html>