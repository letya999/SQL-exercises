import  java.sql.*; //подключаем пакт с SQL
import java.util.*; //подключаем пакет стандартных классов и их методов

public class Main { //название класса, который содержит мейн и транзакции
    static final String JDBC_DRIVER = "sun.jdbc.odbc.JdbcOdbcDriver"; //драйвер для соединения с базой данных
    static final String DATABASE_URL = "jdbc:odbc:cloud"; 
    static final String USER = "letya999"; //логин пользователя
    static final String PASSWORD = "1111"; //пароль пользователя

    public static void main(String[] args) throws ClassNotFoundException, SQLException { //главный метод класса мейн
        Connection con = null; //объект класса коннекшен, для соединения с БД
        Class.forName(JDBC_DRIVER); //запихиваем в стандартный класс драйвер JDBC
        try {
        con = DriverManager.getConnection(DATABASE_URL, USER, PASSWORD); //соединяемся с источником-базой данных
        //две функции ниже это транзакции
        //для использования одной из транзакций нужно ее раскомментировать
        //customer_change(con);
        //popularity(con); 
        } catch (SQLException e) { // если вылезло исключение
            e.printStackTrace(); //печатаем где оно было
            con.rollback(); //откатываем изменения
            con.close(); //отключаемся от источника
        }
    }
    /**********************Первая Транзакция**********************************
    *@see customer_change первая транзакция - смена ID клиента но новый изменение связанных с ним записей в других таблицах
    * @param con //в качестве параметра принимает соединение с базой данных
    */
    public static void customer_change(Connection con) throws SQLException {
        int old_ID=4000, new_ID=4444; //старый и новый ID клиента
        String adress=null, payment=null; //адрес и платежная система клиента
        try{
            con.setAutoCommit(false); //отключаем автоматическую транзакцию
            Statement st=con.createStatement(); //создаем оператор карты запроса для источника
            ResultSet res=st.executeQuery("select adress, payment from Client where clientID="+old_ID+"");
            //записываем в res множество результатов запроса к таблице клиентов с old_ID
            if (res.next()) { //если результат был получен
                adress = res.getString(1); //записываем адрес в строку address
                payment=res.getString(2); //плат. систему в переменную payment
                System.out.println(old_ID+"\t  "+adress+"\t  "+payment); //выводим на экран ID, адрес и систему клиента
                }
            //добавим в таблицу клиента с новым ID, но с теми же данными, что и у предыдущего
            st.executeUpdate("insert into Client values("+new_ID+",'"+adress+"','"+payment+"')");
            st.executeUpdate("update Manager set clientID="+new_ID+" where clientID="+old_ID+""); //изменим clientID в таблице менеджеров на новый
            st.executeUpdate("update Person set clientID="+new_ID+" where clientID="+old_ID+"");//изменим clientID в таблице персон на новый
            st.executeUpdate("delete from Client where clientID="+old_ID+""); //удалим запись со старым ID
            con.commit(); //зафиксируем обновления в базе данных
            res=st.executeQuery("select clientID, adress, payment from Client where clientID="+new_ID+"");
            if (res.next()) { //если результат был получен
                old_ID=res.getInt(1); //запишем clientID
                adress = res.getString(2); //записываем адрес в строку address
                payment=res.getString(3); //плат. систему в переменную payment
                System.out.println(old_ID+"\t  "+adress+"\t  "+payment); //выведем новые данные на экран
                }
                }catch(SQLException e) { //если возникнет исключение при работе с SQL
                    con.rollback(); //откратываем изменение в базе данных
                    con.close(); //отключаем соединение
        }
    }
	
/*************************Вторая транзакция************************************
 * @see popularity - функция, изменяющая цену смартфона в зависимости от числа запросов нему и числа товаров,
 * операции либо выполняются без ошибок как единое целое, либо не выполняются вовсе
 * @param con принимает в качестве параметра соединение с источником-базой данных
 */
    public static void popularity (Connection con) throws SQLException {
        List <Integer> tovar_cod=new ArrayList(); //список кодов товара
        List <Integer> price=new ArrayList(); //список ценников
        try {
        con.setAutoCommit(false); //отключаем автоматическое выполнение транзакции
        con.setTransactionIsolation(2); //включаем уровень изоляции REPEATABLE READ
        Statement st=con.createStatement(); //создаем оператор карты запроса для источника
        System.out.println("Enter the smartphone maker"); //просим ввести производителя смартфона
        Scanner s = new Scanner(System.in); //связываем ввод со стандартным средством ввода(клавиатурой)
        String maker = s.nextLine(); //вводим название производителя
        //помещаем в объект res множество результатов запроса кода товара и его стоимости для введенного нами производителя
        ResultSet res=st.executeQuery("select tovar_cod, price from Smartphone NATURAL JOIN Tovar where maker='"+maker+"'");
        int i=0, count=0; //переменные-счетчики, первая для цикла, вторая для подсчета числа товаров
        while(res.next()) { //пока движемся по списку результатов
            tovar_cod.add(res.getInt(1)); //добавляем код товара в список кодов товаров
            price.add(res.getInt(2)); //добавляем стоимость в список ценников
            System.out.println(maker+"\t"+tovar_cod.get(i)+"\t"+price.get(i)); // выводим на экран производителя, код смартфона и его стоимость
            count++; i++; //увеличиваем счетчики
        }
        if(count>2) { //если число товаров больше 2
            for(i=0; i<price.size(); i++) {
                price.set(i, price.get(i)+50*count); //тогда увеличиваем стоимость товара в зависимости от их численности
                //обновляем ценники для этого производителя
                st.executeUpdate("update Tovar set price="+price.get(i)+" where tovar_cod="+tovar_cod.get(i)+"");
            }
        }
        con.commit(); //фиксируем изменения в базе данных
        //ниже приводится код повторного вывода на экран после изменения стоимости
        res=st.executeQuery("select tovar_cod, price from Smartphone NATURAL JOIN Tovar where maker='"+maker+"'");
        i=0; tovar_cod.clear(); price.clear(); //обнулили счетчик и очистили списки
        while(res.next()) {
            tovar_cod.add(res.getInt(1));
            price.add(res.getInt(2));
            System.out.println("New price \n"+maker+"\t"+tovar_cod.get(i)+"\t"+price.get(i));
            i++;
        }
        } catch (SQLException e) { //если исключение при работе с SQL
            e.printStackTrace(); //печатаем где оно было
            con.rollback(); //откатываем все изменения
        }
    }
}