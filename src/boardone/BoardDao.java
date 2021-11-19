package boardone;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BoardDao {
	private static BoardDao instance = null;
	private BoardDao() {
		
	}
	
	public static BoardDao getInstance() {
		if (instance== null) {
			synchronized(BoardDao.class) {
				instance= new BoardDao();
			}
		}
		return instance;
	}
	
	public void closeResource(Connection conn, PreparedStatement pstmt) {
		try {
			if (conn!=null) conn.close();
			if (pstmt!=null) pstmt.close();
		}catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void closeResultSet (ResultSet rs) {
		try {
			if (rs!=null) rs.close();
		}catch(SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void insertArticle(BoardVo vo) {
		String sql="";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int num = vo.getNum();
		int ref = vo.getRef();
		int step= vo.getStep();
		int depth = vo.getDepth();
		int number= 0;
		try {
			conn = ConnectionPool.getConnection();
			sql="select max(num) from board";
			pstmt= conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				number= rs.getInt(1)+1;
			}else {
				number=1;
			}
			if (num!=0) { // 답글일경우
				pstmt.close();
				sql="update board set step=step+1 where ref=? and step > ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, ref);
				pstmt.setInt(2, step);
				pstmt.executeQuery();
				step++;
				depth++;
			}else { // 새글일경우
				ref= number;
				step=0;
				depth=0;
			}
			sql = "insert into board(num,writer,email,subject,pass,regdate,ref,step,depth,content,ip)"
					+ " values(board_seq.nextval,?,?,?,?,?,?,?,?,?,?)";
			pstmt.close();
			pstmt= conn.prepareStatement(sql);
			pstmt.setString(1, vo.getWriter());
			pstmt.setString(2, vo.getEmail());
			pstmt.setString(3, vo.getSubject());
			pstmt.setString(4, vo.getPass());
			pstmt.setTimestamp(5, vo.getRegdate());
			pstmt.setInt(6, ref);
			pstmt.setInt(7, step);
			pstmt.setInt(8, depth);
			pstmt.setString(9, vo.getContent());
			pstmt.setString(10, vo.getIp());
			pstmt.executeQuery();
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				if (rs!=null) rs.close();
				if (pstmt!=null) pstmt.close();
				if (conn!=null) conn.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	// 글의 개수를 가져오는 메서드
	public int getArticleCount() {
		String sql="select count(*) from board";
		int x = 0;
		try(Connection conn = ConnectionPool.getConnection();
				PreparedStatement pstmt= conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery();){
			if (rs.next()) {
				x = rs.getInt(1);
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return x;
	}
	
	// db의 table board 에서 데이터를 가져오는 메서드
//	public List<BoardVo> getArticles(){
		public List<BoardVo> getArticles(int start, int end){
//		String sql= "select * from board order by num desc";
		String sql = "select * from (select rownum rnum, num , writer, email, subject, pass, regdate, readcount,"
				+ "ref, step, depth, content, ip from ("
				+ "select * from board order by ref desc, step asc)) where rnum>=? and rnum<=?";
		List<BoardVo> articleList = new ArrayList<BoardVo>(10);
		ResultSet rs = null;
		try(Connection conn = ConnectionPool.getConnection();
				PreparedStatement pstmt= conn.prepareStatement(sql);
				){
			pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
//			while(rs.next()) {
			if (rs.next()) {
				do {
				BoardVo vo = new BoardVo();
				vo.setNum(rs.getInt("num"));
				vo.setWriter(rs.getString("writer"));
				vo.setEmail(rs.getString("email"));
				vo.setSubject(rs.getString("subject"));
				vo.setPass(rs.getString("pass"));
				vo.setRegdate(rs.getTimestamp("regdate"));
				vo.setReadcount(rs.getInt("readcount"));
				vo.setRef(rs.getInt("ref"));
				vo.setStep(rs.getInt("step"));
				vo.setDepth(rs.getInt("depth"));
				vo.setContent(rs.getString("content"));
				vo.setIp(rs.getString("ip"));
				articleList.add(vo);
				}while(rs.next());
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			closeResultSet(rs);
		}
		return articleList;
	}
	
	// 한개의 글 정보를 가져오는 메서드
	public BoardVo getArticle(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		BoardVo article= null;
		String sql="";
		try {
			conn= ConnectionPool.getConnection();
			sql= "update board set readcount=readcount+1 where num=?";
			pstmt= conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeQuery();
			pstmt.close();
			sql = "select * from board where num=?";
			pstmt= conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				article= new BoardVo();
				article.setNum(rs.getInt("num"));
				article.setWriter(rs.getString("writer"));
				article.setEmail(rs.getString("email"));
				article.setSubject(rs.getString("subject"));
				article.setPass(rs.getString("pass"));
				article.setRegdate(rs.getTimestamp("regdate"));
				article.setReadcount(rs.getInt("readcount"));
				article.setRef(rs.getInt("ref"));
				article.setStep(rs.getInt("step"));
				article.setDepth(rs.getInt("depth"));
				article.setContent(rs.getString("content"));
				article.setIp(rs.getString("ip"));
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			closeResultSet(rs);
			closeResource(conn,pstmt);
		}
		return article;
	}
	
	// 게시글 수정시 필요한 메서드 (조회수 +1 하지 않음)
	// 게시글 번호로 수정할 게시글 객체 리턴
	public BoardVo updateGetArticle(int num) {
		String sql = "select * from board where num=?";
		ResultSet rs = null;
		BoardVo article= null;
		try(Connection conn = ConnectionPool.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);){
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				article= new BoardVo();
				article.setNum(rs.getInt("num"));
				article.setWriter(rs.getString("writer"));
				article.setEmail(rs.getString("email"));
				article.setSubject(rs.getString("subject"));
				article.setPass(rs.getString("pass"));
				article.setRegdate(rs.getTimestamp("regdate"));
				article.setReadcount(rs.getInt("readcount"));
				article.setRef(rs.getInt("ref"));
				article.setStep(rs.getInt("step"));
				article.setDepth(rs.getInt("depth"));
				article.setContent(rs.getString("content"));
				article.setIp(rs.getString("ip"));
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			closeResultSet(rs);
		}
		return article;
	}
	
	// 게시글 수정 메서드
	public int updateArticle(BoardVo article) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String dbPassword="";
		String sql="";
		int result = -1; 
		try {
			conn = ConnectionPool.getConnection();
			sql = "select pass from board where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, article.getNum());
			rs = pstmt.executeQuery();
			if (rs.next()) {
				dbPassword= rs.getString(1);
				if (article.getPass().equals(dbPassword)) {
					sql = "update board set writer=?,email=?,subject=?,content=? where num=?";
					pstmt.close();
					pstmt= conn.prepareStatement(sql);
					pstmt.setString(1, article.getWriter());
					pstmt.setString(2, article.getEmail());
					pstmt.setString(3, article.getSubject());
					pstmt.setString(4, article.getContent());
					pstmt.setInt(5, article.getNum());
					pstmt.executeQuery();
					result= 1 ; // 수정 성공
				}else {
					result= 0; // 수정 실패
				}
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			closeResultSet(rs);
			closeResource(conn,pstmt);
		}
		return result;
	}
	
	
	// 게시글 삭제 메서드
	public int deleteArticle(int num, String pass) {
		String dbPassword="";
		String sql = "";
		Connection conn= null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		int result= -1; // num에 해당하는 password 없음
		try {
			conn = ConnectionPool.getConnection();
			sql = "select pass from board where num=?";
			pstmt= conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				dbPassword= rs.getString("pass");
				if (pass.equals(dbPassword)) {
					sql = "delete from board where num=?";
					pstmt.close();
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, num);
					pstmt.executeQuery();
					result =1; // password 일치
				}else {
					result = 0 ; // password 불일치
				}
			}
		}catch(SQLException e) {
			e.printStackTrace();
		}finally {
			closeResultSet(rs);
			closeResource(conn,pstmt);
		}
		
		return result;
	}
}
