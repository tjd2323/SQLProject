import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
@WebServlet("/createAppointment")
public class createAppointment extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String serviceId = request.getParameter("book_service_id");
        String email = request.getParameter("email");
        String bookdate = request.getParameter("book_date");
	String booktime = request.getParameter("book_time");
	String booknote = request.getParameter("book_note");
	String dateTimecomb = bookdate + " " + booktime;
 	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd hh:mm a");
	LocalDateTime localDateTime = LocalDateTime.parse(dateTimecomb, formatter);
        // Convert LocalDateTime to java.sql.Timestamp
        Timestamp timestamp = Timestamp.valueOf(localDateTime);


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
CREATE PROCEDURE createBooking(IN email2 char(50), IN myservice_id int, IN mystartTime timestamp, in mynote varchar(3000))
cstmt = conn.prepareCall("{CALL get_employee_details(?, ?, ?, ?)}");

// Set IN parameters
cstmt.setString(1, email); // dept_id
cstmt.setInt(2, serviceId); // min_salary
cstmt.setTimestamp(3, timestamp); // dept_id
cstmt.setString(4, booknote); // min_salary
// Execute stored procedure
boolean hasResultSet = cstmt.execute();
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