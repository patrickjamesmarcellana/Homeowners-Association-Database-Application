<%-- 
    Document   : register_asset_process2
    Created on : 04 16, 23, 10:49:07 AM
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
        <jsp:useBean id="A" class="assetmanagement.assets" scope = "session" />
        <%  // Receive the values from register_asset.html
            String v_asset_name = request.getParameter("asset_name");
            String v_asset_description = request.getParameter("asset_description");
            Date v_acquisition_date = Date.valueOf(request.getParameter("acquisition_date"));
            int v_forrent = Integer.parseInt(request.getParameter("forrent"));
            BigDecimal v_asset_value = new BigDecimal(request.getParameter("asset_value"));
            String v_type_asset = request.getParameter("type_asset");
            BigDecimal v_loc_lattitude = new BigDecimal(request.getParameter("loc_lattitude"));
            BigDecimal v_loc_longiture = new BigDecimal(request.getParameter("loc_longiture"));
            String v_hoa_name = request.getParameter("hoa_name");
            String v_enclosing_asset = request.getParameter("enclosing_asset");
       
            A.asset_name = v_asset_name;
            A.asset_description = v_asset_description;
            A.acquisition_date = v_acquisition_date;
            A.forrent = v_forrent;
            A.asset_value = v_asset_value;
            A.type_asset = v_type_asset;
            A.loc_lattitude = v_loc_lattitude;
            A.loc_longiture = v_loc_longiture;
            A.hoa_name = v_hoa_name; 
            A.enclosing_asset = v_enclosing_asset;
            
            int status = A.register_asset();
            if (status == 1) {
        %>
                <h1> Asset Registration Successful</h1>
        <%  } else {
        %>
                <h1> Asset Registration Unsuccessful</h1>
        <%  }
        %>
        <form action="/DBApp">
            <input type="submit" value="Return to Main Menu" />
        </form>
    </body>
</html>
