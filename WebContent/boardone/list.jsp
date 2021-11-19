<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "boardone.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>

<%
	int pageSize = 5; // 한 페이지에 보여지는 글 수
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<%
	String pageNum = request.getParameter("pageNum");
	if(pageNum == null){
		pageNum = "1";
	}
	int currentPage = Integer.parseInt(pageNum);
	int startRow = (currentPage -1) * pageSize + 1;
	int endRow = currentPage * pageSize;
	int count = 0;
	int number = 0;
	List<BoardVo> articleList = new ArrayList<BoardVo>(10);
	BoardDao dbPro = BoardDao.getInstance();
	count = dbPro.getArticleCount();
	if(count > 0){
		articleList = dbPro.getArticles(startRow, endRow);
	}
	number = count - (currentPage -1) * pageSize;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style type="text/css">
	table{
		width:700px;
	}
	.listwritebutton {
	 text-align:right;
	}
	</style>
<title>게시판</title>
</head>
<body>
	<b>글목록(전체글 : <%= count %>)</b>
	<table class="listwritebutton">
		<tr>
			<td><a href="writeForm.jsp">글쓰기</a></td>
		</tr>
	</table>
	<%
		if(count == 0) {
	%>
		<table>
			<tr>
			<td>게시판에 저장된 글이 없습니다.</td>
			</tr>
		</table>
	
	<%} else { %>
	<table border="1">
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th>작성일</th>
			<th>조회</th>
			<th>IP</th>
		</tr>	
	<%
		for(int i = 0; i < articleList.size(); i ++){
			BoardVo article = (BoardVo) articleList.get(i);
	%>
	
		<tr>
			<td><%= number-- %></td>
			<td>
			<%
				int wid = 0;
				if(article.getDepth() > 0){
					wid = 5 * (article.getDepth());
			%>
				<img src="images/level.gif" width="<%=wid%>">
				<img src="images/re.gif">
			<%
				} else {
			%>
				<img src="images/level.gif" width="<%=wid %>">
			<%
				}
			%>
				<a href="content.jsp?num=<%= article.getNum()%>&pageNum=<%=currentPage%>">
					<%=article.getSubject() %>
				</a>
				<%
					if(article.getReadcount() >= 20){
				%>
				<img src="images/hot.gif"><%} %></td>
				<td>
					<a href="mailto:<%=article.getEmail() %>"><%=article.getWriter() %></a>
				</td>
				<td>
					<%=sdf.format(article.getRegdate()) %>
				</td>
				<td><%=article.getReadcount() %></td>
				<td><%=article.getIp() %></td>
		</tr>
	<%
		}
	%>
</table>
<%
	}
%>
	<%
	if (count >0){
		int pageBlock = 3;
		int imsi = count % pageSize == 0 ? 0:1;
		int pageCount = count/ pageSize + imsi;
		int startPage = (int)((currentPage-1)/pageBlock)* pageBlock +1;
		int endPage = startPage + pageBlock -1;
		if (endPage >pageCount) endPage = pageCount;
		if (startPage>pageBlock){ %>
		<a href="list.jsp?pageNum=<%=startPage - pageBlock%>">[이전]</a>
	<% 
		}
		for ( int i = startPage; i <=endPage; i++){ %>
		<a href="list.jsp?pageNum=<%=i %>">[<%=i %>]</a>
	<% }
		if (endPage<pageCount){
	%>
		<a href="list.jsp?pageNum=<%=startPage+pageBlock%>">[다음]</a>
	<%
		}
	}
	%>
</body>
</html>