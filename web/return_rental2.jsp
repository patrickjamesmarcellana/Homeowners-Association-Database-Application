<%@page import="java.util.Arrays"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList, java.sql.*, assetmanagement.*, javax.servlet.ServletRequest"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Return Rental</title>
    </head>
    <body>
        <div>Return Rental</div>
        <form action="return_rental3.jsp">
            <jsp:useBean id="AR" class="assetmanagement.assetrental" scope="session"/>
            <% 
            String id = request.getParameter("asset_id");
            String hoa_name = request.getParameter("hoa_name");
            String asset_id = "";
            String rental_date = "";

            if(id != null) {
                ArrayList<String> id_list = new ArrayList<>();
                id_list = new ArrayList<>(Arrays.asList(id.split("\\|")));
                asset_id = id_list.get(0);
                rental_date = id_list.get(1);
            }
          
            
            
            AR.getAllRentedAssets(Integer.valueOf(asset_id), Date.valueOf(rental_date), hoa_name);
            %>
            
            
            <% 
                String export = "";
                for (int i = 0; i < AR.asset_idList.size(); i++) {
                int subid = AR.asset_idList.get(i);
                export = export + subid + "|";
            %>
            Item <%= AR.asset_nameDescList.get(i) %>: <br>
            Inspection details: <input type="text" name="idt<%=subid%>" required> <br>
            Assessed damages: <input type="number" name="dmg<%=subid%>" required> <br>
            <% } %>
            Return date: <input type="date" name="return_date" required>
            
            
            <input type="hidden" name="approval_hoid" value="<%= request.getParameter("approval_hoid") %>" />
            <input type="hidden" name="approval_position" value="<%= request.getParameter("approval_position") %>" />
            <input type="hidden" name="approval_electiondate" value="<%= request.getParameter("approval_electiondate") %>" />
            <input type="hidden" name="hoa_name" value="<%= request.getParameter("hoa_name") %>" />
            <input type="hidden" name="rental_date" value="<%= rental_date %>" />
            <input type="hidden" name="asset_ids" value="<%=  export.substring(0, export.length() - 1) %>" />
            <input type="submit" value="Submit">
        </form>
        <form action="/DBApp">
        <input type="submit" value="Return to Main Menu" />
        </form>
    </body>
</html>
