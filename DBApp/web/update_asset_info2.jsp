<%-- 
    Document   : update_asset_info2
    Created on : 04 16, 23, 10:43:10 AM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="assetmanagement.*, java.util.ArrayList, java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Asset Information</title>
    </head>
    <body>
        <h1>Update Asset Information</h1>
        <%
            String assetToUpdate = request.getParameter("asset_to_update");
        %>
        <h2>Chosen Asset ID: <%= assetToUpdate%></h2><br>
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
            
            // Get existing asset record
            // get asset_name
            pstmt = conn.prepareStatement("SELECT asset_name FROM assets WHERE asset_id = ?;");
            pstmt.setInt(1, Integer.parseInt(assetToUpdate));
            rst = pstmt.executeQuery();
            String default_name = "";
            while(rst.next()) {
                default_name = rst.getString("asset_name");
            }
            
            // get asset_description
            pstmt = conn.prepareStatement("SELECT asset_description FROM assets WHERE asset_id = ?;");
            pstmt.setInt(1, Integer.parseInt(assetToUpdate));
            rst = pstmt.executeQuery();
            String default_description = "";
            while(rst.next()) {
                default_description = rst.getString("asset_description");
            }
            
            // get acquisition date
            pstmt = conn.prepareStatement("SELECT acquisition_date FROM assets WHERE asset_id = ?;");
            pstmt.setInt(1, Integer.parseInt(assetToUpdate));
            rst = pstmt.executeQuery();
            String default_date = "";
            while(rst.next()) {
                default_date = rst.getString("acquisition_date");
            }
            
            // get forrent value
            pstmt = conn.prepareStatement("SELECT forrent FROM assets WHERE asset_id = ?;");
            pstmt.setInt(1, Integer.parseInt(assetToUpdate));
            rst = pstmt.executeQuery();
            int default_forrent = 0;
            while(rst.next()) {
                default_forrent = rst.getInt("forrent");
            }
            
            // get asset value
            pstmt = conn.prepareStatement("SELECT asset_value FROM assets WHERE asset_id = ?;");
            pstmt.setInt(1, Integer.parseInt(assetToUpdate));
            rst = pstmt.executeQuery();
            String default_asset_value = "";
            while(rst.next()) {
                default_asset_value = rst.getString("asset_value");
            }
            
            // get asset type
            pstmt = conn.prepareStatement("SELECT type_asset FROM assets WHERE asset_id = ?;");
            pstmt.setInt(1, Integer.parseInt(assetToUpdate));
            rst = pstmt.executeQuery();
            String default_type = "";
            while(rst.next()) {
                default_type = rst.getString("type_asset");
            }
            
            // get status
            pstmt = conn.prepareStatement("SELECT status FROM assets WHERE asset_id = ?;");
            pstmt.setInt(1, Integer.parseInt(assetToUpdate));
            rst = pstmt.executeQuery();
            String default_status = "";
            while(rst.next()) {
                default_status = rst.getString("status");
            }
            
            // get loc_lattitude
            pstmt = conn.prepareStatement("SELECT loc_lattitude FROM assets WHERE asset_id = ?;");
            pstmt.setInt(1, Integer.parseInt(assetToUpdate));
            rst = pstmt.executeQuery();
            String default_lattitude = "";
            while(rst.next()) {
                default_lattitude = rst.getString("loc_lattitude");
            }
            
            // get loc_longitude
            pstmt = conn.prepareStatement("SELECT loc_longiture FROM assets WHERE asset_id = ?;");
            pstmt.setInt(1, Integer.parseInt(assetToUpdate));
            rst = pstmt.executeQuery();
            String default_longiture = "";
            while(rst.next()) {
                default_longiture = rst.getString("loc_longiture");
            }
            
            // get hoa_name
            pstmt = conn.prepareStatement("SELECT hoa_name FROM assets WHERE asset_id = ?;");
            pstmt.setInt(1, Integer.parseInt(assetToUpdate));
            rst = pstmt.executeQuery();
            String default_hoa = "";
            while(rst.next()) {
                default_hoa = rst.getString("hoa_name");
            }
            
            // get enclosing_asset
            pstmt = conn.prepareStatement("SELECT enclosing_asset FROM assets WHERE asset_id = ?;");
            pstmt.setInt(1, Integer.parseInt(assetToUpdate));
            rst = pstmt.executeQuery();
            String default_enclosing = "";
            while(rst.next()) {
                default_enclosing = rst.getString("enclosing_asset");
            }
                      
            
            pstmt.close();
            conn.close();
        %>
        <form action = "update_asset_info3.jsp">
            <input type="hidden" id="assetToUpdate" name="assetToUpdate" value ="<%=assetToUpdate%>">
            Asset Name: <input type ="text" value="<%=default_name%>" id ="asset_name" name ="asset_name" required><br>
            Asset Description: <input type ="text" value ="<%=default_description%>" id ="asset_description" name ="asset_description" required><br>
            Acquisition Date: <input type="date" value ="<%=default_date%>" id ="acquisition_date" name="acquisition_date" required><br>
            For Rent:
            <select class="form-select" id="forrent" name="forrent">
                <%if(default_forrent == 1) {
                    
                %>
                    <option value="1" selected>Yes</option>
                    <option value="0">No</option>
                <%} else {%>
                    <option value="1">Yes</option>
                    <option value="0" selected>No</option>
                <%}%>
            </select><br>
            Asset Value: <input type="text" value ="<%=default_asset_value%>" id="asset_value" name="asset_value" required><br>
            Type of Asset: 
            <select class="form-select" id="type_asset" name="type_asset">
                <% if(default_type.equals("P")) {
                %>
                    <option value="P" selected>Property</option>
                    <option value="E">Equipment</option>
                    <option value="F">Furniture and Fixtures</option>
                    <option value="O">Others</option>
                <%} else if(default_type.equals("E")) {%>
                    <option value="P">Property</option>
                    <option value="E" selected>Equipment</option>
                    <option value="F">Furniture and Fixtures</option>
                    <option value="O">Others</option>
                <%} else if(default_type.equals("F")) {%>
                    <option value="P">Property</option>
                    <option value="E">Equipment</option>
                    <option value="F" selected>Furniture and Fixtures</option>
                    <option value="O">Others</option>
                <%} else {%>
                    <option value="P">Property</option>
                    <option value="E">Equipment</option>
                    <option value="F" >Furniture and Fixtures</option>
                    <option value="O" selected>Others</option>
                <%}%>
            </select><br>
            Status: 
            <select class="form-select" id="status" name="status">
                <% if(default_status.equals("W")) {%>
                    <option value="W" selected>Working Condition</option>
                    <option value="D">Deteriorated</option>
                    <option value="P">For Repair</option>
                    <option value="S">For Disposal</option>
                    <option value="X">Disposed</option>
                <%} else if(default_type.equals("D")) {%>
                    <option value="W">Working Condition</option>
                    <option value="D" selected>Deteriorated</option>
                    <option value="P">For Repair</option>
                    <option value="S">For Disposal</option>
                    <option value="X">Disposed</option>
                <%} else if(default_type.equals("P")) {%>
                    <option value="W">Working Condition</option>
                    <option value="D">Deteriorated</option>
                    <option value="P" selected>For Repair</option>
                    <option value="S">For Disposal</option>
                    <option value="X">Disposed</option>
                <%} else if(default_type.equals("S")) {%>
                    <option value="W">Working Condition</option>
                    <option value="D">Deteriorated</option>
                    <option value="P">For Repair</option>
                    <option value="S" selected>For Disposal</option>
                    <option value="X">Disposed</option>
                <%} else {%>
                    <option value="W">Working Condition</option>
                    <option value="D">Deteriorated</option>
                    <option value="P">For Repair</option>
                    <option value="S">For Disposal</option>
                    <option value="X" selected>Disposed</option>
                <%}%>
            </select><br>
            Location Latitude: <input type="text" value ="<%=default_lattitude%>" id="loc_lattitude" name="loc_lattitude" required><br>
            Location Longitude: <input type="text" value ="<%=default_longiture%>" id="loc_longiture" name="loc_longiture" required><br>
            <div class="mb-3">
                <label for="hoa_name">HOA Name: </label>
                <select class="form-select"  id ="hoa_name" name="hoa_name">
                <% for (int i = 0; i < existingHoa.size(); i++){ 
                        if(default_hoa.equals(existingHoa.get(i))) {%>
                            <option value="<%= existingHoa.get(i)%>" selected><%= existingHoa.get(i)%></option>
                <%      } else {%>
                            <option value="<%= existingHoa.get(i)%>"><%= existingHoa.get(i)%></option>
                <%      }%>
                <% } %>
                </select>
            </div> 
            
            <div class="mb-3">
                <label for="enclosing_asset">Enclosing Asset: </label>
                <select class="form-select" name="enclosing_asset">
                <% if(default_enclosing == null) {%>
                    <option value ="-1" selected>N/A</option>
                    <% for (int i = 0; i < existingAssets.size(); i++){ %>
                            <option value="<%= existingAssets.get(i)%>"><%= existingAssetsNames.get(i)%></option>
                    <% } %>
                <%} else {%>
                    <option value ="-1">N/A</option>
                    <% for (int i = 0; i < existingAssets.size(); i++){ %>
                            <%if(default_enclosing.equals(existingAssets.get(i))) {%>
                                <option value="<%= existingAssets.get(i)%>" selected><%= existingAssetsNames.get(i)%></option>
                            <%} else {%>
                                <option value ="<%= existingAssets.get(i)%>"><%= existingAssetsNames.get(i)%></option>
                            <%} %>
                    <% } %>
                <%}%>
                </select>
            </div> 
                
            <input type ="submit" value ="Submit">
        </form>
        <form action="/DBApp">
        <input type="submit" value="Return to Main Menu" />
        </form>
    </body>
</html>
