import  java.sql.*; //подключаем пакт с SQL
import java.util.*; //подключаем пакет стандартных классов и их методов

public class Main {
    static final String JDBC_DRIVER = "sun.jdbc.odbc.JdbcOdbcDriver"; 
    static final String DATABASE_URL = "jdbc:odbc:cloud";
    //в источниках ODBC
    static final String USER = "letya999"; //логин пользователя
    static final String PASSWORD = "1111"; //пароль пользователя

    public static void main(String[] args) throws ClassNotFoundException, SQLException { //главный метод класса мейн
        Connection con = null; //объект класса коннекшен, для соединения с БД
        Class.forName(JDBC_DRIVER); //запихиваем в стандартный класс драйвер JDBC
        try {
        con = DriverManager.getConnection(DATABASE_URL, USER, PASSWORD); //соединяемся с источником-базой данных
        //*****первая транзакция**************
        //company_renaming(con); она переименовывает компании, в качетсве параметра принимает соединение с источником 
        //*****вторая транзакция**************
        //change_of_number(con); //меняет номер телефона издательства
        //для использования одной из транзакций нужно ее раскомментировать
        } catch (SQLException e) { // если вылезло исключение
            e.printStackTrace(); //печатаем где оно было
            con.rollback(); //откатываем изменения
            con.close(); //отключаемся от источника
        }
    }
    //**********************************************************************
    //первая транзакция - переименование компании
    public static void company_renaming (Connection con) throws SQLException {
        int clients_number=13650; //номер клиента
        String client=null, newclient="MIT"; //клиент и новый клиент
        ArrayList <String> title=new <String> ArrayList(); //динамический массив названий журналов
        try {
        con.setAutoCommit(false); //отключаем автоматическое выполнение транзакции
        Statement st = con.createStatement(); //генерируем оператор, работающи с соединением
        //получаем из таблицы клиентов клиента с номером 13650, множество результатов помещается в man
        ResultSet man=st.executeQuery("select client from Clients where clients_number="+clients_number+""); 
        if(man.next()) //если в man есть записи, то
            client = man.getString(1); //записываем полученного клиента в строку client
        System.out.println(client+"\t"+clients_number); //выводим на экран полученного клиента и соотв. ему номер
        man=st.executeQuery("select title from OrderClient where client='"+client+"'"); //получаем из таблицы названия журналов, клиентом которых
        //является client
        while(man.next()) //пока происходит перемещение по списку результатов
            title.add(man.getString(1)); //эти результаты добавляются в массив названий журналов
        st.executeUpdate("delete from OrderClient where client='"+client+"'"); //удаляем из таблицы OrderClient запись связанную с client
        st.executeUpdate("update Authors set place_of_work='"+newclient+"' where place_of_work='"+client+"'"); //обновляем в таблицы авторов место работы на
     //нового клиента newclient
        st.executeUpdate("update Clients set client='"+newclient+"' where clients_number="+clients_number+""); //обновляем в таблице клиентов название клиента, связанного
        //с прежним номером
        for(int i=0; i<title.size();i++) { //в цикле добавляем в таблицу OrderClient записи о новом клиенте и названиях связанных с ним журналов
        st.executeUpdate("insert into OrderClient values ('"+newclient+"', '"+title.get(i)+"')");
        }
        man=st.executeQuery("select client from Clients where clients_number="+clients_number+""); //получаем из таблицы имя клиента со старым номером
        if(man.next())
            client = man.getString(1);
        System.out.println(client+"\t"+clients_number); //и выводим на экран этого клиента и связанный с ним номер, можно убедиться что клиента теперь зовут иначе
        con.commit(); //фиксируем изменения в базе данных
        } catch (SQLException e) { //если исключение при работе с SQL
            e.printStackTrace(); //печатаем где оно было
            con.rollback(); //откатываем все изменения
        }
    }
    //**********************************************************************
   //вторая транзакция - смена номера телефона
public static void change_of_number(Connection con) throws SQLException {
boolean ans=false; //ответ
String name=null, number="33(711)655-11-99"; //название издательства и его номер
int index=0; //индекс издательства
try{
con.setTransactionIsolation(2); //включаем уровень изоляции REPEATABLE READ
con.setAutoCommit(false); //отключаем автоматическую транзакцию
Statement st=con.createStatement();
//получаем из таблицы имя издательства и его индекс, где номер издательства равен number
ResultSet res=st.executeQuery("select name_publ, index2 from Journal,Publishing_house where Journal.title=Publishing_house.title and phone_number='"+number+"'");
if (res.next()) {
name = res.getString(1); //записываем название издательства в строку name
index=res.getInt(2); //индекс в переменную index
}
System.out.println(name+"\t  "+index+"\t  "+number); //выводим на экран название издательства, индекс и связанный с ним номер
ans=true; //делаем ответ правдой
if(ans) {
number="00(45)512-11-03"; //меняем номер на тот который нам нравится, в данном случае вот такой
//динамеческое SQL выражение, в данном случае обновляющее номер издательства на выбранный пользователем где индекс равень полученному в предыдущем запросе
PreparedStatement st1=con.prepareStatement("update Publishing_house set phone_number=? where index2=?");
st1.setString(1, number); //на место первого знака вопроса ставим новый номер
st1.setInt(2, index); //на место второго знака вопроса индекс издательства
int val=st1.executeUpdate(); //производим собственно обновление таблицы
}
con.commit(); //фиксируем изменения
//выводим название издательства и индекс связанные с новым номером телефона
res=st.executeQuery("select name_publ, index2 from Journal,Publishing_house where Journal.title=Publishing_house.title and phone_number='"+number+"'");
if (res.next()) {
name = res.getString(1);
index=res.getInt(2);
}
System.out.println(name+"\t  "+index+"\t  "+number); //печатаем эти значения
}catch(SQLException e)
{
con.rollback();
con.close();
}
}
}