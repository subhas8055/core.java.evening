<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<center>
<form action="save" method="post" >
<table>
<tr><td>Id :</td><td><input type="number" value="${lap.getId()}" name="id"></td></tr>
<tr><td>Name :</td><td><input type="text" value="${lap.getName()}" name="name"></td></tr>
<tr><td>Ram :</td><td><input type="text" value="${lap.getRam()}" name="ram"></td></tr>
<tr><td>Color :</td><td><input type="text" value="${lap.getColor()}" name="color"></td></tr>

<!--<tr><td>Collection :</td><td><input type="number" name="collection"></td></tr>
<!-- <tr><td>Email :</td><td><input type="email" name="email"></td></tr> -->
<tr><td>

<input type="submit" value="Update"></td></tr>
</table>
</form>
</center>
	
</body>
</html>