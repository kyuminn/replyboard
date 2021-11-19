package boardone;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class ConnectionPool {
	
//	private static ConnectionPool instance= null;
	private static DataSource ds= null;
	
//	private ConnectionPool() {
	static {
		try {
			Context init = new InitialContext();
			ds = (DataSource) init.lookup("java:comp/env/jdbc/myOracle");
		}catch(NamingException e) {
			e.printStackTrace();
		}
	}
	
//	public static ConnectionPool getInstance() {
//		if (instance== null) {
//			instance= new ConnectionPool();
//		}
//		return instance;
//	}
	
	// Connection 객체를 얻어오는 과정을 datasource로부터 얻어오는 것으로 바꾼다 !
	// ds를 이용해 커넥션 객체를 얻어오면 사용 완료한 connection 객체는 close()될때 연결이 끊기는 것이 아니라 connection pool에 반환된다!
	public static Connection getConnection() throws SQLException {
		return ds.getConnection();
	}
}
