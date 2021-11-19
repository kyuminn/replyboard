<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "boardone.*" %>
<%
	
	int num = Integer.parseInt(request.getParameter("num"));
	String pageNum = request.getParameter("pageNum");
	try{ 
		BoardDao dao = BoardDao.getInstance();
		BoardVo article = dao.updateGetArticle(num);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Board</title>
<script src="script.js"></script>
</head>
<body>
	<section>
		<b>글수정</b>
		<article>
			<form method="post" name="writeForm" action="updateProc.jsp?num=<%= num %>&pageNum=<%=pageNum%>" onsubmit="return writeSave()">
				<input type="hidden" name="writer" value="<%=article.getWriter()%>">
				<table border="1">
					<tr>
						<td>이름</td>
						<td><%=article.getWriter() %></td>
					</tr>
					<tr>
						<td>이메일</td>
						<td><input type="email" name="email" value="<%=article.getEmail()%>"></td>
					</tr>
					<tr>
						<td>제목</td>
						<td>
							<input type="text" name="subject" value="<%=article.getSubject() %>">
						</td>
					</tr>
					<tr>
						<td>내용</td>
						<td>
							<textarea rows="14" cols="50" name="content"><%=article.getContent() %></textarea>
						</td>
					</tr>
					<tr>
						<td>비밀번호</td>
						<td>
							<input type="password" name="pass">
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<input type="submit" value="글수정">
							<input type="reset" value="다시작성">
							<input type="button" value="목록" onclick="window.location='list.jsp'">
						</td>
					</tr>
				</table>
			</form>
		</article>
	</section>
<%
	}catch(Exception e){
		e.printStackTrace();
	}
%>
</body>
</html>