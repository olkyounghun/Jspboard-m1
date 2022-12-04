<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2022-12-04
  Time: 오후 9:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="com.example.jspboard.board.BoardDAO" %>
<%@ page import="com.example.jspboard.file.FileDAO" %>
<%@ page import="com.oreilly.servlet.MultipartRequest"  %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.jspboard.board.Board" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>게시판 글 작성</title>
</head>
<script>

</script>
<body>
<%
    // 파일 관련 부분
    //application.getRealPath("./");
    String savePath = "C:\\\\Users\\\\Administrator\\\\Downloads\\\\BoardUploadFiles";
    int sizeLimit = 5 * 1024 * 1024; // 키로바이트 * 메가바이트 * 기가바이트

    // 파일 업로드
    MultipartRequest multi = new MultipartRequest(request,
            savePath,
            sizeLimit,
            "UTF-8",
            new DefaultFileRenamePolicy());

    Enumeration<?> files = multi.getFileNames();

    String categoryType = "";
    if(multi.getParameter("categoryType") != null){
        categoryType = multi.getParameter("categoryType");
    }
    String boardTitle = "";
    if(multi.getParameter("boardTitle") != null){
        boardTitle = multi.getParameter("boardTitle");
    }
    String boardContent = "";
    if(multi.getParameter("boardContent") != null){
        boardContent = multi.getParameter("boardContent");
    }
    String boardUser = "";
    if(multi.getParameter("boardUser") != null){
        boardUser = multi.getParameter("boardUser");
    }
    String boardPw = "";
    if(multi.getParameter("boardPw") != null){
        boardPw = multi.getParameter("boardPw");
    }

    java.io.File boardFile; // 파일 선언

    String element; // ?
    String fileName; // 저장하게될 파일 이름
    String fileRName; // 업로더가 올렸던 파일의 원래 이름
    long fileSize; // 파일크기로 파일유무를 확인하고 여러파일의 경우 해당크기만큼 읽어오기때문에 필요
    String fileType; // 파일의 타입
    String filePath; // 파일 저장되는 경로
    String homedir;  // 파일 홈 위치

    BoardDAO boardDao = new BoardDAO();
    FileDAO fileDao = new FileDAO();

    // 글 작성
    int result = boardDao.write(categoryType,boardTitle,boardContent,boardUser,boardPw);

    // 신규로 작성된 글의 board_id를 가져오기
    int Bid = boardDao.getBoard_id();

    // 작성된 글의 파일첨부 여부
    boardFile = multi.getFile("boardFile");

    // 첨부된 파일이 있을경우 - 폴더 생성 및 경로 파악
    if(boardFile != null){

        // getName() : 첨부파일의 이름을 문자열로 반환하는 메서드.
        fileRName = boardFile.getName();

        // 날짜 객체 생성 : 첨부파일을 날짜별로 저장하기 위하여.
        Calendar cal = Calendar.getInstance();
        int year = cal.get(Calendar.YEAR);
        int month = cal.get(Calendar.MONTH) + 1;
        String mmonth;
        if(month < 10){
            String zero = "0";
            mmonth = zero + month;
        }else{
            mmonth = Integer.toString(month);
        }
        int day = cal.get(Calendar.DAY_OF_MONTH);

        // "..../boardUploadFiles/2021-05-21" 형태로 폴더를 만든다.
        if(day < 10){
            homedir = savePath+"/"+year+"-"+mmonth+"-"+"0"+day;
        }else{
            homedir = savePath+"/"+year+"-"+mmonth+"-"+day;
        }
        System.out.println(homedir);

        // 날짜 폴더를 만들어 보자.
        java.io.File path1 = new java.io.File(homedir);
        if(!path1.exists()) {	// 해당 폴더가 존재하지 않는 경우
            path1.mkdir();	// make directory : 실제 폴더를 만드는 메서드
        }

        // 파일 폴더를 만들어 보자. ==> 예) 작성자_파일명
        // "..../boardUploadFiles/2021-05-21/홍길동_파일명"
        fileName = Bid+"_"+boardUser+"_"+fileRName;

        boardFile.renameTo(new java.io.File(homedir+"/"+fileName)); // 파일 생성

        filePath = "/"+year+"-"+month+"-"+day+"/"+fileName;


        element = (String)files.nextElement(); // file을 반환
        fileType = multi.getContentType(element);	// 업로드된 파일의 타입을 반환
        //multi.getFile(element).length(); // 파일의 크기를 반환 (long타입)
        fileSize = fileRName.length();
        // 해당 게시글의 파일로 작성되어 저장한다.
        int fileChk = fileDao.upload(Bid, fileSize, fileName, fileRName, filePath, fileType);

        PrintWriter script = response.getWriter();
        script.println("<script>");
        // 글 최종 작성 ( 성공 / 실패 )
        if (fileChk == -1 ) {
            //실패띄워줌
            script.println("alert('파일업로드에 실패했습니다')");
            script.println("history.back()");
            result = -2;
        } else {
            //그렇지않으면 성공적으로 글을 작성한 부분이기때문에 게시판 메인화면으로 보낸다.
            script.println("location.href='index.jsp'");
        }
        script.println("</script>");
    }

    PrintWriter script = response.getWriter();
    script.println("<script>");
    // 글 최종 작성 ( 성공 / 실패 )
    if (result == -1 ) {
        //실패띄워줌
        script.println("alert('글쓰기에 실패했습니다')");
        script.println("history.back()");
    }else if(result == -2){  // 파일 업로드 실패
        script.println("history.back()");
    }else {
        //그렇지않으면 성공적으로 글을 작성한 부분이기때문에 게시판 메인화면으로 보낸다.
        script.println("location.href='index.jsp'");
    }
    script.println("</script>");
%>
</body>
</html>
