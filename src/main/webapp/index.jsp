<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.jspboard.board.Board" %>
<%@ page import="com.example.jspboard.board.BoardDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <meta charset="UTF-8">
    <title>JSP 게시판 - 목록</title>
</head>
<body>
<%

    BoardDAO boardDao = new BoardDAO();

    // 페이징 데이터
    String startDate = "";
    String endDate = "";
    String searchType = "All";
    String searchName = "";

    // SimpleDateFormat simformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    //String to = simformat.format(from);

    // 한 페이지 출력될 글 수 = 10 !
    int pageSize = 10;

    // 현재 보고 있는 페이지 정보 설정 !
    String pageNum = request.getParameter("pageNum");
    if (pageNum == null){
        pageNum = "1";
    }

    // 첫행 번호 계산
    int currentPage = Integer.parseInt(pageNum);
    int startRaw = (currentPage-1)*pageSize + 1;

    // 파라미터값 확인
    if(request.getParameter("startDate") != null){
        startDate = request.getParameter("startDate");
    }

    if(request.getParameter("endDate") != null){
        endDate = request.getParameter("endDate");
    }

    if(request.getParameter("searchType") != null){
        searchType = request.getParameter("searchType");
    }

    if(request.getParameter("searchName") != null){
        searchName = request.getParameter("searchName");
    }

    int cnt = boardDao.getBoardCount(startDate,endDate,searchType,searchName);

%>
    <form action="index.jsp">
        <div>
            <button type="button" onclick="location.href='index.jsp'" class="btn btn-dark">메인</button>
            <label for="startDate">
                <input type="date" id="startDate" name="startDate" <%if(startDate != null){%> value="<%=startDate%>" <%}else{%> value="" <%}%>>
            </label>
            ~
            <label>
                <input type="date" id="endDate" name="endDate" <%if(endDate != null){%> value="<%=endDate%>" <%}else{%> value="" <%}%>>
            </label>
            <label>
                <select id="searchType" name="searchType">
                    <option value="All" <%if(searchType.equals("All")){%>selected<%}%>>전체 카테고리</option>
                    <option value="JAVA" <%if(searchType.equals("JAVA")){%>selected<%}%>>JAVA</option>
                    <option value="Javascript" <%if(searchType.equals("Javascript")){%>selected<%}%>>Javascript</option>
                    <option value="Database" <%if(searchType.equals("Database")){%>selected<%}%>>Database</option>
                </select>
            </label>
            <label>
                <input type="text" name="searchName" placeholder="제목+내용+작성자" <%if(!(searchName.equals(""))){%> value="<%=searchName%>" <%}%>>
            </label>
            <button type="submit" class="btn btn-primary">검색</button>
        </div>
    </form>
    <div>
        <table class="table">
            <thead>
                <tr>
                    <td>글 번호</td>
                    <td>카테고리</td>
                    <td>제목</td>
                    <td>작성자</td>
                    <td>조회수</td>
                    <td>등록일자</td>
                    <td>수정일자</td>
                </tr>
            </thead>
            <tbody>
            <%
                SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");

                ArrayList<Board> list = boardDao.getList(startRaw, pageSize,startDate,endDate,searchType,searchName);
                for(int i = 0; i < list.size(); i++){
            %>
                <tr>
                    <td>
                        <%= list.get(i).getBoard_id()%>
                    </td>
                    <td>
                        <%= list.get(i).getCategory_type()%>
                    </td>
                    <td>
                        <a href="detail.jsp?boardId=<%= list.get(i).getBoard_id()%>"><%= list.get(i).getBoard_title()%></>
                    </td>
                    <td>
                        <%= list.get(i).getBoard_user()%>
                    </td>
                    <td>
                        <%= list.get(i).getBoard_views()%>
                    </td>
                    <td>
                        <% String regDate = simpleDateFormat.format( list.get(i).getBoard_regdate() ); %>
                        <%= regDate %>
                    </td>
                    <td>
                    <%  if(list.get(i).getBoard_moddate()==null){ %>
                            --
                    <%  }else{%>
                        <% String modDate = simpleDateFormat.format( list.get(i).getBoard_moddate() ); %>
                        <%= modDate %>
                    <%  }%>
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>

    </div>
    <div>
        <%
        if(cnt != 0){
            // 전체 페이지수 계산
            int pageCount = cnt / pageSize + (cnt%pageSize==0?0:1);

            // 한 페이지에 보여줄 페이지 블럭
            int pageBlock = 10;

            // 한 페이지에 보여줄 페이지 블럭 - 시작하는 번호 계산
            int startPage = ((currentPage-1)/pageBlock)*pageBlock+1;

            // 한 페이지에 보여줄 페이지 - 끝 번호 계싼
            int endPage = startPage + pageBlock-1;

            if(endPage > pageCount){
                endPage = pageCount;
            }
            // 페이징 시작 !
            if(startPage > pageBlock){
        %>
       <%/**&startDate=startDate&endDate=endDate&searchType=searchType&searchName=searchName*/%>
        <a href="index.jsp?pageNum=<%=startPage - pageBlock %>&startDate=<%=startDate%>&endDate=<%=endDate%>&searchType=<%=searchType%>&searchName=<%=searchName%>"
           class="btn btn-success btn-arraw-left">이전</a>
        <% } %>
        <% for(int i = startPage; i <= endPage; i++){ %>
        <a href="index.jsp?pageNum=<%=i %>&startDate=<%=startDate%>&endDate=<%=endDate%>&searchType=<%=searchType%>&searchName=<%=searchName%>"
            class="btn btn-<%if(i != currentPage){%>outline-<%}%>secondary <%if(i == currentPage){%>disabled<%}%>" ><%= i %></a>
        <% } %>
        <% if(endPage < pageCount){ %>
        <a href="index.jsp?pageNum=<%=startPage+pageBlock %>&startDate=<%=startDate%>&endDate=<%=endDate%>&searchType=<%=searchType%>&searchName=<%=searchName%>"
           class="btn btn-success btn-arraw-left">다음</a>
        <% } %>
        <% } %>

        <button class="btn btn-primary" onclick="location.href='write.jsp'">글쓰기</button>
    </div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
</body>
</html>