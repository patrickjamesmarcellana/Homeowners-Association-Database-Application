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
        <form action="return_rental2.jsp">
            <jsp:useBean id="AR" class="assetmanagement.assetrental" scope="session"/>
            <% 
            String login_details = request.getParameter("login_details");

            ArrayList<String> credentials = new ArrayList<>();

            if(login_details != null) {
                credentials = new ArrayList<>(Arrays.asList(login_details.split("\\|")));
            } else {
                response.sendRedirect("officer_login.jsp?next=return_rental.jsp");
                return;
            }
          
            String hoa_name = credentials.get(3);
            
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678");
            
            String get_transactions_can_return_statement = "SELECT ar.asset_id, a.asset_name, ar.rental_date" + "\n" +
                                             "FROM asset_rentals ar" + "\n" +
                                             "JOIN asset_transactions aa ON ar.asset_id = aa.asset_id AND ar.rental_date = aa.transaction_date" + "\n" +
                                             "JOIN assets a ON ar.asset_id = a.asset_id" + "\n" +
                                             "WHERE ar.status = 'O' AND aa.isdeleted = 0 AND a.hoa_name = ?;";
            
            PreparedStatement get_transactions_can_return = conn.prepareStatement(get_transactions_can_return_statement);
            get_transactions_can_return.setString(1, credentials.get(3)); // hoa name
            ResultSet rst = get_transactions_can_return.executeQuery();
            
            ArrayList<String> asset_id_date = new ArrayList<>();
            ArrayList<String> asset_name_date = new ArrayList<>();
            while(rst.next()) {
                asset_id_date.add(rst.getString("asset_id")+"|"+rst.getString("rental_date"));
                asset_name_date.add(rst.getString("asset_id") + ": " + rst.getString("asset_name") + " (" + hoa_name + ") [Rental Date: " + rst.getString("rental_date") + "]");
            }
            %>
            
            Asset: <select id="asset_id" name="asset_id">
            <% for (int i = 0; i < asset_id_date.size(); i++) { %>
                <option value=<%=asset_id_date.get(i)%>><%=asset_name_date.get(i)%></option>
            <% } %>
            </select>
            <br>
            
            <input type="hidden" name="approval_hoid" value="<%= credentials.get(0) %>" />
            <input type="hidden" name="approval_position" value="<%= credentials.get(1) %>" />
            <input type="hidden" name="approval_electiondate" value="<%= credentials.get(2) %>" />
            <input type="hidden" name="hoa_name" value="<%= credentials.get(3) %>" />
            <input type="submit" value="Submit">
        </form>
        <form action="/DBApp">
        <input type="submit" value="Return to Main Menu" />
        </form>
    </body>
</html>
