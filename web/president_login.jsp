<%-- 
    Document   : president_login
    Created on : 04 16, 23, 5:09:31 PM
    Author     : ccslearner
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="assetmanagement.*, java.util.ArrayList, java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>President Authorization Required</title>
    </head>
    <body>
        <h1>🔒 President Authorization Required</h1>
        <%
            String next_page = request.getParameter("next");
            
            Connection conn;
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678");
            PreparedStatement pstmt  = conn.prepareStatement("SELECT o.ho_id, o.position, o.election_date, CONCAT(ppl.firstname, ' ', ppl.lastname) AS name FROM officer o JOIN officer_presidents op ON o.ho_id = op.ho_id AND o.position = op.position AND o.election_date = op.election_date JOIN people ppl ON o.ho_id = ppl.peopleid WHERE (NOW()) <= o.end_date;");
            ResultSet rst = pstmt.executeQuery();
        %>
        <form action = "<%= next_page %>">
            <div class="mb-3">
                <label for="login_details">Select President </label>
                <select class="form-select" name="login_details">
                <% while(rst.next()) { %>
                        <option value='<%= rst.getInt("ho_id") %>|<%= rst.getString("position") %>|<%= rst.getDate("election_date") %>'><%= rst.getString("name") %></option>
                <% } %>
                </select>
            </div> 
                
            <input type ="submit" value ="Submit">
        </form>
        <%
            pstmt.close();
            conn.close();
        %>
        <form action="/DBApp">
            <input type="submit" value="Return to Main Menu" />
        </form>
    </body>
</html>

