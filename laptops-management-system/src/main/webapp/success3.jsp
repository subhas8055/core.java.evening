<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<table  class="container" border="3" width="30%" >  
<tr><th>Sl.No</th><th>Name</th><th>Ram</th><th>Color</th></tr>  
   <tr> 
   <td>${lap.getId()}</td>   
   <td>${lap.getName()}</td>  
   <td>${lap.getRam()}</td>  
   <td>${lap.getColor()}</td>  
   
   </tr>  
   </table>  
</body>
</html>