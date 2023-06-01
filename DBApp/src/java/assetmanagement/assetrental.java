package assetmanagement;

import java.util.ArrayList;
import java.sql.*;
import java.math.BigDecimal;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.Set;

public class assetrental {
    String connURL = "jdbc:mysql://localhost:3306/HOADB?useTimezone=true&serverTimezone=UTC&user=root&password=12345678";
    
    String query; // used for storing string SQL queries
    PreparedStatement statement; // used for storing prepared statements
    ResultSet result; // used for storing SQL query results
    
    public int asset_id;
    public Date rental_date;
    public Date reservation_date;
    public int resident_id;
    public int trans_hoid;
    public String trans_position;
    public Date trans_electiondate;
    public BigDecimal rental_amount;
    public BigDecimal discount;
    public String status;
    public String inspection_details;
    public BigDecimal assessed_value;
    public int accept_hoid;
    public String accept_position;
    public Date accept_electiondate;
    public Date return_date;
    public String hoa_name;
    public Date new_rental_date;
    
    public ArrayList<Integer> asset_idList  = new ArrayList<>();
    public ArrayList<Date> rental_dateList  = new ArrayList<>();
    public ArrayList<Date> reservation_dateList  = new ArrayList<>();
    public ArrayList<Integer> resident_idLIstList  = new ArrayList<>();
    public ArrayList<BigDecimal> rental_amountList  = new ArrayList<>();
    public ArrayList<BigDecimal> discountList  = new ArrayList<>();
    public ArrayList<String> statusList  = new ArrayList<>();
    public ArrayList<String> inspection_detailsList  = new ArrayList<>();
    public ArrayList<BigDecimal> assessed_valueList  = new ArrayList<>();
    public ArrayList<Integer> accept_hoidList  = new ArrayList<>();
    public ArrayList<String> accept_positionList  = new ArrayList<>();
    public ArrayList<Date> accept_electiondateList  = new ArrayList<>();
    public ArrayList<Date> return_dateList  = new ArrayList<>();
    public ArrayList<String> asset_nameDescList;
    
