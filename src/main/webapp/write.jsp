<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <meta charset="UTF-8">
    <title> 게시판 글 작성</title>
</head>
<%
    request.setCharacterEncoding("UTF-8");
%>
<style>
    #wrapper {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
    }
    #wrapper1 {
        position: absolute;
        top: 100%;
        left: 50%;
        transform: translate(-50%,-50%);
    }
</style>
<body>
    <form method="post" name="frm" onsubmit="return writeform_check(this)" action="writeForm.jsp" enctype="multipart/form-data"  >
        <div id="wrapper">
            <div>
                <div class="form-check" style= "text-align : center;">
                    <label>게시물 등록</label>
                </div>
                <div class="form-check">
                    <label>카테고리</label>
                    <label>
                        <select id="categoryType" name="categoryType" class="form-control">
                            <option value="All" selected>전체 카테고리</option>
                            <option value="JAVA" >JAVA</option>
                            <option value="Javascript" >Javascript</option>
                            <option value="Database" >Database</option>
                        </select>
                    </label>
                    <div id="type_ck"></div>
                </div>
                <div class="form-check">
                    <label> 작성자 </label>
                    <label>
                        <input type="text" id="boardUser" name="boardUser" class="form-control">
                    </label>
                </div>
                <div class="form-check" style="float: left;width: 50%;">
                    <label> 비밀번호 </label>
                    <label>
                        <input type="password" id="boardPw" name="boardPw" class="form-control">
                    </label>
                </div>
                <div class="form-check" style="float: right;width: 50%;">
                    <label> 비밀번호 확인 </label>
                    <label>
                        <input type="password" id="boardRepw" class="form-control">
                    </label>
                    <small class="form-text text-muted">We'll naver share your password with anyone else</small>
                </div>
                <div class="form-check">
                    <label> 제목 </label>
                    <label>
                        <input type="text" id="boardTitle" name="boardTitle" class="form-control">
                    </label>
                </div>
                <div class="form-check">
                    <label> 내용 </label>
                    <label>
                        <textarea id="boardContent" name="boardContent" class="form-control"></textarea>
                    </label>
                </div>
                <div class="form-check">
                    <label> 파일 </label>
                    <input type="file" id="boardFile" name="boardFile" class="form-control">
                </div>
                <div id="wrapper1" class="form-check">
                    <button type="submit" class="btn btn-secondary">저장</button>
                    <button type="button" class="btn btn-secondary" onclick="location.href='index.jsp'">목록</button>
                </div>
            </div>
        </div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
</body>
<script type="text/javascript">
    const categoryType = document.getElementById("categoryType");
    const boardUser = document.getElementById("boardUser");
    const boardPw = document.getElementById("boardPw");
    const boardRepw = document.getElementById("boardRepw")
    const boardTitle = document.getElementById("boardTitle");
    const boardContent = document.getElementById("boardContent");

    // 정규표현식 미리 작성
    //작성자 정규식
    const userJ = /.{3,5}/;
    // 비밀번호 정규식 (대소문자/숫자/특문포함)
    // const pwJ =  /^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{4,15}$/;
    // 제목 정규식
    const titleJ = /.{4,99}/;
    // 내용 정규식
    const contentJ = /.{4,1999}/;

    function writeform_check(){

        //NUll 체크
        if(categoryType.value === "All"){
            alert("카테고리를 선택해주세요.");
            return false;
        }
        if(boardUser.value === ""){
            alert("작성자를 입력해주세요.");
            return false;
        }
        if(boardPw.value === ""){
            alert("비밀번호를 입력해주세요.");
            return false;
        }
        if(boardRepw.value === ""){
            alert("비밀번호를 비밀번호확인란에 다시한번 입력해주세요.");
            return false;
        }
        if(boardPw.value !== boardRepw.value ){
            alert("비밀번호가 서로 맞지않습니다. 다시한번 확인해주세요.");
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
        if(userJ.test(boardUser.value) === false){
            alert("작성자는 3글자 이상 5글자 미만으로 입력해주세요.");
            return false;
        }

        /** 빠른 테스트를 위한 일시적 '해제'  */
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
