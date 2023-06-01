/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author ccslearner
 */
package assetmanagement;
import java.util.ArrayList;
import java.sql.*;
import java.math.BigDecimal;
public class assets {
    
    // fields of assets
    public int asset_id;
    public String asset_name;
    public String asset_description;
    public Date acquisition_date;
    public int forrent;
    public BigDecimal asset_value;
    public String type_asset;
    public String status;
    public BigDecimal loc_lattitude;
    public BigDecimal loc_longiture;
    public String hoa_name;
    public String enclosing_asset;
    
    // lists of assets
    public ArrayList<Integer> asset_idList = new ArrayList<> ();
    public ArrayList<String> asset_nameList = new ArrayList<> ();
    public ArrayList<String> asset_descriptionList = new ArrayList<> ();
    public ArrayList<Date> acquisition_dateList = new ArrayList<> ();
    public ArrayList<Integer> forrentList = new ArrayList<> ();
    public ArrayList<BigDecimal> asset_valueList = new ArrayList<> ();
    public ArrayList<String> type_assetList = new ArrayList<> ();
    public ArrayList<String> statusList = new ArrayList<> ();
    public ArrayList<BigDecimal> loc_latittudeList = new ArrayList<> ();
    public ArrayList<BigDecimal> loc_longitureList = new ArrayList<> ();
    public ArrayList<String> hoa_nameList = new ArrayList<> ();
    public ArrayList<Integer> enclosing_assetList = new ArrayList<> ();
    public ArrayList<Integer> residentIdList = new ArrayList<> ();
    public ArrayList<String> residentList = new ArrayList<> ();
    public assets() {}
    
