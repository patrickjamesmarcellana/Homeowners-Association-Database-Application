<%@page import="java.util.Arrays"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList, java.sql.*, assetmanagement.*, java.math.BigDecimal, javax.servlet.ServletRequest"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Record Return</title>
    </head>
    <body>           
        <jsp:useBean id="AR" class="assetmanagement.assetrental" scope="session"/>
        <%
            ArrayList<String> id_list = new ArrayList<>(Arrays.asList(request.getParameter("asset_ids").split("\\|")));
            AR.asset_idList = new ArrayList<>();
            for(String x : id_list) {
                AR.asset_idList.add(Integer.valueOf(x));
            }
            AR.return_date = java.sql.Date.valueOf(request.getParameter("return_date"));
            AR.rental_date = java.sql.Date.valueOf(request.getParameter("rental_date"));
            AR.accept_position = request.getParameter("approval_position");
            AR.accept_electiondate = java.sql.Date.valueOf(request.getParameter("approval_electiondate"));
            AR.accept_hoid = Integer.valueOf(request.getParameter("approval_hoid"));
            
            for(int id : AR.asset_idList) {
                AR.inspection_detailsList.add(request.getParameter("idt" + id));
                AR.assessed_valueList.add(new BigDecimal(request.getParameter("dmg" + id)));
            }

            if (AR.returnAsset() == 1) {
                %> <hl> Return successful </hl> <%
            } else {
                %> <hl> Return unsuccessful </hl> <%
            } %>
    <form action="/DBApp">
        <input type="submit" value="Return to Main Menu" />
    </form>
    </body>
</html>

