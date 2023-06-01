<%-- 
    Document   : dispose_asset
    Created on : 04 16, 23, 9:37:20 PM
    Author     : ccslearner
--%>

<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="assetmanagement.*, java.util.ArrayList, java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dispose an Asset</title>
    </head>
    <body>
        <% 
            Connection conn;
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678");
            PreparedStatement pstmt  = conn.prepareStatement("SELECT * FROM assets " +
                                                             "WHERE status != 'X'");
            ResultSet rst = pstmt.executeQuery();
            
            HashMap<String, String> translate_type = new HashMap<>();
            translate_type.put("P", "Property");
            translate_type.put("E", "Equipment");
            translate_type.put("F", "Furniture and Fixtures");
            translate_type.put("O", "Others");
            
            HashMap<String, String> translate_status = new HashMap();
            translate_status.put("W", "Working Condition");
            translate_status.put("D", "Deteriorated");
            translate_status.put("P", "For Repair");
            translate_status.put("S", "For Disposal");
            translate_status.put("X", "Disposed");
        %>
        <h1>Dispose an Asset</h1>
        <p>Select an asset to dispose below.</p>
        
            <% while(rst.next()) { %>
            <a href="dispose_asset2.jsp?asset_id=<%= rst.getInt("asset_id") %>"> 
            
            
            <p style="border: 1px solid black;"> 
                <%= rst.getString("asset_name") %> (<%= rst.getString("hoa_name") %>) 
                <br>
                Asset ID: <%= rst.getInt("asset_id") %>
                <br>
                Description: <%= rst.getString("asset_description") %>
                <br>
                Acquisition Date: <%= rst.getDate("acquisition_date") %>
                <br>
                For rent?: <%= rst.getInt("forrent") == 1 ? "Yes" : "No" %>
                <br>
                Asset value: <%= rst.getInt("asset_value") %>
                <br>
                Asset type: <%= translate_type.get(rst.getString("type_asset")) %>
                <br>
                Status: <%= translate_status.get(rst.getString("status")) %>
                <br>
                Latitude: <%= rst.getBigDecimal("loc_lattitude") %>
                <br>
                Longitude: <%= rst.getBigDecimal("loc_longiture") %>
                <br>
                <% 
                if(rst.getObject("enclosing_asset") != null && rst.getInt("enclosing_asset") != rst.getInt("asset_id")) {
                    PreparedStatement pstmt_sub  = conn.prepareStatement("SELECT asset_name FROM assets WHERE asset_id = ?");
                    pstmt_sub.setInt(1, rst.getInt("enclosing_asset"));
                    ResultSet rst_sub = pstmt_sub.executeQuery();
                    rst_sub.next();
                %>
                    Enclosing asset: <%= rst_sub.getString("asset_name") %>
                <% } %>
            <% } %>
            </p>
            
            <br>
            <form action="/DBApp">
            <input type="submit" value="Return to Main Menu" />
            </form>
    <form action="/DBApp">
            <input type="submit" value="Return to Main Menu" />
    </form>
    </body>
</html>
