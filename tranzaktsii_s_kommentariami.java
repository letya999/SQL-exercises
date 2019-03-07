import  java.sql.*; //���������� ���� � SQL
import java.util.*; //���������� ����� ����������� ������� � �� �������

public class Main {
    static final String JDBC_DRIVER = "sun.jdbc.odbc.JdbcOdbcDriver"; 
    static final String DATABASE_URL = "jdbc:odbc:cloud";
    //� ���������� ODBC
    static final String USER = "letya999"; //����� ������������
    static final String PASSWORD = "1111"; //������ ������������

    public static void main(String[] args) throws ClassNotFoundException, SQLException { //������� ����� ������ ����
        Connection con = null; //������ ������ ���������, ��� ���������� � ��
        Class.forName(JDBC_DRIVER); //���������� � ����������� ����� ������� JDBC
        try {
        con = DriverManager.getConnection(DATABASE_URL, USER, PASSWORD); //����������� � ����������-����� ������
        //*****������ ����������**************
        //company_renaming(con); ��� ��������������� ��������, � �������� ��������� ��������� ���������� � ���������� 
        //*****������ ����������**************
        //change_of_number(con); //������ ����� �������� ������������
        //��� ������������� ����� �� ���������� ����� �� �����������������
        } catch (SQLException e) { // ���� ������� ����������
            e.printStackTrace(); //�������� ��� ��� ����
            con.rollback(); //���������� ���������
            con.close(); //����������� �� ���������
        }
    }
    //**********************************************************************
    //������ ���������� - �������������� ��������
    public static void company_renaming (Connection con) throws SQLException {
        int clients_number=13650; //����� �������
        String client=null, newclient="MIT"; //������ � ����� ������
        ArrayList <String> title=new <String> ArrayList(); //������������ ������ �������� ��������
        try {
        con.setAutoCommit(false); //��������� �������������� ���������� ����������
        Statement st = con.createStatement(); //���������� ��������, ��������� � �����������
        //�������� �� ������� �������� ������� � ������� 13650, ��������� ����������� ���������� � man
        ResultSet man=st.executeQuery("select client from Clients where clients_number="+clients_number+""); 
        if(man.next()) //���� � man ���� ������, ��
            client = man.getString(1); //���������� ����������� ������� � ������ client
        System.out.println(client+"\t"+clients_number); //������� �� ����� ����������� ������� � �����. ��� �����
        man=st.executeQuery("select title from OrderClient where client='"+client+"'"); //�������� �� ������� �������� ��������, �������� �������
        //�������� client
        while(man.next()) //���� ���������� ����������� �� ������ �����������
            title.add(man.getString(1)); //��� ���������� ����������� � ������ �������� ��������
        st.executeUpdate("delete from OrderClient where client='"+client+"'"); //������� �� ������� OrderClient ������ ��������� � client
        st.executeUpdate("update Authors set place_of_work='"+newclient+"' where place_of_work='"+client+"'"); //��������� � ������� ������� ����� ������ ��
     //������ ������� newclient
        st.executeUpdate("update Clients set client='"+newclient+"' where clients_number="+clients_number+""); //��������� � ������� �������� �������� �������, ����������
        //� ������� �������
        for(int i=0; i<title.size();i++) { //� ����� ��������� � ������� OrderClient ������ � ����� ������� � ��������� ��������� � ��� ��������
        st.executeUpdate("insert into OrderClient values ('"+newclient+"', '"+title.get(i)+"')");
        }
        man=st.executeQuery("select client from Clients where clients_number="+clients_number+""); //�������� �� ������� ��� ������� �� ������ �������
        if(man.next())
            client = man.getString(1);
        System.out.println(client+"\t"+clients_number); //� ������� �� ����� ����� ������� � ��������� � ��� �����, ����� ��������� ��� ������� ������ ����� �����
        con.commit(); //��������� ��������� � ���� ������
        } catch (SQLException e) { //���� ���������� ��� ������ � SQL
            e.printStackTrace(); //�������� ��� ��� ����
            con.rollback(); //���������� ��� ���������
        }
    }
    //**********************************************************************
   //������ ���������� - ����� ������ ��������
public static void change_of_number(Connection con) throws SQLException {
boolean ans=false; //�����
String name=null, number="33(711)655-11-99"; //�������� ������������ � ��� �����
int index=0; //������ ������������
try{
con.setTransactionIsolation(2); //�������� ������� �������� REPEATABLE READ
con.setAutoCommit(false); //��������� �������������� ����������
Statement st=con.createStatement();
//�������� �� ������� ��� ������������ � ��� ������, ��� ����� ������������ ����� number
ResultSet res=st.executeQuery("select name_publ, index2 from Journal,Publishing_house where Journal.title=Publishing_house.title and phone_number='"+number+"'");
if (res.next()) {
name = res.getString(1); //���������� �������� ������������ � ������ name
index=res.getInt(2); //������ � ���������� index
}
System.out.println(name+"\t  "+index+"\t  "+number); //������� �� ����� �������� ������������, ������ � ��������� � ��� �����
ans=true; //������ ����� �������
if(ans) {
number="00(45)512-11-03"; //������ ����� �� ��� ������� ��� ��������, � ������ ������ ��� �����
//������������ SQL ���������, � ������ ������ ����������� ����� ������������ �� ��������� ������������� ��� ������ ������ ����������� � ���������� �������
PreparedStatement st1=con.prepareStatement("update Publishing_house set phone_number=? where index2=?");
st1.setString(1, number); //�� ����� ������� ����� ������� ������ ����� �����
st1.setInt(2, index); //�� ����� ������� ����� ������� ������ ������������
int val=st1.executeUpdate(); //���������� ���������� ���������� �������
}
con.commit(); //��������� ���������
//������� �������� ������������ � ������ ��������� � ����� ������� ��������
res=st.executeQuery("select name_publ, index2 from Journal,Publishing_house where Journal.title=Publishing_house.title and phone_number='"+number+"'");
if (res.next()) {
name = res.getString(1);
index=res.getInt(2);
}
System.out.println(name+"\t  "+index+"\t  "+number); //�������� ��� ��������
}catch(SQLException e)
{
con.rollback();
con.close();
}
}
}