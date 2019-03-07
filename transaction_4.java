import  java.sql.*;
import java.util.*;

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
        //del_mon_device(con);
        //dynamic_pricing(con);
        } catch (SQLException e) {
            e.printStackTrace();
            con.rollback();
            con.close();
        }
    }
    //**********************************************************************
    //первая транзакция
    public static void del_mon_device(Connection con)throws SQLException {
        String model="AE456", e_mail="",nameD = "";
        try {
        con.setAutoCommit(false);
        Statement st = con.createStatement();
        ResultSet res=st.executeQuery("select nameD from enviromental_monitoring_device where modelcode='"+model+"'");
        while(res.next()) {
            nameD = res.getString(1);
        }
        res=st.executeQuery("select e_mail from Factory where nameD='"+nameD+"'");
        while(res.next()) {
            e_mail = res.getString(1);
        }
        st.executeUpdate("delete from Tester where e_mail='"+e_mail+"'");
        st.executeUpdate("delete from Factory where nameD='"+nameD+"'");
        st.executeUpdate("delete from Users where modelcode='"+nameD+"'");
        st.executeUpdate("delete from enviromental_monitoring_device where modelcode='"+model+"'");
        con.commit();
        } catch (SQLException e) {
            e.printStackTrace();
            con.rollback();
            con.close();
        }
    }
    //**********************************************************************
    //вторая транзакция
    public static void dynamic_pricing (Connection con)throws SQLException {
        String nameU="Nikita Fty", nameD="";
        int cost=0;
        try {
        con.setTransactionIsolation(2);
        con.setAutoCommit(false);
        Statement st = con.createStatement();
        Scanner s = new Scanner(System.in);
        System.out.println("Enter your budget");
        int money = s.nextInt();
        ResultSet res=st.executeQuery("select nameD, cost from enviromental_monitoring_device where cost<"+money+"");
        if(res.next()) {
            nameD = res.getString(1);
            cost = res.getInt(2);
        }
        System.out.println(nameD+" "+cost);
        PreparedStatement sql=con.prepareStatement("insert into Users values('Nikita Fty',TO_DATE('11-07-1999','dd-mm-yy'),'student',?)");
        sql.setString(1, nameD);
        sql.executeUpdate();
        cost+=100;
        st.executeUpdate("update enviromental_monitoring_device set cost="+cost+" where nameD='"+nameD+"'");
        con.commit();
        } catch (SQLException e) {
            e.printStackTrace();
            con.rollback();
        }
    }

}
