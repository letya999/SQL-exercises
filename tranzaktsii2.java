package javaapplication3;

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
        //leaving(con);
        value_increase(con);
        } catch (SQLException e) {
            e.printStackTrace();
            con.rollback();
            con.close();
        }
    }
    //**********************************************************************
    //первая транзакция
    public static void leaving (Connection con)throws SQLException {
        String name="Mihail", SensName="";
        int doc=0;
        try {
        con.setAutoCommit(false);
        Statement st = con.createStatement();
        ResultSet res=st.executeQuery("select Pass from Engineers where EngName='"+name+"'");
        if(res.next())
            doc = res.getInt(1);
        res=st.executeQuery("select SensName from Sensors where Pass="+doc+"");
        while(res.next()) {
            SensName = res.getString(1);
        }
        st.executeUpdate("delete from Stands where SensName='"+SensName+"'");
        st.executeUpdate("delete from Sensors where Pass="+doc+"");
        st.executeUpdate("delete from Engineers where Pass="+doc+"");
        con.commit();
        } catch (SQLException e) {
            e.printStackTrace();
            con.rollback();
            con.close();
        }
    }
    //**********************************************************************
    //вторая транзакция
    public static void value_increase (Connection con)throws SQLException {
        int Mprice=0;
        int cost=0, WarehID=0, count=0;
        try {
        con.setAutoCommit(false);
        con.setTransactionIsolation(2);
        Statement st = con.createStatement();
        ResultSet res=st.executeQuery("select WarehID from Warehouses where Costs="+cost+"");
        if(res.next()) {
            WarehID = res.getInt(1);
        }
        res=st.executeQuery("select Mprice from Materials where WarehID="+WarehID+"");
        while(res.next()) {
            count++;
        }
        if(count>=2) {
            cost=cost+5*count;
            st.executeUpdate("update Warehouses set Costs="+cost+" where WarehID='"+WarehID+"'");
            for(int i=0; i<count; i++) {
                Mprice+=30*count;
                st.executeUpdate("update Materials set Mprice="+Mprice+" where WarehID='"+WarehID+"'");
            }
            con.commit();
        } else con.rollback();
        } catch (SQLException e) {
            e.printStackTrace();
            con.rollback();
        }
    }
}
