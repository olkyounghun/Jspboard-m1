<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2022-12-04
  Time: 오후 9:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="com.example.jspboard.comment.CommentDAO" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>댓글 작성</title>
</head>
<body>
<%
    request.setCharacterEncoding("utf-8");

    int boardId = 0;
    if(request.getParameter("boardId") != null){
        boardId = Integer.parseInt(request.getParameter("boardId"));
    }
    String cmentUser = "";
    if(request.getParameter("cmentUser") != null){
        cmentUser = request.getParameter("cmentUser");
    }
    String cmentPw = "";
    if(request.getParameter("cmentPw") != null){
        cmentPw = request.getParameter("cmentPw");
    }
    String cmentContent = "";
    if(request.getParameter("cmentContent") != null){
        cmentContent = request.getParameter("cmentContent");
    }

    if(boardId == 0){
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('올바른 접속이 아닙니다.');");
        script.println("location.href='index.jsp'");
        script.println("</script>");
    }

    CommentDAO commentDAO = new CommentDAO();
    int result = commentDAO.WriteComment(boardId,cmentUser,cmentPw,cmentContent);

    PrintWriter script = response.getWriter();
    if(result == -1){
        script.println("<script>");
        script.println("alert('댓글작성에 실패하였습니다.');");
        script.println("location.href='detail.jsp?boardId="+boardId+"'");
        script.println("</script>");
    }else {
        script.println("<script>");
        script.println("location.href='detail.jsp?boardId="+boardId+"'");
        script.println("</script>");
    }
%>
</body>
</html>
