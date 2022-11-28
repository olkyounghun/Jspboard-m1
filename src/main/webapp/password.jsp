<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.example.jspboard.board.BoardDAO" %>

<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
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

    String pwCk = new BoardDAO().password(boardId);
%>
<form method="post" accept-charset="utf-8" onsubmit="return password_check(this)" action="passwordForm.jsp">
    <input type="hidden" id="type" name="type" value="<%=type%>">
    <input type="hidden" id="boardId" name="boardId" value="<%=boardId%>">
    <div>
        비밀번호 확인
    </div>
    <div>
        <label>
            <input type="password" id="pw" name="pw">
        </label>
    </div>
    <button type="submit">확인</button>
</form>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
</body>
<script type="text/javascript">
    function password_check(){
        /** 부등호의 갯수에 따른 차이를 이해합시다. */
        if(document.getElementById("pw").value == <%=pwCk%>){
            return true;
        }else{
            alert("비밀번호가 맞지않습니다.");
            return false;
        }
    }
</script>
</html>
