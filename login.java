import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
@WebServlet("/login")
public class login extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
	String password = request.getParameter("password");
	String accountType = request.getParameter("account_type");


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
cstmt = conn.prepareCall("{CALL verify_Login(?, ?, ?, ?)}");
// Set IN parameters
cstmt.setString(1, email);
cstmt.setSting(2, password);
cstmt.setSting(3, accountType);

// Register OUT parameters
cstmt.registerOutParameter(4, Types.INTEGER); 

// Execute stored procedure
boolean hasResultSet = cstmt.execute();
//STEP 5: Extract data from result set
int success = cstmt.getInt(4);

if success == 0
{
// do nothing
}
else
{

 try (PrintWriter out = response.getWriter()) {
    out.println("<script>");
    out.println("	function saveAndGo() {");
    out.println("	const email = " + email + ";");
    out.println("	localStorage.setItem('email', email);");
    
    
    // need to redirect before finishing this


        
if accountType = "A"
{
    out.println("	window.location.href = 'admin_dashboard.html';");
        
}


else if accountType = "B"
{
 out.println("	window.location.href = 'business_dashboard.html';");

}

else if accountType = "C"
{
out.println("	window.location.href = 'user_dashboard.html';");

}
else
{
 out.println("	window.location.href = 'databroker_dashboard.html';");

}
    out.println("	}");
    out.println("</script>");
}

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