<%-- 
    Document   : dispose_asset2
    Created on : 04 16, 23, 10:38:39 PM
    Author     : ccslearner
--%>

<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="assetmanagement.*, java.util.ArrayList, java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dispose an Asset</title>
    </head>
    <body>
        <h1>Dispose an Asset</h1>
        <%    
            String state = "unsuccessful";
            try {
                int asset_id = Integer.valueOf(request.getParameter("asset_id"));

                Connection conn;
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678");
                
                // dispose asset
                PreparedStatement pst  = conn.prepareStatement("UPDATE assets SET status = 'X' WHERE asset_id = ?");
                pst.setInt(1, asset_id);
                pst.executeUpdate();
                pst.close();
                conn.close();
                
                state = "successful";
            } catch (Exception e) {
        %>
           1    <%= e.toString() %>   
        <% }%>
        <h1>Disposal <%= state %></h1>

        <form action="/DBApp">
        <input type="submit" value="Return to Main Menu" />
        </form>
    </body>
</html>
