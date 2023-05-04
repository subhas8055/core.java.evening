<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Laptops</title>
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
font-style: italic	
}

</style>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

</head>
<body>
<h1 >List of Laptops</h1>
<table  class="container" border="3" width="30%" >  
<tr><th>Sl.No</th><th>Name</th><th>Ram</th><th>Color</th><th>Action</th></tr>  
   <c:forEach var="lap" items="${data}">   
   <tr> 
   <td>${lap.getId()}</td>   
   <td>${lap.getName()}</td>  
   <td>${lap.getRam()}</td>  
   <td>${lap.getColor()}</td>  
   <td><a href="update/${lap.getId()}">Update</a></td>
   
   </tr>  
   </c:forEach>  
   </table>  
   <br/>  

</body>
</html>