<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList, java.sql.*, assetmanagement.*, java.math.BigDecimal, javax.servlet.ServletRequest"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Record Rental</title>
    </head>
    <body>           
        <jsp:useBean id="AR" class="assetmanagement.assetrental" scope="session"/>
        <%
            AR.asset_id = Integer.valueOf(request.getParameter("asset_id"));
            AR.reservation_date = java.sql.Date.valueOf(request.getParameter("reservation_date"));
            AR.rental_date = java.sql.Date.valueOf(request.getParameter("rental_date"));
            AR.rental_amount = new BigDecimal(request.getParameter("rental_amount"));
            AR.discount = new BigDecimal(request.getParameter("discount"));
            AR.resident_id = Integer.valueOf(request.getParameter("resident_id"));
            AR.trans_hoid = Integer.valueOf(request.getParameter("approval_hoid"));
            AR.trans_position = request.getParameter("approval_position");
            AR.trans_electiondate = java.sql.Date.valueOf(request.getParameter("approval_electiondate"));

            if (AR.rentAsset() == 1) {
                %> <hl> Rental successful </hl> <%
            } else {
                %> <hl> Rental unsuccessful </hl> <%
            } %>
    <form action="/DBApp">
        <input type="submit" value="Return to Main Menu" />
    </form>
    </body>
</html>

