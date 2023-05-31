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
<h1 >List of Players</h1>
<table  class="container" border="3" width="30%" >  
<<tr><th>SlNo</th><th>Name</th><th>Game</th><th>Country</th><th>DOB</th></tr>
 <c:forEach var="play" items="${playerdata}">   
   <tr> 
   <td>${play.getId()}</td>   
   <td>${play.getName()}</td>  
   <td>${play.getGame()}</td>  
   <td>${play.getCountry()}</td>  
   <td>${play.getDob()}</td>  
   
   </tr>  
   </c:forEach> 

   </table>  
   <br/>  

</body>
</html>