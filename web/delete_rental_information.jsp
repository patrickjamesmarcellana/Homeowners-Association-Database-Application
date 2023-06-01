<%-- 
    Document   : delete_rental_information
    Created on : 04 16, 23, 5:08:05 PM
    Author     : ccslearner
--%>

<%@page import="java.util.Arrays"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="assetmanagement.*, java.util.ArrayList, java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Delete Rental Information</title>
    </head>
    <body>
        <h1>Delete Rental Information</h1>
        <%  
            String login_details = request.getParameter("login_details");

            ArrayList<String> credentials = new ArrayList<>();
            
            if(login_details != null) {
                credentials = new ArrayList<>(Arrays.asList(login_details.split("\\|")));
            } else {
                response.sendRedirect("president_login.jsp?next=delete_rental_information.jsp");
                return;
            }
            
            
            Connection conn;
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678");
            
            String get_transactions_can_delete_statement = "SELECT aa.asset_id, a.asset_name, a.hoa_name, aa.transaction_date" + "\n" +
                                             "FROM asset_transactions aa" + "\n" +
                                             "JOIN assets a ON aa.asset_id = a.asset_id" + "\n" +
                                             "JOIN asset_rentals ar ON ar.asset_id = aa.asset_id AND ar.rental_date = aa.transaction_date " + 
                                             "WHERE aa.transaction_type = 'R' AND aa.isdeleted = 0 AND a.hoa_name IN (SELECT DISTINCT hoa_name FROM properties WHERE ho_id = ?);"  + "\n";
            
            PreparedStatement get_transactions_can_delete = conn.prepareStatement(get_transactions_can_delete_statement);
            get_transactions_can_delete.setInt(1, Integer.valueOf(credentials.get(0)));
            ResultSet rst = get_transactions_can_delete.executeQuery();
        %>
        <form action = "delete_rental_information2.jsp">
            <div class="mb-3">
                <label for="login_details">Select</label>
                <select class="form-select" name="deletion_details">
                <% while(rst.next()) { %>
                    <option value='<%= rst.getInt("asset_id") %>|<%= rst.getDate("transaction_date") %>'><%= rst.getString("asset_name") %> (<%= rst.getString("hoa_name") %>, rented on <%= rst.getString("transaction_date") %>)</option>
                <% } %>
                <input type="hidden" name="approval_hoid" value="<%= credentials.get(0) %>" />
                <input type="hidden" name="approval_position" value="<%= credentials.get(1) %>" />
                <input type="hidden" name="approval_electiondate" value="<%= credentials.get(2) %>" />
                </select>
            </div> 
                
            <input type ="submit" value ="Submit">
        </form>
        <%
            get_transactions_can_delete.close();
            conn.close();
        %>
        <form action="/DBApp">
            <input type="submit" value="Return to Main Menu" />
        </form>
    </body>
</html>

