<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardone.BoardDao" %>
<%
// bean 에 데이터 넣기 전에 미리 인코딩설정 변경하기!!!!!!!!!!!!!!!
%>
<% request.setCharacterEncoding("UTF-8"); %>
    <jsp:useBean id="article" scope="page" class="boardone.BoardVo">
    	<jsp:setProperty name="article" property="*"/>
    </jsp:useBean>
    
<%
//request.setCharacterEncoding("UTF-8");
String pageNum = request.getParameter("pageNum");
BoardDao dao = BoardDao.getInstance();
int check= dao.updateArticle(article);
if (check==1){ // 수정성공 %>
<meta http-equiv="Refresh" content="0;url=list.jsp?pageNum=<%=pageNum%>">
<% 
}else{
%>
<script>
	alert("비밀번호가 맞지 않습니다");
	history.go(-1);
</script>
<%} %>
