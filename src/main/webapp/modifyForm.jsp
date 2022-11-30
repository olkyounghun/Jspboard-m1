<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.jspboard.board.BoardDAO" %>
<%@ page import="com.example.jspboard.file.FileDAO" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.example.jspboard.board.Board" %>
<%@ page import="java.io.File" %>

<html>
<head>
    <meta charset="UTF-8">
    <title> 게시판 글 수정</title>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");

    // 파일 관련 부분
    //application.getRealPath("./");
    String savePath = "C:\\\\Users\\\\Administrator\\\\Downloads\\\\BoardUploadFiles";

    // 키로바이트 * 메가바이트 * 기가바이트
    int sizeLimit = 5 * 1024 * 1024;

    // 파일 업로드
    MultipartRequest multi = new MultipartRequest(request,
            savePath,
            sizeLimit,
            "UTF-8",
            new DefaultFileRenamePolicy());

    Enumeration<?> files = multi.getFileNames();

    String boardTitle = "";
    if(multi.getParameter("boardTitle") !=null){
        boardTitle = multi.getParameter("boardTitle");
    }

    String boardContent = "";
    if(multi.getParameter("boardContent") != null){
        boardContent = multi.getParameter("boardContent");
    }

    int boardId = 0;
    if(multi.getParameter("boardId") != null){
        boardId = Integer.parseInt(multi.getParameter("boardId"));
    }

    String boardUser = "";
    if(multi.getParameter("boardUser") !=null){
        boardUser = multi.getParameter("boardUser");
    }

    if(boardId == 0){
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('올바른 접속이 아닙니다.');");
        script.println("location.href='index.jsp'");
        script.println("</script>");
    }

    String boardPw = "";
    if(boardPw.equals("")){
        boardPw = multi.getParameter("boardPw");
    }

    java.io.File boardFile; // 파일 선언

    String element; // ?
    String fileName = null; // 저장하게될 파일 이름
    String fileRName = null; // 업로더가 올렸던 파일의 원래 이름
    long fileSize = 0; // 파일크기로 파일유무를 확인하고 여러파일의 경우 해당크기만큼 읽어오기때문에 필요
    String fileType = null; // 파일의 타입
    String filePath = null; // 파일 저장되는 경로
    String homedir;  // 파일 홈 위치

    FileDAO fileDao = new FileDAO();

    boardFile = multi.getFile("boardFile");
    FileDAO fileDAO = new FileDAO();
    BoardDAO boardDAO = new BoardDAO();
    Board boardForm = boardDAO.getBoard(boardId);
    String[] regDate = String.valueOf(boardForm.getBoard_regdate()).split(" ");
    String saveFolderPath = savePath +"\\\\"+ regDate[0] +"\\\\"+ fileDAO.getFile(boardId);

    String chkmodify = fileDao.chkFile(boardId); // 없으면 null 잇으면 fileId

    PrintWriter script = response.getWriter();
    String ckpw = new BoardDAO().password(boardId);
    if(boardPw.equals(ckpw)){
        // 파일이 없었는데 첨부된 파일이 생성
        if(chkmodify == null && boardFile != null){
            /** 생성 */

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

            // 날짜 폴더를 만들어 보자.
            java.io.File path1 = new java.io.File(homedir);
            if(!path1.exists()) {	// 해당 폴더가 존재하지 않는 경우
                path1.mkdir();	// make directory : 실제 폴더를 만드는 메서드
            }

            // 파일 폴더를 만들어 보자. ==> 예) 작성자_파일명
            // "..../boardUploadFiles/2021-05-21/홍길동_파일명"
            fileName = boardId+"_"+boardUser+"_"+fileRName;

            boardFile.renameTo(new java.io.File(homedir+"/"+fileName)); // 파일 생성

            filePath = "/"+year+"-"+month+"-"+day+"/"+fileName;


            element = (String)files.nextElement(); // file을 반환
            fileType = multi.getContentType(element);	// 업로드된 파일의 타입을 반환
            //multi.getFile(element).length(); // 파일의 크기를 반환 (long타입)
            fileSize = fileRName.length();
            // 해당 게시글의 파일로 작성되어 저장한다.
            int fileChk = fileDao.upload(boardId, fileSize, fileName, fileRName, filePath, fileType);

            script.println("<script>");
            // 글 최종 작성 ( 성공 / 실패 )
            if (fileChk == -1 ) {
                //실패띄워줌
                script.println("alert('파일업로드에 실패했습니다')");
                script.println("location.href='modify.jsp?"+boardId+"'");
            } else {
                //그렇지않으면 성공적으로 글을 작성한 부분이기때문에 게시판 메인화면으로 보낸다.
                script.println("location.href='index.jsp'");
            }
            script.println("</script>");

        /** 삭제 */
        // 파일이 있었는데 첨부파일이 없음
        }else if(chkmodify != null && boardFile == null) {
            // 해당파일이 존재한다면 삭제
            File fileObj = new File(saveFolderPath);
            /** file.exists 와 isDirectory 로 했었는데 동작하지않아 isFile로 진행하니 성공적으로 작동*/
            if( fileObj.isFile() ) {
                fileObj.delete();
                fileDao.delete(boardId);
            }
        /** 수정 */
        // 파일이 있었는데 첨부파일이 있음
        }else if(chkmodify != null && boardFile != null){

            File fileObj = new File(saveFolderPath);
            if( fileObj.isFile() ) {
                fileObj.delete();
            }

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

            // 날짜 폴더를 만들어 보자.
            java.io.File path1 = new java.io.File(homedir);
            if(!path1.exists()) {	// 해당 폴더가 존재하지 않는 경우
                path1.mkdir();	// make directory : 실제 폴더를 만드는 메서드
            }

            // 파일 폴더를 만들어 보자. ==> 예) 작성자_파일명
            // "..../boardUploadFiles/2021-05-21/홍길동_파일명"
            fileName = boardId+"_"+boardUser+"_"+fileRName;

            boardFile.renameTo(new java.io.File(homedir+"/"+fileName)); // 파일 생성

            filePath = "/"+year+"-"+month+"-"+day+"/"+fileName;


            element = (String)files.nextElement(); // file을 반환
            fileType = multi.getContentType(element);	// 업로드된 파일의 타입을 반환
            //multi.getFile(element).length(); // 파일의 크기를 반환 (long타입)
            fileSize = fileRName.length();
            int fileChk = fileDao.Fmodify(boardId,fileSize,fileName,fileRName,filePath,fileType);
            script.println("<script>");
            // 글 최종 작성 ( 성공 / 실패 )
            if (fileChk == -1 ) {
                //실패띄워줌
                script.println("alert('파일업로드에 실패했습니다')");
                script.println("location.href='modify.jsp?"+boardId+"'");
            }
            script.println("</script>");
        }
        new BoardDAO().modify(boardTitle,boardContent,boardId,boardPw);
        script.println("<script>");
        script.println("alert('성공적으로 글수정이 되었습니다.');");
        script.println("location.href='detail.jsp?boardId="+boardId+"'");
        script.println("</script>");
    }else{
        script.println("<script>");
        script.println("alert('비밀번호가 맞지않습니다. 다시한번 확인해주세요.');");
        script.println("history.back();");
        script.println("</script>");
    }
%>
</body>
</html>
