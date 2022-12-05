<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2022-12-04
  Time: 오후 9:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"  %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.example.jspboard.comment.CommentDAO" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>댓글 작성</title>
</head>
<body>
<%
    // 파일 관련 부분
    String savePath = "C:\\\\Users\\\\Administrator\\\\Downloads\\\\BoardUploadFiles";
    int sizeLimit = 5 * 1024 * 1024; // 키로바이트 * 메가바이트 * 기가바이트

    MultipartRequest multi = new MultipartRequest(request,
            savePath,
            sizeLimit,
            "UTF-8",
            new DefaultFileRenamePolicy());

    int boardId = 0;
    if(multi.getParameter("boardId") != null){
        boardId = Integer.parseInt(multi.getParameter("boardId"));
    }
    String CmentUser = "";
    if(multi.getParameter("CmentUser") != null){
        CmentUser = multi.getParameter("CmentUser");
    }
    String CmentPw = "";
    if(multi.getParameter("CmentPw") != null){
        CmentPw = multi.getParameter("CmentPw");
    }
    String CmentContent ="";
    if(multi.getParameter("CmentPw") != null){
        CmentPw = multi.getParameter("CmentPw");
    }

    if(boardId == 0){
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('올바른 접속이 아닙니다.');");
        script.println("location.href='index.jsp'");
        script.println("</script>");
    }

    CommentDAO commentDAO = new CommentDAO();
    int result = commentDAO.WriteComment(boardId,CmentUser,CmentPw,CmentContent);

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
