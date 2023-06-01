<%-- 
    Document   : update_rental_info
    Created on : 04 16, 23, 11:14:51 PM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="assetmanagement.*, java.util.ArrayList, java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Rental Information</title>
    </head>
    <body>
        <h1>Update Rental Information</h1>
        <%
            Connection conn;
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678");
            
            PreparedStatement pstmt  = conn.prepareStatement("SELECT ar.asset_id, ar.rental_date, a.asset_name, a.hoa_name FROM asset_rentals ar JOIN assets a ON ar.asset_id = a.asset_id;");
            ResultSet rst = pstmt.executeQuery();
            ArrayList<String> existingIDs = new ArrayList<>();
            ArrayList<String> existingDates = new ArrayList<>();
            ArrayList<String> existingAssetsNames = new ArrayList<>();
            ArrayList<String> existingHOANames = new ArrayList<>();
            ArrayList<String> values = new ArrayList<>();
            while(rst.next()) {
                existingIDs.add(rst.getString("ar.asset_id"));
                existingDates.add(rst.getString("ar.rental_date"));
                existingAssetsNames.add(rst.getString("a.asset_name") + " (" + rst.getString("a.hoa_name") + ")");
                values.add(rst.getString("ar.asset_id") + "|" + rst.getString("ar.rental_date") + "|" + rst.getString("a.hoa_name"));
            }
            pstmt.close();
            conn.close();
            

        %>
        <form action = "update_rental_info2.jsp">
             
            <div class="mb-3">
                <label for="asset_rental_to_update">Choose an Asset Rental to Update: </label>
                <select class="form-select" name="asset_rental_to_update">
                    <% for (int i = 0; i < existingIDs.size(); i++){ %>
                            <option value=<%= values.get(i)%>><%= existingIDs.get(i)%>: <%= existingAssetsNames.get(i)%> [Rental Date: <%=existingDates.get(i)%>]</option>
                    <% } %>
                </select>
            </div> 
            
            <input type ="submit" value ="Submit">
        </form>
        <form action="/DBApp">
            <input type="submit" value="Return to Main Menu" />
        </form>
    </body>
</html>