    public int rentAsset() {
        try {
            // Step 0: Connect to DB
            Connection conn;
            conn = DriverManager.getConnection(connURL);
            System.out.println("Renting assets connection successful");
            
            // Step 1: Set resident to being a renter.
            /*query = "UPDATE residents SET renter = 1 WHERE resident_id = ?";
            statement = conn.prepareStatement(query);
            statement.setInt(1, resident_id);
            statement.executeUpdate();*/
            
            // Step 2: Put all asset ids to list which will all be set to being
            // rented and have a rental and transaction entry created for.
            asset_idList.clear();
            asset_idList.add(asset_id); // main asset being rented
            
            query = "SELECT asset_id FROM assets WHERE enclosing_asset = ? AND enclosing_asset NOT IN (SELECT ar.asset_id from asset_rentals ar JOIN asset_transactions at ON ar.asset_id = at.asset_id AND ar.rental_date = at.transaction_date WHERE at.isdeleted = 0 AND ar.status IN ('O', 'R'));"; // ensure asset is not On rent/Reserved
            statement = conn.prepareStatement(query);
            statement.setInt(1, asset_id);
            result = statement.executeQuery();
            
            while (result.next()) {
                int assetID = result.getInt("asset_id");
                asset_idList.add(assetID);
            }
            
            // deduplicate
            Set<Integer> set = new LinkedHashSet<>(asset_idList);
            asset_idList.clear();
            asset_idList.addAll(set);
            
            // Step 3: Get next OR number.
            query = "SELECT MAX(ornum) + 1 AS ornum FROM ref_ornumbers";
            statement = conn.prepareStatement(query);
            result = statement.executeQuery();
            
            int nextOrnum = 1; // if no records yet, default is 1
            while (result.next()) {
                nextOrnum = result.getInt("ornum");
            }

            
            // Step 4: For all asset ids in the list, set all to be rented
            // and generate a rental and transaction entry.
            // Only one "depth" of child assets are done. For more "depths",
            // look into recursive SQL statements or graph algorithms.
            for (int id : asset_idList) {
                // Set asset to rented
                /*query = "UPDATE assets SET forrent = 0 WHERE assetid = ?";
                statement = conn.prepareStatement(query);
                statement.setInt(1, id);
                statement.executeUpdate();*/
                
                // Create new OR number reference for asset
                // Commented out, let them share an OR num
                query = "INSERT INTO ref_ornumbers (ornum) VALUE(?)";
                statement = conn.prepareStatement(query);
                statement.setInt(1, nextOrnum);
                statement.executeUpdate();
                
                // Create transaction for asset
                query = "INSERT INTO asset_transactions (asset_id, transaction_date, "
                    + "trans_hoid, trans_position, trans_electiondate, isdeleted, "
                    + "ornum, transaction_type )"
                    + "VALUE (?, ?, ?, ?, ?, ?, ?, ?)";
                statement = conn.prepareStatement(query);
                statement.setInt(1, id);
                statement.setDate(2, rental_date);
                statement.setInt(3, trans_hoid);
                statement.setString(4, trans_position);
                statement.setDate(5, trans_electiondate);
                statement.setInt(6, 0); // not deleted
                statement.setInt(7, nextOrnum);
                statement.setString(8, "R"); // R for rental
                statement.executeUpdate();
                
                // Create rental for asset
                query = "INSERT INTO asset_rentals (asset_id, rental_date, "
                    + "reservation_date, resident_id, rental_amount, discount, "
                    + "status) "
                    + "VALUES(?, ?, ?, ?, ?, ?, ?)";
                statement = conn.prepareStatement(query);
                statement.setInt(1, id);
                statement.setDate(2, rental_date);
                statement.setDate(3, reservation_date);
                statement.setInt(4, resident_id);
                statement.setBigDecimal(5, rental_amount);
                statement.setBigDecimal(6, discount);
                statement.setString(7, "O"); // O for On Rent
                statement.executeUpdate();
                
                nextOrnum += 1; // generate a new OR number for each asset
            }
                        
            statement.close();
            conn.close();
            System.out.println("Asset rental successful");
            return 1;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Renting assets connection failed");
            return 0;
        }
    }
    
