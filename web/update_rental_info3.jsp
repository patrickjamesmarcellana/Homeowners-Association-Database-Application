<%-- 
    Document   : update_rental_info3
    Created on : 04 17, 23, 2:52:34 AM
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
        <jsp:useBean id="AR" class="assetmanagement.assetrental" scope = "session" />
        <%  // Receive the values from register_asset.html
            int v_asset_id = Integer.parseInt(request.getParameter("asset_id"));
            Date v_reservation_date = Date.valueOf(request.getParameter("reservation_date"));
            Date v_rental_date = Date.valueOf(request.getParameter("rental_date"));
            int v_resident_id = Integer.parseInt(request.getParameter("resident_id"));
            BigDecimal v_rental_amount = new BigDecimal(request.getParameter("rental_amount"));
            BigDecimal v_discount = new BigDecimal(request.getParameter("discount"));
            String v_status = request.getParameter("status");
            String v_inspection_details = null;
            BigDecimal v_assessed_value = null;
            Date v_return_date = null;
            
            try {
                v_assessed_value = new BigDecimal(request.getParameter("assessed_value"));
                v_return_date = Date.valueOf(request.getParameter("return_date"));
                
                // order is important
                v_inspection_details = request.getParameter("inspection_details");
            } catch(Exception e) {}
            AR.asset_id = v_asset_id;
            AR.reservation_date = v_reservation_date;
            AR.rental_date = v_rental_date;
            AR.resident_id = v_resident_id;
            AR.rental_amount = v_rental_amount;
            AR.discount = v_discount;
            AR.status = v_status;
            AR.inspection_details = v_inspection_details;
            AR.assessed_value = v_assessed_value;
            AR.return_date = v_return_date;
                        
            int statusRun = AR.updateRental();
            if (statusRun == 1) {
        %>
                <h1> Asset Rental Update Successful</h1>
        <%  } else {
        %>
                <h1> Asset Rental Update Unsuccessful</h1>
        <%  }
        %>
        <form action="/DBApp">
            <input type="submit" value="Return to Main Menu" />
        </form>
    </body>
</html>