    public int register_asset() {
        try {
            // This is where we will put codes that will interact with databases
            // 1. Connect to our database
            Connection conn;
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678");
            
            // 2. Prepare our SQL Statements
            //      2.1 To get the next AssetID
            PreparedStatement pstmt  = conn.prepareStatement("SELECT MAX(asset_id) + 1 AS newID FROM assets;");
            ResultSet rst = pstmt.executeQuery();
            while(rst.next()) {
                asset_id = rst.getInt("newID");
            }
            status = "W"; // automatically set to working condition
            
            //      2.2 Save the new Asset
            pstmt = conn.prepareStatement("INSERT INTO assets (`asset_id`, `asset_name`, `asset_description`, `acquisition_date`, `forrent`, `asset_value`, `type_asset`, `status`, `loc_lattitude`, `loc_longiture`, `hoa_name`, `enclosing_asset`) "
                    + "                   VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            pstmt.setInt(1, asset_id);
            pstmt.setString(2, asset_name);
            pstmt.setString(3, asset_description);
            pstmt.setDate(4, acquisition_date);
            pstmt.setInt(5, forrent);
            pstmt.setBigDecimal(6, asset_value);
            pstmt.setString(7, type_asset);
            pstmt.setString(8, status);
            pstmt.setBigDecimal(9, loc_lattitude);
            pstmt.setBigDecimal(10, loc_longiture);
            pstmt.setString(11, hoa_name);
            if (!enclosing_asset.equals("-1")) {
                int en = Integer.parseInt(enclosing_asset);
                pstmt.setInt(12, en);
            } else {
                pstmt.setString(12, null);
            }

            pstmt.executeUpdate();
            pstmt.close();
            conn.close();
            return 1;
        } catch(Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }
    
    public int update_asset() {
        try {
            // This is where we will put codes that will interact with databases
            // 1. Connect to our database
            Connection conn;
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678");
            
            // 2. Prepare our SQL Statements
            
            //      2.2 Save the new Asset
            PreparedStatement pstmt = conn.prepareStatement("UPDATE assets "
                    + "SET asset_name = ?, asset_description = ?, acquisition_date = ?, forrent = ?, asset_value = ?, type_asset = ?, status = ?, loc_lattitude = ?, loc_longiture = ?, hoa_name = ?, enclosing_asset = ? "
                    + "WHERE asset_id = ?");
            pstmt.setString(1, asset_name);
            pstmt.setString(2, asset_description);
            pstmt.setDate(3, acquisition_date);
            pstmt.setInt(4, forrent);
            pstmt.setBigDecimal(5, asset_value);
            pstmt.setString(6, type_asset);
            pstmt.setString(7, status);
            pstmt.setBigDecimal(8, loc_lattitude);
            pstmt.setBigDecimal(9, loc_longiture);
            pstmt.setString(10, hoa_name);
            if (!enclosing_asset.equals("-1")) {
                int en = Integer.parseInt(enclosing_asset);
                pstmt.setInt(11, en);
            } else {
                pstmt.setString(11, null);
            }
            pstmt.setInt(12, asset_id);

            pstmt.executeUpdate();
            pstmt.close();
            conn.close();
            return 1;
        } catch(Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }

    }
    

    
    public int getAllRentableAssets(String hoa_name) {
        try {
            asset_idList = new ArrayList<> ();
            asset_nameList = new ArrayList<> ();
            asset_descriptionList = new ArrayList<> ();
            // Step 0: Connect to DB
            Connection conn;
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678");
            System.out.println("Connection successful");

            // Step 1: Find all assets available for renting.
            String query = "SELECT * FROM assets WHERE forrent = 1 AND hoa_name = ? AND asset_id NOT IN (SELECT ar.asset_id from asset_rentals ar JOIN asset_transactions at ON ar.asset_id = at.asset_id AND ar.rental_date = at.transaction_date WHERE at.isdeleted = 0 AND ar.status IN ('O', 'R'))";
            PreparedStatement statement = conn.prepareStatement(query);
            statement.setString(1, hoa_name);
            ResultSet result = statement.executeQuery();
            
            while (result.next()) {
                int assetID = result.getInt("asset_id");
                String name = result.getString("asset_name");
                String description = result.getString("asset_description");
                asset_idList.add(assetID);
                asset_nameList.add(name);
                asset_descriptionList.add(description);
            }
            
            statement.close();
            conn.close();
            
            System.out.println("Fetching rentable assets successful");
            return 1;
        } catch (Exception e) {
            System.out.println("Fetching rentable assets unsuccessful");
            return 0;
        }
    }
    
    public int getAllResidents(String hoa_name) {
        try {
            residentIdList = new ArrayList<> ();
            residentList = new ArrayList<> ();
            
            // Step 0: Connect to DB
            Connection conn;
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678");
            System.out.println("Connection successful");

            // Step 1: Find all residents
            String query = "SELECT DISTINCT * FROM residents r JOIN properties p ON r.household_id = p.household_id JOIN people ppl ON ppl.peopleid = r.resident_id WHERE p.hoa_name = ?";
            PreparedStatement statement = conn.prepareStatement(query);
            statement.setString(1, hoa_name);
            ResultSet result = statement.executeQuery();
            
            while (result.next()) {
                int residentID = result.getInt("resident_id");
                String name = result.getString("firstname") + " " + result.getString("lastname");
                residentIdList.add(residentID);
                residentList.add(name);
            }
            
            statement.close();
            conn.close();
            
            System.out.println("Fetching rentable assets successful");
            return 1;
        } catch (Exception e) {
            System.out.println("Fetching rentable assets unsuccessful");
            return 0;
        }
    }
        
    public static void main(String args[]) {
        assets A = new assets();
            A.asset_id = 5013;
            A.asset_name = "A";
            A.asset_description = "B";
            A.acquisition_date = Date.valueOf("2000-01-01");
            A.forrent = 1;
            A.asset_value = new BigDecimal("999999");
            A.type_asset = "O";
            A.status = "X";
            A.loc_lattitude = new BigDecimal("0.001");
            A.loc_longiture = new BigDecimal("0.001");
            A.hoa_name = "SMH"; 
            A.enclosing_asset = "-1";  
            A.update_asset();
    }
    
}