    public int getAllRentedAssets(int assetid, Date rentaldate, String hoa_name) {
        try {
            asset_idList = new ArrayList<>();
            rental_dateList = new ArrayList<>();
            reservation_dateList = new ArrayList<>();
            resident_idLIstList = new ArrayList<>();
            rental_amountList = new ArrayList<>();
            discountList = new ArrayList<>();
            statusList = new ArrayList<>();
            inspection_detailsList = new ArrayList<>();
            assessed_valueList = new ArrayList<>();
            accept_hoidList = new ArrayList<>();
            accept_positionList = new ArrayList<>();
            accept_electiondateList = new ArrayList<>();
            return_dateList = new ArrayList<>();
            asset_nameDescList = new ArrayList<>();
            
            // Step 0: Connect to DB.
            Connection conn;
            conn = DriverManager.getConnection(connURL);
            System.out.println("Fetching rented assets connection successful");
            
            // Step 1: Get main asset info.
            query = "SELECT a.asset_name, a.asset_description, ar.asset_id, ar.rental_date, ar.reservation_date, "
                    + "ar.resident_id, ar.rental_amount, ar.discount, ar.status, "
                    + "ar.inspection_details, ar.assessed_value, ar.accept_hoid, "
                    + "ar.accept_position, ar.accept_electiondate, ar.return_date "
                    + "FROM asset_rentals ar JOIN assets a ON ar.asset_id = a.asset_id "
                    + "WHERE a.asset_id = ? AND ar.rental_date = ? AND ar.status = ?";
            statement = conn.prepareStatement(query);
            statement.setInt(1, assetid);
            statement.setDate(2, rentaldate);
            statement.setString(3, "O"); // O for On Rent
            result = statement.executeQuery();
            
            while (result.next()) {
                int assetID = result.getInt("asset_id");
                Date _rentaldate = result.getDate("rental_date");
                Date reservationdate = result.getDate("reservation_date");
                int residentID = result.getInt("resident_id");
                BigDecimal rentalamount = result.getBigDecimal("rental_amount");
                BigDecimal _discount = result.getBigDecimal("discount");
                String _status = result.getString("status");
                String inspectiondetails = result.getString("inspection_details");
                BigDecimal assessedvalue = result.getBigDecimal("assessed_value");
                int accepthoid = result.getInt("accept_hoid");
                String acceptposition = result.getString("accept_position");
                Date acceptelectiondate = result.getDate("accept_electiondate");
                Date returndate = result.getDate("return_date");
                
                asset_idList.add(assetID);
                rental_dateList.add(_rentaldate);
                asset_nameDescList.add("" + assetID + ": " + result.getString("asset_name") + " | " + result.getString("asset_description"));
                /*reservation_dateList.add(reservationdate);
                resident_idLIstList.add(residentID);
                rental_amountList.add(rentalamount);
                discountList.add(_discount);
                statusList.add(_status);
                inspection_detailsList.add(inspectiondetails);
                assessed_valueList.add(assessedvalue);
                accept_hoidList.add(accepthoid);
                accept_positionList.add(acceptposition);
                accept_electiondateList.add(acceptelectiondate);
                return_dateList.add(returndate);*/
            }
            
            // Step 2: Get all child asset ids in list to be available for rent.
            query = "SELECT a.asset_name, a.asset_description, ar.asset_id, ar.rental_date, ar.reservation_date, "
                    + "ar.resident_id, ar.rental_amount, ar.discount, ar.status, "
                    + "ar.inspection_details, ar.assessed_value, ar.accept_hoid, "
                    + "ar.accept_position, ar.accept_electiondate, ar.return_date "
                    + "FROM asset_rentals ar JOIN assets a ON ar.asset_id = a.asset_id "
                    + "WHERE a.hoa_name = ? AND ar.status = ? AND a.enclosing_asset = ?";
            statement = conn.prepareStatement(query);
            statement.setString(1, hoa_name);
            statement.setString(2, "O"); // O for On Rent
            statement.setInt(3, assetid);
            result = statement.executeQuery();
            
            while (result.next()) {
                int assetID = result.getInt("asset_id");
                Date _rentaldate = result.getDate("rental_date");
                Date reservationdate = result.getDate("reservation_date");
                int residentID = result.getInt("resident_id");
                BigDecimal rentalamount = result.getBigDecimal("rental_amount");
                BigDecimal _discount = result.getBigDecimal("discount");
                String _status = result.getString("status");
                String inspectiondetails = result.getString("inspection_details");
                BigDecimal assessedvalue = result.getBigDecimal("assessed_value");
                int accepthoid = result.getInt("accept_hoid");
                String acceptposition = result.getString("accept_position");
                Date acceptelectiondate = result.getDate("accept_electiondate");
                Date returndate = result.getDate("return_date");
                
                asset_idList.add(assetID);
                rental_dateList.add(_rentaldate);
                asset_nameDescList.add("" + assetID + ": " + result.getString("asset_name") + " | " + result.getString("asset_description"));
                /*reservation_dateList.add(reservationdate);
                resident_idLIstList.add(residentID);
                rental_amountList.add(rentalamount);
                discountList.add(_discount);
                statusList.add(_status);
                inspection_detailsList.add(inspectiondetails);
                assessed_valueList.add(assessedvalue);
                accept_hoidList.add(accepthoid);
                accept_positionList.add(acceptposition);
                accept_electiondateList.add(acceptelectiondate);
                return_dateList.add(returndate);*/
            }
            
            conn.close();
            statement.close();
            
            // deduplicate
            Set<Integer> set = new LinkedHashSet<>(asset_idList);
            asset_idList.clear();
            asset_idList.addAll(set);
            
            // deduplicate
            Set<String> set2 = new LinkedHashSet<>(asset_nameDescList);
            asset_nameDescList.clear();
            asset_nameDescList.addAll(set2);
            
            System.out.println("Fetching rented assets successful");
            return 1;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Fetching rented assets connection unsuccessful");
            return 0;
        }
    }
    
