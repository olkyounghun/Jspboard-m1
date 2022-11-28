<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.example.jspboard.board.Board" %>
<%@ page import="com.example.jspboard.board.BoardDAO" %>
<%@ page import="com.example.jspboard.file.File" %>
<%@ page import="com.example.jspboard.file.FileDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>

<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <meta charset="UTF-8">
    <title> 게시판 글 수정</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
</head>

<%
    request.setCharacterEncoding("UTF-8");

    // 게시글 아이디 가져오기
    int boardId = 0;
    if(request.getParameter("boardId") != null){
        boardId = Integer.parseInt(request.getParameter("boardId"));
    }

    String boardUser = new BoardDAO().getBoardUser(boardId);


    // 게시글 아이디가 없는 상태에서 접속시 에러 출력 및 메인페이지로 이동
    if(boardId == 0){
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('올바른 접속이 아닙니다.');");
        script.println("location.href='index.jsp'");
        script.println("</script>");
    }

    // 게시글 정보 가져오기
    Board board = new BoardDAO().getBoard(boardId);
    //int Bid = new BoardDAO().getBoard_id();
    String Fid = new FileDAO().chkFile(boardId);

    String fileName = "";
    long fileSize = 0;
    String file = "";
    String bfile = null;

    if(Fid != null) {
        // 게시글에 담긴 파일 정보 가져오기
        bfile = new FileDAO().getRFile(boardId);
        File boardFile = new FileDAO().getFileList(boardId);

        fileName = boardFile.getFile_name();
        fileSize = boardFile.getFile_size();
    }

    // 출력되는 날짜 정보를 규격에 맞추어 보여주기
    SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String boardRegdate = simpleDateFormat.format(board.getBoard_regdate());

    // 가져온 파일이 존재한다면 해당파일을 다운받을 수 있게 연결해주기
    if(fileSize != 0){
        file = "<a href='/'" + request.getContextPath() + "/downloadForm?boardId=" + boardId + "&boardRegdate=" + boardRegdate + "&fileName=" +
                java.net.URLEncoder.encode(bfile,"UTF-8") + "'>" + fileName +"</a>" + "("+fileSize + "byte)";
    }
%>
<body>
    <form method="post" name="frm" onsubmit="return modifyform_check(this)" action="modifyForm.jsp" enctype="multipart/form-data">
        <input type="hidden" id="boardId" name="boardId" value="<%=boardId%>">
        <input type="hidden" id="boardUser" name="boardUser" value="<%=boardUser%>">
        <div>
            <table>
                <tr>
                    <td> 카테고리 </td>
                    <td>
                        <%=board.getCategory_type()%>
                    </td>
                </tr>
                <tr>
                    <td> 등록일자 </td>
                    <td> <%=board.getBoard_regdate()%> </td>
                </tr>
                <tr>
                    <td> 수정일자 </td>
                    <td>
                        <%  if(board.getBoard_moddate()==null){ %>
                        --
                        <%  }else{%>
                        <%=board.getBoard_moddate()%>
                        <%  }%>
                    </td>
                </tr>
                <tr>
                    <td> 작성자 </td>
                    <td> <%=board.getBoard_user()%> </td>
                </tr>
                <tr>
                    <td> 비밀번호 </td>
                    <td> <label><input type="password" id="boardPw" name="boardPw"></label></td>
                </tr>
                <tr>
                    <td> 제목 </td>
                    <td> <label><input type="text" id="boardTitle" name="boardTitle" value="<%=board.getBoard_title()%>"></label></td>
                </tr>
                <tr>
                    <td> 내용 </td>
                    <td> <label><input type="text" id="boardContent" name="boardContent" value="<%=board.getBoard_content()%>"></label></td>
                </tr>
                <tr>
                    <td> 파일 </td>
                    <td>
                        <% if(Fid != null){  %>
                            <div class="filelist">
                                <%=file%>
                            </div>
                            <input type="button" class="removeFile" value="삭제">
                        <%}else{ %>
                            <input type="file" id="boardFile" name="boardFile" class="form-control" >
                        <% } %>

                    </td>
                </tr>
            </table>
        </div>
        <div>
            <button type="submit" >수정</button>
            <button type="button" onclick="location.href='index.jsp'">목록</button>
        </div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
</body>
<script type="text/javascript">

    /** 현재 한개의 파일만 업로드 하도록 지정함 */
    // $(document).ready( function(){
    //     $('.addFile').click (function(){
    //         $('.filelist').append(
    //             '<input type="file" id="boardFile" name="boardFile" class="form-control" >\
    //             <button type="button" class="btnremove" value="없애기"></button><br>'
    //         );
    //         $('.btnremove').on('click',function (){
    //             $(this).prev().remove();
    //             $(this).next().remove();
    //             $(this).remove();
    //         });
    //     });
    // });

    /** 기존 게시물에 저장되어있는 파일을 변경하거나 없애기 위한 jQuery */
    $(document).ready( function(){
        $('.removeFile').click (function(){
            $('.filelist').empty();
            $('.filelist').append(
                '<input type="file" id="boardFile" name="boardFile" class="form-control" ><br>'
            );
        });
    });

    const boardPw = document.getElementById("boardPw");
    const boardTitle = document.getElementById("boardTitle");
    const boardContent = document.getElementById("boardContent");

    // 정규표현식 미리 작성
    // 비밀번호 정규식 (대소문자/숫자/특문포함)
    // const pwJ =  /^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{4,15}$/;
    // 제목 정규식
    const titleJ = /.{4,99}/;
    // 내용 정규식
    const contentJ = /.{4,1999}/;

    function modifyform_check(){

        //NUll 체크
        if(boardPw.value === "") {
            alert("비밀번호를 입력해주세요.");
            return false;
        }
        if(boardTitle.value === ""){
            alert("제목을 입력해주세요.");
            return false;
        }
        if(boardContent.value === ""){
            alert("내용을 입력해주세요.");
            return false;
        }

        // 정규표현식을 이용한 유효성검사
        // if(pwJ.test(boardPw.value) == false){
        //     alert("비밀번호는 대소문자, 특문포함 4글자 이상 16글자 미만으로 입력해주세요.");
        //     return false;
        // }
        if(titleJ.test(boardTitle.value) === false){
            alert("제목은 4글자 이상 100글자 미만으로 입력해주세요.");
            return false;
        }
        if(contentJ.test(boardContent.value) === false){
            alert("내용은 4글자 이상 2000글자 미만으로 입력해주세요.");
            return false;
        }

        return true;
    }
</script>
</html>
