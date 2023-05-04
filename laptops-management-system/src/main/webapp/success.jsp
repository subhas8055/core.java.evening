<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<style type="text/css">
input{
border-radius: 50px;
}
button{
border-radius: 50px;
}
</style>
</head>
<body>
<h1>welcome to our application </h1>
<h1>your laptop brand name is ${nam}</h1>
<a href="listoflaptops">List of laptop</a><br><br>

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
<button type="submit">search</button>
</form><br>


</body>
</html>