<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Board</title>
<script type="text/javascript" src="script.js"></script>
</head>
<!--  새글, 답변글 구분하는 코드 -->
<!--  답글인 경우 파라미터로 값이 넘어오고 , 그냥 새글을 쓸 때는 넘어오지 않는다 -->
<%
	int num = 0;
	int ref = 1; // 부모의 글번호
	int step= 0; // 몇번째 답글인지?
	int depth= 0; // 답글의 답글 등 답글의 깊이를 구분하는 용도
	
	try{
		if (request.getParameter("num")!=null){ // 답글인 경우
			num= Integer.parseInt(request.getParameter("num"));
			ref = Integer.parseInt(request.getParameter("ref"));
			step= Integer.parseInt(request.getParameter("step"));
			depth= Integer.parseInt(request.getParameter("depth"));
		}
	
%>
<body>
<section>
<b>글쓰기</b>
<article>
	<!-- onsubmit 은 submit을 눌렀을때 실행됨, onsubmit 결과가 false이면 제출되지 않음! -->
	<form method="post" name="writeForm" action="writeProc.jsp" onsubmit="return writeSave()">
		<table border="1">
			<tr>
				<td align="center"><b>이름</b></td>
				<td><input type="text" name="writer"></td>
			</tr>
			<tr>
				<td>이메일</td>
				<td><input type="email" name="email"></td>
			</tr>
			<tr>
				<td>제목</td>
				<td>
				<% if (request.getParameter("num")==null){ %> <!-- 새글인경우 -->
				<input type="text" name="subject">
				<%}else{ %>
				<input type="text" name="subject" value="[답변]">  <!--  답글인경우 -->
				<%} %>
				</td>
			</tr>
			<tr>
				<td>내용</td>
				<td><textarea name="content" rows="14" cols="50"></textarea></td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td><input type="password" name="pass"></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="submit" value="글쓰기">
					<input type="reset" value="다시작성">
					<input type="button" value="목록" onclick="window.location='list.jsp'">
					<!--<input type="button" value="목록" onclick="document.location.href='list.jsp'">  -->
				</td>
			</tr>
		</table>
		<input type="hidden" name="num" value="<%=num%>">
		<input type="hidden" name="ref" value="<%=ref%>">
		<input type="hidden" name="step" value="<%=step%>">
		<input type="hidden" name="depth" value="<%=depth%>">
	</form>
	</article>
	</section>
	<!-- 예외처리 코드 들어갈 부분 -->
	<%
	}catch(Exception e){
		e.printStackTrace();
	}
	%>
</body>
</html>