import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
@WebServlet("/messages")
public class messages extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String receiverEmail = request.getParameter("msg_recipient");
        String subject = request.getParameter("msg_subject");
        String body = request.getParameter("msg_body");
	String email = request.getParameter("email"); // needs to be gotten from local memeory and passed in form


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
cstmt = conn.prepareCall("{CALL sendMessages(?, ?, ?, ?)}");

// Set IN parameters
cstmt.setString(1, email); 
cstmt.setString(2, receiverEmail);
cstmt.setString(3, body); 
cstmt.setString(4, subject);


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
