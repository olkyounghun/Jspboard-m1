<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.example.jspboard.board.BoardDAO" %>
<%@ page import="com.example.jspboard.file.FileDAO" %>

<html>
<head>
    <meta charset="UTF-8">
    <title> 게시글 삭제 진행</title>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");

    int boardId = 0;
    if(request.getParameter("boardId") != null){
        boardId = Integer.parseInt(request.getParameter("boardId"));
    }

    if(boardId == 0){
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('올바른 접속이 아닙니다.');");
        script.println("location.href='index.jsp'");
        script.println("</script>");
    }

    PrintWriter script = response.getWriter();

    /** 기업의 경우에는 삭제시에도 데이터상으로는 저장해놓고
     * 관리자의 입장에서 삭제시 데이터완전삭제가 되도록 하는 방식이 있음
     * 그럴경우에는 오류가 나서 글 삭제 이후 파일 삭제시 오류 발생으로
     * 삭제가 정상적으로 이루어지않더라도 복구가 가능하다. */

    int result = new BoardDAO().delete(boardId);

    script.println("<script>");
    // 글 최종 수정 ( 성공 / 실패 )
    if (result == -1) {
        // 실패띄워줌
        script.println("alert('삭제에 실패했습니다');");
        script.println("location.href='detail.jsp?boardId="+boardId+"'");
    } else {
        /** 오류발생하더라도 글이 삭제된 이후 파일이 삭제되도록 조치함 */
        int resultF = new FileDAO().delete(boardId);
        if(resultF == -1){
            script.println("alert('파일삭제에 실패했습니다. 관리자는 파일삭제오류에 관하여 확인하여주십시오.'"+boardId+"번);");
            script.println("location.href='index.jsp'");
        }

        // 성공시 해당글 디테일로 보내기
        script.println("alert('성공적으로 삭제되었습니다.');");
        script.println("location.href='index.jsp'");
    }
    script.println("</script>");


%>
</body>
</html>
