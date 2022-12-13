<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="com.example.jspboard.board.Board" %>
<%@ page import="com.example.jspboard.board.BoardDAO" %>
<%@ page import="com.example.jspboard.file.FileDAO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.example.jspboard.comment.Comment" %>
<%@ page import="com.example.jspboard.comment.CommentDAO" %>
<%@ page import="java.sql.Timestamp" %>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <meta charset="UTF-8">
    <title> 게시판 글 보기</title>
</head>
<style>
    .wrapper {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
    }
</style>
<body>
<%

    PrintWriter script = response.getWriter();

    // boardId 확인절차
    int boardId = 0;
    if(request.getParameter("boardId") != null){
        boardId = Integer.parseInt(request.getParameter("boardId"));
    }

    // 넘어온 데이터가 없으면
    if(boardId == 0){

        script.println("<script>");
        script.println("alert('작성된 글이 확인되지않았습니다.');");
        script.println("location.href='index.jsp'");
        script.println("</script>");
    }

    // 데이터가 있다면
    Board board = new BoardDAO().getBoard(boardId);
    Comment cment = new CommentDAO().SearchComment(boardId);
    ArrayList<Comment> list = new CommentDAO().getList(boardId);

    String cmentUser = "";
    if(cment != null){
        cmentUser = cment.getCment_user();
    }
    Timestamp cmentRegdate = null;
    if(cment != null){
        cmentRegdate = cment.getCment_regdate();
    }
    String cmentContent = "";
    if(cment != null){
        cmentContent = cment.getCment_content();
    }

    // 파일도 같이
    String boardFile = new FileDAO().getRFile(boardId);

    SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String boardRegdate = simpleDateFormat.format(board.getBoard_regdate());
    String boardModdate = null;
    if(board.getBoard_moddate() != null) {
        boardModdate = simpleDateFormat.format(board.getBoard_moddate());
    }
    String savePath = "C:\\\\Users\\\\Administrator\\\\Downloads\\\\BoardUploadFiles";
    String boardPath;
    if(boardModdate == null) {
        boardPath = savePath + "\\\\" + boardRegdate;
    }else{
        boardPath = savePath + "\\\\" + boardModdate;
    }
    // 날짜형식(2022-06-21)으로 폴더에저장되기때문에 넣어줘야한다.
    // 폴더를 찾기위해 1차적으로 날짜 가져오기 / 파일을 찾기위해 2차적으로 해당글(boardId)의 파일 읽어오기

    String[] files = new File(boardPath).list(); // 폴더째로 다 읽어오는것
    // 무지성으로 담을 수 없음. 오류발생 가능성이 있다. 해당날짜에 같은 작성자가 파일을 올릴경우 해당글의 파일인지 확인 불가
    List<String> chkfiles = new ArrayList<>();
    String bID = Integer.toString(boardId);
    if(files != null) {
        for (String file : files) {
            int idx = URLEncoder.encode(file, "UTF-8").indexOf("_"); // 'boardId'_홍길동_file_real_name
            String chk = file.substring(0,idx);
            if(chk.equals(bID)){
                chkfiles.add(file);
            }
        }
    }


%>
    <div class="wrapper" id="wrapper" >
        <div class="row" >
            <div class="col-sm-3"> 제목 </div>
            <div class="col-sm-9">
                <input value="<%=board.getBoard_title()%>" style="float: right;width: 50%;" disabled>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-6">
                <div>
                    카테고리
                    <input value="<%=board.getCategory_type()%>" disabled>
                </div>
            </div>
            <div class="col-sm-6">
                <div class="row">
                    <div class="com-sm-6">
                        <div>작성자 </div>
                        <div>
                            <input value="<%=board.getBoard_user()%>" disabled>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div>
                            <%if(board.getBoard_moddate() == null){%> <%=boardRegdate%><%} else{%><%=boardModdate%><%}%>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-12"> 내용 </div>
        </div>
        <div class="row">
            <div class="com-sm-12">
                <textarea disabled>
                    <%=board.getBoard_content()%>
                </textarea>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-12"> 파일 </div>
        </div>
        <div class="row">
            <div class="col-sm-12">
                <% for(String bfile : chkfiles){ %>
                <a href="${pageContext.request.contextPath}/downloadForm.jsp?boardId=<%=boardId%>&fileName=<%=bfile%>">
                    <%=boardFile%>
                </a>
                <%}%>
            </div>
        </div>
        <div id="commentp">
            <table>
                <thead>
                    <tr>
                        <td>댓글아이디</td>
                        <td>작성날짜</td>
                        <td>내용</td>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for(int i = 0; i < list.size(); i++){
                    %>
                        <tr>
                            <td>
                                <label>
                                    <%=list.get(i).getCment_user()%>
                                </label>
                            </td>
                            <td>
                                <label>
                                    <%=list.get(i).getCment_regdate()%>
                                </label>
                            </td>
                            <td>
                                <label>
                                    <%=list.get(i).getCment_content()%>
                                </label>
                            </td>
                        </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <form method="post" onsubmit="commentform_chk(this)" action="commentForm.jsp?boardId=<%=board.getBoard_id()%>" >
                <div>
                    <div>
                        <label>
                            덧글아이디 : <input type="text" name="cmentUser">
                        </label>
                        <label>
                            비밀번호 : <input type="password" name="cmentPw">
                        </label>
                    </div>
                    <label>
                        내용 : <input type="text" name="cmentContent">
                    </label>
                    <div>
                        <button type="submit" class="btn btn-secondary">작성</button>
                    </div>
                </div>
            </form>
        </div>
        <div id="wrapper1" class="form-check">
            <button type="button" class="btn btn-secondary" onclick="location.href='password.jsp?boardId=<%=board.getBoard_id()%>&type=m'">수정</button>
            <button type="button" class="btn btn-secondary" onclick="location.href='password.jsp?boardId=<%=board.getBoard_id()%>&type=d'">삭제</button>
            <button type="button" class="btn btn-secondary" onclick="location.href='index.jsp'">목록</button>
        </div>
    </div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
</body>
<script type="text/javascript">

    const cmentUser = document.getElementById("cmentUser");
    const cmentPw = document.getElementById("cmentPw");
    const cmentContent = document.getElementById("cmentContent");

    // 아이디 정규식
    const userJ = /.{3,5}/;
    // 비밀번호 정규식
    const pwJ = /.{4,50}/;
    // 내용 정규식
    const contentJ = /.{4,200}/;

    function commentform_chk(){
        // NULL 체크
        if(cmentUser.value === ""){
            alert("아이디를 입력해주세요.");
            return false;
        }
        if(cmentPw.value === ""){
            alert("비밀번호를 입력해주세요.");
            return false;
        }
        if(cmentContent.value === ""){
            alert("댓글내용을 입력해주세요.");
            return false;
        }
        if(userJ.test(cmentUser.value) === false){
            alert("아이디는 4글자 이상 5글자 미만으로 입력해주세요.");
            return false;
        }
        if(pwJ.test(cmentPw.value) === false){
            alert("비밀번호는 4글자 이상 50글자 미만으로 입력해주세요.");
            return false;
        }
        if(contentJ.test(cmentContent.value) === false){
            alert("내용은 4글자 이상 200글자 미만으로 입력해주세요.");
            return false;
        }
        return true;
    }
</script>
</html>