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
<h1>List of Laptops</h1>
<table border="2" width="50%" cellpadding="1">  
<tr><th>slNo</th><th>name</th><th>ram</th><th>color</th></tr>  
   <c:forEach var="lap" items="${data}">   
   <tr> 
   <td>${lap.getId()}</td>   
   <td>${lap.getName()}</td>  
   <td>${lap.getRam()}</td>  
   <td>${lap.getColor()}</td>  
   
   </tr>  
   </c:forEach>  l
   </table>  
   <br/>  

</body>
</html>