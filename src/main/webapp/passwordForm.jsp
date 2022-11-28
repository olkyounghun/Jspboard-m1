<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>

<html>
<head>
    <meta charset="UTF-8">
    <title> 비밀번호 확인 </title>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");

    String type = "";
    if(request.getParameter("type") != null){
        type = request.getParameter("type");
    }

    int boardId = 0;
    if(request.getParameter("boardId") != null){
        boardId = Integer.parseInt(request.getParameter("boardId"));
    }

    // 진입과정이 올바른지 확인하기위한 절차
    if(type.equals("")){
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('올바른 접속이 아닙니다.');");
        script.println("location.href='index.jsp'");
        script.println("</script>");
    }
    if(boardId == 0){
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('올바른 접속이 아닙니다.');");
        script.println("location.href='index.jsp'");
        script.println("</script>");
    }

    PrintWriter script = response.getWriter();

    script.println("<script>");
    // 타입을 확인하고 수정이나 삭제로 보내도록 함.
    if(type.equals("m")){
        // 수정화면으로 보냄
        script.println("location.href='modify.jsp?boardId="+boardId+"'");
    }else if(type.equals("d")){
        // 삭제 폼으로 보냄
        script.println("location.href='deleteForm.jsp?boardId="+boardId+"'");
    }else{
        script.println("alert('에러빵가루')");
    }
    script.println("</script>");

%>
</body>
</html>
