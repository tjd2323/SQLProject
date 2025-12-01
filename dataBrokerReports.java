import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
@WebServlet("/dataBrokerReports")
public class dataBrokerReports extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("filter_buisness");
	String city = request.getParameter("filter_city");
	String country = request.getParameter("filter_country");
	String startDate = request.getParameter("filter_start_date");
	String endDate = request.getParameter("filter_end_date");
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-mm-dd");
	Date parsedStartDate = dateFormat.parse(startDate);
	Date parsedEndDate = dateFormat.parse(endDate);
	Timestamp startTimestamp = new Timestamp(parsedStartDate.getTime());
	Timestamp endTimestamp = new Timestamp(parsedEndDate.getTime());
// Convert Date to Timestamp


// JDBC driver name and database URL
final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
final String DB_URL = "jdbc:mysql://localhost:3306/mySQL2025";
// Database credentials
static final String USER = "root";
static final String PASS = "root";
Connection conn = null;
try{
//STEP 2: Register JDBC driver
Class.forName("com.mysql.jdbc.Driver");
//STEP 3: Open a connection
System.out.println("Connecting to database...");
conn = DriverManager.getConnection(DB_URL,USER,PASS);
//STEP 4: Execute a query
System.out.println("Creating statement...");
cstmt = conn.prepareCall("{CALL get_Appointments(?, ?, ?, ?, ?, ?, ?, ?, ?)}");

// Set IN parameters
cstmt.setString(1, category); // dept_id
cstmt.setString(2, country); // min_salary
cstmt.setString(3, city); // dept_id
cstmt.setTimestamp(4, startTimestamp); // min_salary
cstmt.setTimestamp(5, endTimestamp); // dept_id
// Register OUT parameters
cstmt.registerOutParameter(6, Types.INTEGER); // total_count
cstmt.registerOutParameter(7, Types.INTEGER); // avg_salary
cstmt.registerOutParameter(8, Types.INTEGER); // avg_salary
cstmt.registerOutParameter(9, Types.INTEGER); // avg_salary
// Execute stored procedure
boolean hasResultSet = cstmt.execute();
//STEP 5: Extract data from result set
int numappt = cstmt.getInt(6);
int numCompleted = cstmt.getInt(7);
int numCanceled = cstmt.getInt(8);
int numNoShow = cstmt.getInt(9);
try (PrintWriter out = response.getWriter())
{
out.println("<tr>");
out.println("	<td>"+category+"</td>");
out.println("	<td>"+city+"</td>");
out.println("	<td>"+country+"</td>");
out.println("	<td>"+startDate+" to "+endDate+"</td>");
out.println("	<td>"+numappt+"</td>");
out.println("	<td>"+numCompleted+"</td>");
out.println("	<td>"+numCanceled+"</td>");
out.println("	<td>"+numNoShow+"</td>");
out.println("</tr>");
}



//STEP 6: Clean‐up environment
rs.close();
cstmt.close();
conn.close();
}catch(SQLException se){
//Handle errors for JDBC
se.printStackTrace();
}catch(Exception e){
//Handle errors for Class.forName
e.printStackTrace();
}finally{
//finally block used to close resources
try{
if(conn!=null)
conn.close();
}catch(SQLException se){
se.printStackTrace();
}//end finally try
}//end try
}
}