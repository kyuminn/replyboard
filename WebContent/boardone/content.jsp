<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat,boardone.*" %>
<%
request.setCharacterEncoding("UTF-8");
int num = Integer.parseInt(request.getParameter("num"));
String pageNum= request.getParameter("pageNum");
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
try{
	BoardDao dao = BoardDao.getInstance();
	BoardVo article = dao.getArticle(num);
	int ref = article.getRef();
	int step = article.getStep();
	int depth = article.getDepth();
%>
<!--  helloㅎㅌㅅㅌㅌㅌ -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
<style type="text/css">
	table {
	width:500px;
	}
</style>
</head>
<body>
	<form>
		<table border="1">
			<tr>
				<th>글번호</th>
				<td><%=article.getNum() %></td>
				<th>조회수</th>
				<td><%=article.getReadcount() %></td>
			</tr>
			<tr>
				<th>작성자</th>
				<td><%= article.getWriter() %></td>
				<th>작성일</th>
				<td><%= article.getRegdate() %></td>
			</tr>
			<tr>
				<th>글제목</th>
				<td colspan="3"><%= article.getSubject() %></td>
			</tr>
			<tr>
				<th>글내용</th>
				<td colspan="3"><pre><%=article.getContent() %></pre></td>
			</tr>
			<tr>
				<td colspan="4">
					<input type="button" value="글수정" onclick="document.location.href=
					'updateForm.jsp?num=<%=article.getNum()%>&pageNum=<%=pageNum%>'">
					&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" value="글삭제" onclick="document.location.href=
					'deleteForm.jsp?num=<%=article.getNum()%>&pageNum=<%=pageNum%>'">
					&nbsp;&nbsp;&nbsp;&nbsp;
					<!--  수정 1 -->
					<!-- 답글달때는 parameter로 값 넘겨줌 -->
					<input type="button" value="답글" onclick="document.location.href='writeForm.jsp?num=<%=num%>&ref=<%=ref%>&step=<%=step%>&depth=<%=depth%>'">
					&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" value="글목록" onclick="document.location.href=
					'list.jsp?pageNum=<%=pageNum%>'">
				</td>
			</tr>
		</table>
		<%
		}catch(Exception e){
			
		}
		%>
	</form>
</body>
</html>