<%-- 
    Document   : recordrental2
    Created on : 04 16, 23, 10:52:33 PM
    Author     : ccslearner
--%>

<%@page import="java.util.Arrays"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList, java.sql.*, assetmanagement.*, javax.servlet.ServletRequest"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Record Rental</title>
    </head>
    <body>
        <div>Record Rental</div>
        <form action="recordrental3.jsp">
            <jsp:useBean id="A" class="assetmanagement.assets" scope="session"/>
            <% 
            String login_details = request.getParameter("login_details");

            ArrayList<String> credentials = new ArrayList<>();

            if(login_details != null) {
                credentials = new ArrayList<>(Arrays.asList(login_details.split("\\|")));
            } else {
                response.sendRedirect("officer_login.jsp?next=recordrental2.jsp");
                return;
            }
          
            String hoa_name = credentials.get(3);
            A.getAllRentableAssets(hoa_name);
            A.getAllResidents(hoa_name);
            
            if (A.asset_idList.size() == 0) {
                %> <hl> HOA does not exist or no rentable assets </hl> <%
                return;
            }
            %>
            
            Asset: <select id="asset_id" name="asset_id">
            <% for (int i = 0; i < A.asset_idList.size(); i++) { %>
                <option value=<%=A.asset_idList.get(i)%>><%=A.asset_nameList.get(i)%> | <%=A.asset_descriptionList.get(i)%></option>
            <% } %>
            </select><br>
            
            Reservation Date: <input type="date" id="reservation_date" name="reservation_date" required><br>
            Rental Date: <input type="date" id="rental_date" name="rental_date" required><br>
            
            Renter <select id="resident_id" name="resident_id">
            <% for (int i = 0; i < A.residentIdList.size(); i++) { %>
                <option value=<%=A.residentIdList.get(i)%> ><%=A.residentList.get(i)%></option>
            <% } %>
            </select><br>
            Rent Amount: <input type="text" id="rental_amount" name="rental_amount" required><br>
            Discount: <input type="text" id="discount" name="discount" required><br>
            <input type="hidden" name="approval_hoid" value="<%= credentials.get(0) %>" />
            <input type="hidden" name="approval_position" value="<%= credentials.get(1) %>" />
            <input type="hidden" name="approval_electiondate" value="<%= credentials.get(2) %>" />
            <input type="submit" value="Submit">
        </form>
        <form action="/DBApp">
        <input type="submit" value="Return to Main Menu" />
        </form>
    </body>
</html>