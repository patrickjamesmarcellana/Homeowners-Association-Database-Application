<%-- 
    Document   : delete_wrongly_encoded_asset2
    Created on : 04 16, 23, 10:08:56 PM
    Author     : ccslearner
--%>

<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="assetmanagement.*, java.util.ArrayList, java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Delete Rental Information</title>
    </head>
    <body>
        <%    
            String state = "unsuccessful";
            try {
                int asset_id = Integer.valueOf(request.getParameter("asset_id"));

                Connection conn;
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678");
                
                // unlink asset
                PreparedStatement pst  = conn.prepareStatement("UPDATE assets SET enclosing_asset = NULL WHERE enclosing_asset = ?");
                pst.setInt(1, asset_id);
                pst.executeUpdate();
                pst.close();
                
                // delete asset
                pst  = conn.prepareStatement("DELETE FROM assets WHERE asset_id = ? AND asset_id NOT IN (SELECT asset_id FROM asset_transactions) AND asset_id NOT IN (SELECT asset_id FROM donated_assets)");
                pst.setInt(1, asset_id);
                pst.executeUpdate();

                pst.close();
                conn.close();
                
                state = "successful";
            } catch (Exception e) {
                %>
                <%= e.toString() %>
            
        <% }%>
        <h1>Deletion <%= state %></h1>

        <form action="/DBApp">
        <input type="submit" value="Return to Main Menu" />
        </form>

    </body>
</html>

