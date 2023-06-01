<%-- 
    Document   : register_asset_process
    Created on : 04 15, 23, 7:48:28 PM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="assetmanagement.*, java.util.ArrayList, java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register an Asset</title>
    </head>
    <body>
        <h1>Register an Asset</h1>
        <%
            Connection conn;
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678");
            PreparedStatement pstmt  = conn.prepareStatement("SELECT hoa_name FROM hoa;");
            ResultSet rst = pstmt.executeQuery();
            ArrayList<String> existingHoa = new ArrayList<>();
            while(rst.next()) {
                existingHoa.add(rst.getString("hoa_name"));
            }
            pstmt  = conn.prepareStatement("SELECT asset_id, asset_name, hoa_name FROM assets WHERE type_asset = 'P';");
            rst = pstmt.executeQuery();
            ArrayList<String> existingAssets = new ArrayList<>();
            ArrayList<String> existingAssetsNames = new ArrayList<>();
            while(rst.next()) {
                existingAssets.add(rst.getString("asset_id"));
                existingAssetsNames.add(rst.getString("asset_name") + " (" + rst.getString("hoa_name") + ")");
            }
            
            
        %>
        <form action = "register_asset_process2.jsp">
            Asset Name: <input type ="text" id ="asset_name" name ="asset_name" required><br>
            Asset Description: <input type ="text" id ="asset_description" name ="asset_description" required><br>
            Acquisition Date: <input type="date" id ="acquisition_date" name="acquisition_date" required><br>
            For Rent:
            <select class="form-select" id="forrent" name="forrent">
                <option value="1">Yes</option>
                <option value="0">No</option>
            </select><br>
            Asset Value: <input type="text" id="asset_value" name="asset_value" required><br>
            Type of Asset: 
            <select class="form-select" id="type_asset" name="type_asset">
                <option value="P">Property</option>
                <option value="E">Equipment</option>
                <option value="F">Furniture and Fixtures</option>
                <option value="O">Others</option>
            </select><br>
            Location Latitude: <input type="text" id="loc_lattitude" name="loc_lattitude" required><br>
            Location Longitude: <input type="text" id="loc_longiture" name="loc_longiture" required><br>
            <div class="mb-3">
                <label for="hoa_name">HOA Name: </label>
                <select class="form-select"  id ="hoa_name" name="hoa_name">
                <% for (int i = 0; i < existingHoa.size(); i++){ %>
                        <option value=<%= existingHoa.get(i)%>><%= existingHoa.get(i)%></option>
                <% } %>
                </select>
            </div> 
            
            <div class="mb-3">
                <label for="enclosing_asset">Enclosing Asset: </label>
                <select class="form-select" name="enclosing_asset">
                <option value ="-1">N/A</option>
                <% for (int i = 0; i < existingAssets.size(); i++){ %>
                        <option value=<%= existingAssets.get(i)%>><%= existingAssetsNames.get(i)%></option>
                <% } %>
                </select>
            </div> 
                
            <input type ="submit" value ="Submit">
        </form>
        <%
            pstmt.close();
            conn.close();
        %>
        <form action="/DBApp">
            <input type="submit" value="Return to Main Menu" />
        </form>
    </body>
</html>
