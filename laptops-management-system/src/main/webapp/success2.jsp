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
a{
border: 1px solid black;
border-radius: 50px;
width: 200px;
color: blue;
text-decoration: none;
}


</style>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script type="text/javascript"> 


</script>
</head>
<body>
<h1 >List of Laptops</h1><a href="index.jsp">home</a>
<table  class="container" border="3" width="30%" >  
<tr><th>Sl.No</th><th>Name</th><th>Ram</th><th>Color</th><th style="width: 200px">Action</th></tr>
   <c:forEach var="lap" items="${data}">   
   <tr> 
   <td>${lap.getId()}</td>   
   <td>${lap.getName()}</td>  
   <td>${lap.getRam()}</td>  
   <td>${lap.getColor()}</td>  
   <td><a  href="update/${lap.getId()}">Update</a>||<a  style="color: red" href="${pageContext.request.contextPath}/delete/${lap.getId()}">Delete</a></td>
   
   </tr>  
   </c:forEach>  
   </table>  
   <br/>  

</body>
</html>