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
@WebServlet("/userDashboard")
public class userDashboard extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");



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

cstmt = conn.prepareCall("{CALL displayUserInfo(?)}");

// Set IN parameters
cstmt.setString(1, email); // dept_id
// Execute stored procedure
boolean hasResultSet = cstmt.execute();
//STEP 6: Clean‐up environment
if(hasResultSet)
{
ResultSet rs = cstmnt.getResultSet()
while(rs.next())
{
String full_name = rs.getString(1);
String phone = rs.getString(2);
String country = rs.getString(3);
String city = rs.getString(5);
try (PrintWriter out = response.getWriter())
{
out.println("<section class=\"card\">");
out.println("	<h2>My Profile</h2>");
out.println("	<div class=\"profile-grid\">");
out.println("		<div>");
out.println("			<strong>Name:</strong>");
out.println("			<span>"+full_name+"</span>");
out.println("		</div>");
out.println("		<div>");
out.println("			<strong>Email:</strong>");
out.println("			<span>"+email+"</span>");
out.println("		</div>");
out.println("		<div>");
out.println("			<strong>Phone:</strong>");
out.println("			<span>"+phone+"</span>");
out.println("		</div>");
out.println("		<div>");
out.println("			<strong>City:</strong>");
out.println("			<span>"+city+"</span>");
out.println("		</div>");
out.println("		<div>");
out.println("			<strong>Country:</strong>");
out.println("			<span>"+country+"</span>");
out.println("		</div>");
out.println("	</div>");
out.println("</section>");
}
    
}
}
cstmt = conn.prepareCall("{CALL displayServicesUser()}");
hasResultSet = cstmt.execute();
if(hasResultSet)
{
ResultSet rs = cstmnt.getResultSet()
while(rs.next())
{
String buisness_name = rs.getString(1);
String service_name = rs.getString(2);
double price = rs.getDouble(3);
int duration = rs.getInt(4);
String service_status = rs.getString(5);
int service_id = rs.getInt(6);
try (PrintWriter out = response.getWriter())
{
out.println("<tr data-service-id="+service_id+">");
out.println("	<td>"+buisness_name+"</td>");
out.println("	<td>"+service_name+"</td>");
out.println("	<td>"+price+"</td>");
out.println("	<td>"+duration+"</td>");
out.println("	<td>"+service_status+"</td>");
if(service_status == "active")
{
out.println("	<td>");
out.println("		<button type=\"button\" class=\"btn btn-small btn-book\">");
out.println("			Book");
out.println("		</button>");
out.println("	</td>");
}

}
}
}
cstmt = conn.prepareCall("{CALL displayAppointmentsUser(?)}");
cstmt.setString(1, email);
hasResultSet = cstmt.execute();
if(hasResultSet)
{
ResultSet rs = cstmnt.getResultSet()
while(rs.next())
{
Timestamp t1 = rs.getTimestamp(1);
String buisness = rs.getString(2);
String service = rs.getSring(3);
String stat = rs.getString(4);
int appt_id = rs.getInt(5);
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

// Parse the string into a LocalDateTime object
LocalDateTime dateTime = LocalDateTime.parse(t1, formatter);
// Extract date and time separately
String datePart = dateTime.toLocalDate().toString(); // yyyy-MM-dd
String timePart = dateTime.toLocalTime().toString(); // HH:mm:ss
try (PrintWriter out = response.getWriter())
{
out.println("<tr data-appt-id="+appt_id+">");
out.println("	<td>"+datePart+"</td>");
out.println("	<td>"+timePart+"</td>");
out.println("	<td>"+buisness+"</td>");
out.println("	<td>"+service+"</td>");
out.println("	<td>"+stat+"</td>");
if(stat == "scheduled")
{
out.println("	<td>");
out.println("		<button class=\"btn btn-small btn-outline btn-reschedule\">");
out.println("			Reschedule");
out.println("		<button class=\"btn btn-small btn-outline btn-cancel-appt\">");
out.println("			Cancel");
out.println("		</button>");
out.println("	</td>");
out.println("</tr>");
}
else
{
out.println("	<td>");
out.println("		<button class=\"btn btn-small btn-outline btn-completed\">");
out.println("			Completed");
out.println("		</button>");
out.println("	</td>");
out.println("</tr>");
}
}
}
}
cstmt = conn.prepareCall("{CALL displayMessages(?)}");
cstmt.setString(1, email);
hasResultSet = cstmt.execute();
if(hasResultSet)
{
ResultSet rs = cstmnt.getResultSet()
while(rs.next())
{
Timestamp t1 = rs.getTimestamp(1);
String sender = rs.getString(2);
String receiver = rs.getSring(3);
String subjectName = rs.getString(4);
String body = rs.getString(5);
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
// Parse the string into a LocalDateTime object
LocalDateTime dateTime = LocalDateTime.parse(t1, formatter);
// Extract date and time separately
String datePart = dateTime.toLocalDate().toString(); // yyyy-MM-dd
String timePart = dateTime.toLocalTime().toString(); // HH:mm:ss
try (PrintWriter out = response.getWriter())
{
out.println("<tr>");
out.println("	<td>"+datePart+"</td>");
out.println("	<td>"+sender+"</td>");
out.println("	<td>"+receiver+"</td>");
out.println("	<td>");
out.println("		<button type=\"button\"");
out.println("			class=\"link-button msg-subject\"");
out.println("			data-body="+body+">");
out.println("		"+subjectName");
out.println("		</button>");
out.println("	</td>");
out.println("</tr>");
}
}
}

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