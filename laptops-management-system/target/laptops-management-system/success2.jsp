<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<table border="2" width="70%" cellpadding="2">  
<tr><th>name</th><th>ram</th><th>color</th><th>Edit</th><th>Delete</th></tr>  
   <c:forEach var="lap" items="${data}">   
   <tr>  
   <td>${lap.name}</td>  
   <td>${lap.ram}</td>  
   <td>${lap.color}</td>  
   <td><a href="editemp/${emp.name}">Edit</a></td>  
   <td><a href="deleteemp/${emp.name}">Delete</a></td>  
   </tr>  
   </c:forEach>  
   </table>  
   <br/>  
   <a href="empform">Add New Employee</a>  

</body>
</html>