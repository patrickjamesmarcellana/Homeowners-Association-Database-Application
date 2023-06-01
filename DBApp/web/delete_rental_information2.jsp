<%-- 
    Document   : delete_rental_information2
    Created on : 04 16, 23, 5:09:11 PM
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
                String deletion_details = request.getParameter("deletion_details");
                String[] deletion_details_split = deletion_details.split("\\|");

                int approval_hoid = Integer.valueOf(request.getParameter("approval_hoid"));
                String approval_position = request.getParameter("approval_position");
                java.sql.Date approval_electiondate = java.sql.Date.valueOf(request.getParameter("approval_electiondate"));

                int asset_id = Integer.valueOf(deletion_details_split[0]);
                java.sql.Date transaction_date = java.sql.Date.valueOf(deletion_details_split[1]);

                Connection conn;
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678");

                PreparedStatement pst  = conn.prepareStatement("UPDATE asset_transactions SET isdeleted=1, approval_hoid=?, approval_position=?, approval_electiondate=?" + "\n" +
                                                               "WHERE asset_id=? AND transaction_date=?;");
                pst.setInt(1, approval_hoid);
                pst.setString(2, approval_position);
                pst.setDate(3, approval_electiondate);

                pst.setInt(4, asset_id);
                pst.setDate(5, transaction_date);
                pst.executeUpdate();

                pst.close();
                conn.close();
                
                state = "successful";
            } catch (Exception e) {
                
            }
        %>
        <h1>Deletion <%= state %></h1>

        <form action="/DBApp">
            <input type="submit" value="Return to Main Menu" />
        </form>

    </body>
</html>

