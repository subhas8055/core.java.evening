<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Players</title>
<style >
table{
text-align: center;


}
th{
font-weight: 800;
background-color: blue;
color: white;
height: 50px;

}
h1{
font-style: italic;
}

</style>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

</head>
<body>
<h1>welcome to our app</h1>
<h2>you have successfully registered ${player}</h2>
<a href="listofplayers">List of players</a>

</body>
</html>