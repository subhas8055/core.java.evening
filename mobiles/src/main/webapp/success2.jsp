<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>mobiles</title>
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
<h1 >List of Mobiles</h1>
<table  class="container" border="3" width="30%" >  
<tr><th>Sl.No</th><th>Brand</th><th>color</th><th>Ram</th><th>Price</th></tr>  
   <c:forEach var="mob" items="${get}">   
   <tr> 
   <td>${mob.getId()}</td>   
   <td>${mob.getBrand()}</td> 
   <td>${mob.getColor()}</td>  
   <td>${mob.getRam()}</td>  
   <td>${mob.getPrice()}</td> 
  
   
   </tr>  
   </c:forEach>  
   </table>  
   <br/>  

</body>
</html>