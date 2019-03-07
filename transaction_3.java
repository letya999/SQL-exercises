import  java.sql.*;
import  java.sql.Date;
import java.util.*;
import java.text.SimpleDateFormat;

public class Main {

    static final String JDBC_DRIVER = "sun.jdbc.odbc.JdbcOdbcDriver";
    static final String DATABASE_URL = "jdbc:odbc:cloud";
    static final String USER = "letya999";
    static final String PASSWORD = "1111";

    public static void main(String[] args) throws ClassNotFoundException, SQLException {
        Connection con = null;
        Class.forName(JDBC_DRIVER);
        try {
        con = DriverManager.getConnection(DATABASE_URL, USER, PASSWORD);
        //create_prj(con);
        //profile_change(con);
        } catch (SQLException e) {
            e.printStackTrace();
            con.rollback();
            con.close();
        }
    }
    //**********************************************************************
    //первая транзакция
    public static void create_prj (Connection con)throws SQLException {
        String autor="Ivanov Petr Ivanovich", lang="russian", topic="Ecology";
        Date deadline=null,commencement=null;
        int sym=2000, price=200;
        try {
        con.setAutoCommit(false);
        Statement st = con.createStatement();
        ResultSet man=st.executeQuery("select commencement, deadline from Project where name2='"+autor+"'");
        while(man.next()) {
            commencement = man.getDate(1);
            deadline = man.getDate(2);
   }
        st.executeUpdate("insert into blog values('"+lang+"',"+sym+" , '"+topic+"')");
        String SQL="insert into Project values('Environment',"+price+",TO_DATE('"+commencement+
                "','yyyy-mm-dd'), TO_DATE('"+deadline+"','yyyy-mm-dd'),"+sym+", '"+autor+"')";
        st.executeUpdate(SQL);
        con.commit();

        } catch (SQLException e) {
            e.printStackTrace();
            con.rollback();
        }
    }
    //**********************************************************************
    //вторая транзакция
    public static void profile_change (Connection con)throws SQLException {
        con.setTransactionIsolation(8);
        con.setAutoCommit(false);
        String name="", old_spec="medicine", spec="", new_spec="biology2", mag="AJE",mag2="";
        try {
            Statement st=con.createStatement();
            ResultSet res=st.executeQuery("select name2 from Editorial_staff where specilization='"+old_spec+"'");
            if(res.next())
                name=res.getString(1);
            System.out.println(name+"' specializes in  "+old_spec);
            res=st.executeQuery("select specilization from Science_magazine where name1='"+mag+"'");
            if(res.next())
                spec=res.getString(1);
            if(new_spec.equals(spec)) {
            st.executeUpdate("update Editorial_staff set specilization = '"+new_spec+"' where name2='"+name+"'");
            con.commit();
            }
            else con.rollback();
        } catch (SQLException e) {
            e.printStackTrace();
            con.rollback();
        }
    }
    
}