    public int returnAsset() {
        try {
            // Step 0: Connect to DB.
            Connection conn;
            conn = DriverManager.getConnection(connURL);
            System.out.println("Returning assets connection successful");
            
            // Step 1: Set resident to not being a renter.
            //query = "UPDATE residents SET renter = 0 WHERE resident_id = ?";
            //statement = conn.prepareStatement(query);
            //statement.setInt(1, resident_id);
            //statement.executeUpdate();
            
            // Step 2: For all asset ids in the list, set all to be returned
            // and update the corresponding rental entry.
            // Only one "depth" of child assets are done. For more "depths",
            // look into recursive SQL statements or graph algorithms.
            for (int i = 0; i < asset_idList.size(); i++) {
                // Set asset to rented in assets table
                /*query = "UPDATE assets SET forrent = 1 WHERE asset_id = ? AND rental_date = ?";
                statement = conn.prepareStatement(query);
                statement.setInt(1, asset_idList.get(i));
                statement.setDate(2, rental_dateList.get(i));
                statement.executeUpdate();*/
                
                // Update rentals table
                query = "UPDATE asset_rentals "
                        + "SET status = ?, inspection_details = ?, assessed_value = ?, accept_hoid = ?, accept_position = ?, accept_electiondate = ?, return_date = ?  "
                        + "WHERE asset_id = ? AND rental_date = ?";
                statement = conn.prepareStatement(query);
                statement.setString(1, "N");
                statement.setString(2, inspection_detailsList.get(i));
                statement.setBigDecimal(3, assessed_valueList.get(i));
                statement.setInt(4, accept_hoid);
                statement.setString(5, accept_position);
                statement.setDate(6, accept_electiondate);
                statement.setDate(7, return_date);
                statement.setInt(8, asset_idList.get(i));
                statement.setDate(9, rental_date);
                statement.executeUpdate();
                statement.close();
            }
            
            
            conn.close();
            System.out.println("Asset return successful");
            return 1;
        } catch (Exception e) {
            System.out.println("Returning assets connection failed");
            e.printStackTrace();
            return 0;
        }
    }
    
    public int updateRental() {
        try {
            Connection conn;
            conn = DriverManager.getConnection(connURL);
            
            
            query = "UPDATE asset_rentals SET rental_date = ?, reservation_date = ?, resident_id = ?,"
                    + " rental_amount = ?, discount = ?, status = ?, inspection_details = ?, assessed_value = ?,"
                    + " return_date = ?"
                    + " WHERE asset_id = ? AND rental_date = ?";
            statement = conn.prepareStatement(query);
            statement.setDate(1, rental_date);
            statement.setDate(2, reservation_date);
            statement.setInt(3, resident_id);
            statement.setBigDecimal(4, rental_amount);
            statement.setBigDecimal(5, discount);
            statement.setString(6, status);
            
            if (inspection_details != null)
                statement.setString(7, inspection_details);
            else
                statement.setObject(7, null);
            
            if (assessed_value != null)
                statement.setBigDecimal(8, assessed_value);
            else
                statement.setObject(8, null);
                        
            
            if (return_date != null)
                statement.setDate(9, return_date);
            else
                statement.setObject(9, null);

            statement.setInt(10, asset_id);
            statement.setDate(11, rental_date);
            statement.executeUpdate();
            statement.close();
            conn.close();
            return 1;
        } catch(Exception e) {
            System.out.println("Updating asset rental information connection failed");
            e.printStackTrace();
            return 0;
        }
    }
}
