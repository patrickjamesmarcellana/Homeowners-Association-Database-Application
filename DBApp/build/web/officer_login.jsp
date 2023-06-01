<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="assetmanagement.*, java.util.ArrayList, java.sql.*, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Officer Login Required</title>
    </head>
    <body>
        <h1>🔒 Officer Login Required</h1>
        <%
            String next_page = request.getParameter("next");
            
            Connection conn;
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678");
            PreparedStatement pstmt  = conn.prepareStatement("SELECT DISTINCT o.ho_id, o.position, o.election_date, CONCAT(ppl.firstname, ' ', ppl.lastname) AS name, p.hoa_name FROM officer o  JOIN people ppl ON o.ho_id = ppl.peopleid JOIN properties p ON o.ho_id = p.ho_id WHERE (NOW()) <= o.end_date;");
            ResultSet rst = pstmt.executeQuery();
        %>
        <form action = "<%= next_page %>">
            <div class="mb-3">
                <label for="login_details">Select Officer </label>
                <select class="form-select" name="login_details">
                <% while(rst.next()) { %>
                        <option value='<%= rst.getInt("ho_id") %>|<%= rst.getString("position") %>|<%= rst.getDate("election_date") %>|<%= rst.getString("hoa_name") %>'><%= rst.getString("name") %> (<%= rst.getString("hoa_name") %>)</option>
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

