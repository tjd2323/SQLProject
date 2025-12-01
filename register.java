import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
@WebServlet("/register")
public class register extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String full_name = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
	String password = request.getParameter("password");
	String confirmPassword = request.getParameter("confirm_password");
	String address = request.getParameter("address");
	String city = request.getParameter("city");
	String country = request.getParameter("country");
	String accountType = request.getParameter("account_type");
	String desc = ""
	if (accountType == "B")
	{
	desc = request.getParameter("buisness_description");	
}
	else if (accountType == "D")
{
	desc = request.getParameter("purpose");
}


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
cstmt = conn.prepareCall("{CALL Insert_Account(?, ?, ?, ?, ?, ?, ?, ?, ?)}");
// Set IN parameters
cstmt.setString(1, accountType); 
cstmt.setString(2, full_name);
cstmt.setString(3, email);
cstmt.setString(4, phone);
cstmt.setString(5, password);
cstmt.setString(6, address);
cstmt.setString(7, city);
cstmt.setString(8, country);
cstmt.setString(9, desc);
// Execute stored procedure
boolean hasResultSet = cstmt.execute();
//STEP 5: Extract data from result set
//STEP 6: Clean‐up environment
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

