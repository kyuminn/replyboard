<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="boardone.*, java.sql.Timestamp"%>
 <%
 request.setCharacterEncoding("UTF-8");
 %>
<jsp:useBean id="vo" class="boardone.BoardVo">
	<jsp:setProperty name="vo" property="*"/>
</jsp:useBean>
<%

vo.setRegdate(new Timestamp(System.currentTimeMillis()));
vo.setIp(request.getRemoteAddr());
BoardDao dao = BoardDao.getInstance();
dao.insertArticle(vo);
response.sendRedirect("list.jsp");

%>
