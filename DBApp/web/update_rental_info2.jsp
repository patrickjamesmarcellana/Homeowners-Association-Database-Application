<%-- 
    Document   : update_rental_info2
    Created on : 04 16, 23, 11:57:29 PM
    Author     : ccslearner
--%>

<%@page import="java.util.HashMap"%>
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
        <jsp:useBean id="A" class="assetmanagement.assets" scope="session"/>
        <%
            String[] arr = request.getParameter("asset_rental_to_update").split("\\|");
            String asset_rental_to_update = arr[0];
            String asset_rental_date = arr[1];
            String hoa_name = arr[2];
            
            Connection conn;
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678");
            PreparedStatement pstmt  = conn.prepareStatement("SELECT * FROM asset_transactions at JOIN asset_rentals ar ON at.asset_id = ar.asset_id AND ar.rental_date = at. transaction_date WHERE at.asset_id = ? AND at.transaction_date = ? AND at.transaction_type = 'R';");
            pstmt.setInt(1, Integer.parseInt(asset_rental_to_update));
            pstmt.setString(2, asset_rental_date);
            ResultSet rst = pstmt.executeQuery();
            rst.next();
            
            A.getAllResidents(hoa_name);
        %>
        
        <form action="update_rental_info3.jsp">
            <input type="hidden" name="asset_id" value="<%= asset_rental_to_update %>" />
            <input type="hidden" name="rental_date" value="<%= asset_rental_date %>" />
            Reservation Date: <input type="date" id="reservation_date" name="reservation_date" value=<%= rst.getDate("reservation_date") %> required><br>
            Renter: <select id="resident_id" name="resident_id" >
            <% for (int i = 0; i < A.residentIdList.size(); i++) { %>
            <option value="<%=A.residentIdList.get(i)%>" <%= A.residentIdList.get(i) == rst.getInt("resident_id") ? "selected" : "" %> ><%=A.residentList.get(i)%></option>
            <% } %>
            </select><br>
            Rent Amount: <input type="text" id="rental_amount" name="rental_amount" value=<%= rst.getString("rental_amount") %>><br>
            Discount: <input type="text" id="discount" name="discount" value=<%= rst.getString("discount") %>><br>
            Status: 
            <select class="form-select" id="type_asset" name="status">
                <option value="R" <%= "R".equals(rst.getString("ar.status")) ? "selected" : "" %>>Reserved</option>
                <option value="C" <%= "C".equals(rst.getString("ar.status")) ? "selected" : "" %>>Cancelled</option>
                <option value="O" <%= "O".equals(rst.getString("ar.status")) ? "selected" : "" %>>On-Rent</option>
                <option value="N" <%= "N".equals(rst.getString("ar.status")) ? "selected" : "" %>>Returned</option>
            </select><br>           
		 
            Inspection Details: <input type="text" id="inspection_details" name="inspection_details" value='<%= rst.getString("inspection_details") %>'><br>
            Assessed Value: <input type="text" id="assessed_value" name="assessed_value" value=<%= rst.getString("assessed_value") %>><br>
            Return Date: <input type="date" id="return_date" name="return_date" value=<%= rst.getDate("return_date") %>><br>
            <%  pstmt.close();
                conn.close();
            %>
            <input type ="submit" value ="Submit">
        </form>
        <form action="/DBApp">
            <input type="submit" value="Return to Main Menu" />
        </form>
    </body>
</html>
