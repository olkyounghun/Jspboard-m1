package com.example.jspboard.board;

import java.sql.*;
import java.util.ArrayList;


public class BoardDAO {

    /** 데이터베이스와 연결 */
    public static Connection getConnetion() {
        try{
            String dbURL = "jdbc:mysql://localhost:3306/week";
            String dbID = "root";
            String dbPassword = "root";
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(dbURL, dbID, dbPassword);
        }catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /** 수정할때 파일첨부시 필요로하는 작성자의 정보 찾기 */
    public String getBoardUser(int boardId){
        String SQL = "SELECT board_User" +
                    " FROM board" +
                    " WHERE board_id = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try{
            conn = getConnetion();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardId);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return rs.getString("board_User");
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            BoardDAO.tripleEx(conn, pstmt, rs);
        }
        return "";
    }

    /** 새 글 작성시 파일첨부할때 필요한 게시글번호를 가져오기 */
    public int getBoard_id(){
        String SQL = "SELECT board_id" +
                    " FROM board" +
                    " ORDER BY board_id DESC LIMIT 1";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try{
            conn = getConnetion();
            pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return rs.getInt("board_id");
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            BoardDAO.tripleEx(conn, pstmt, rs);
        }
        return -1;
    }

    /** 자주 사용되는 에러체크 */
    public static void tripleEx(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        if (rs != null) try {rs.close();} catch (SQLException ex) {}
        if (pstmt != null) try {pstmt.close();} catch (SQLException ex) {}
        if (conn != null) try {conn.close();} catch (SQLException ex) {}
    }

    /** 검색 조건 */
    public static String getSQL(String startDate,
                                String endDate,
                                String searchType,
                                String searchName){

        String back = " 00:00:00";
        String sresult = startDate + back;
        String eresult = endDate + back;

        if(sresult.equals(" 00:00:00")){
            sresult = startDate;
        }
        if(eresult.equals(" 00:00:00")){
            eresult = endDate;
        }

        Timestamp sDate = null;
        if(!(startDate.equals(""))){
            sDate = Timestamp.valueOf(sresult);
        }
        Timestamp eDate = null;
        if(!(endDate.equals(""))){
            eDate = Timestamp.valueOf(eresult);
        }

        String SQL;

        String search1 = " AND (board_title LIKE '%"+searchName+"%'" +
                          " OR board_content LIKE '%"+searchName+"%'" +
                          " OR board_user LIKE '%"+searchName+"%')";

        // 검색 내용이 없는 경우
        if(searchName.equals("")){

            // 검색 카테고리 설정이 있는 경우
            if(!(searchType.equals("All"))){
                String search2;

                // 날짜 설정이 있는 경우
                if(!(startDate.equals("")) && !(endDate.equals(""))){
                    search2 = " AND category_type = '" + searchType +
                             "' AND board_regdate >= '" + sDate +
                             "' AND board_regdate <= '" + eDate +
                             "' ORDER BY board_id DESC ";

                    // 날짜 설정이 없는 경우
                }else{
                    search2 = " AND category_type = '" + searchType +
                             "' ORDER BY board_id DESC ";
                }
                SQL = search2;


                // 검색 카테고리 설정이 없는 경우
            }else{
                // 날짜만 있을 경우
                String search;
                if(!(startDate.equals("")) && !(endDate.equals(""))) {
                    search = " AND board_regdate >= '" + sDate +
                            "' AND board_regdate <= '" + eDate +
                            "' ORDER BY board_id DESC ";
                    // 날짜가 없을 경우
                }else{
                    search = " ORDER BY board_id DESC ";
                }
                SQL = search;
            }

            // 검색 내용이 있는 경우
        }else{
            SQL = search1;

            // 검색 카테고리 설정이 있는 경우
            if(!(searchType.equals("All"))){
                // 날짜 설정이 있는 경우
                String search2;
                if(!(startDate.equals("")) && !(endDate.equals(""))){
                    search2 = " AND category_type = '" + searchType +
                             "' AND board_regdate >= '" + sDate +
                             "' AND board_regdate <='" + eDate +
                             "' ORDER BY board_id DESC ";
                    // 날짜 설정이 없는 경우
                }else{
                    search2 = " AND category_type = '" + searchType +
                             "' ORDER BY board_id DESC ";
                }
                SQL =SQL + search2;

                // 검색 카테고리 설정이 없는 경우
            }else{
                // 날짜만 있을 경우
                String search;
                if(!(startDate.equals("")) && !(endDate.equals(""))) {

                    search = " AND board_regdate >= '" + sDate +
                            "' AND board_regdate <= '" + eDate +
                            "' ORDER BY board_id DESC ";
                    // 날짜가 없을 경우우
                }else{
                    search = "ORDER BY board_id DESC ";
                }
                SQL = SQL + search;
            }

        }
        return SQL;
    }

    /** 작성된 게시물 수 */
    public int getBoardCount(String startDate,
                             String endDate,
                             String searchType,
                             String searchName){

        String SQL = "SELECT COUNT(*) AS cnt " +
                       "FROM BOARD " +
                      "WHERE 1 = 1 ";

        String getSQL = BoardDAO.getSQL(startDate,endDate,searchType,searchName);
        SQL = SQL + getSQL;

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try{
            conn = getConnetion();
            pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return rs.getInt("cnt");
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            tripleEx(conn, pstmt, rs);
        }
        return -1;
    }



    /** 게시글 목록 조회 , 페이징 */
    public ArrayList<Board> getList(int startRow,
                                    int pageSize,
                                    String startDate,
                                    String endDate,
                                    String searchType,
                                    String searchName){
        String SQL = "SELECT * " +
                       "FROM board " +
                      "WHERE 1 = 1 ";

        String limit = "LIMIT ?, ?";

        if(!(startDate.equals("")) || !(endDate.equals("")) || !(searchType.equals("All")) || !(searchName.equals(""))){
            String getSQL = BoardDAO.getSQL(startDate,endDate,searchType,searchName);
            SQL = SQL +getSQL + limit;
        }else{
            String getSQL = "ORDER BY board_id DESC LIMIT ?, ?";
            SQL = SQL + getSQL;
        }

        ArrayList<Board> list = new ArrayList<>();
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try{
            conn = getConnetion();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, startRow-1); /** startRow 가 마이너스일경우? 터무니없는 값이 들어왔을경우? */
            pstmt.setInt(2,pageSize);
            rs = pstmt.executeQuery();
            while(rs.next()){
                Board board = new Board();
                board.setBoard_id(rs.getInt("board_id"));
                board.setCategory_type(rs.getString("category_type"));
                board.setBoard_user(rs.getString("board_user"));
                board.setBoard_pw(rs.getString("board_pw"));
                board.setBoard_title(rs.getString("board_title"));
                board.setBoard_content(rs.getString("board_content"));
                board.setBoard_views(rs.getInt("board_views"));
                board.setBoard_regdate(rs.getTimestamp("board_regdate"));
                board.setBoard_moddate(rs.getTimestamp("board_moddate"));
                list.add(board);
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally {
            tripleEx(conn, pstmt, rs);
        }
        return list;
    }

    /** 게시글 작성 */
    public int write(String categoryType,
                     String boardTitle,
                     String boardContent,
                     String boardUser,
                     String boardPw
                     ){
        String SQL = "INSERT " +
                       "INTO board (category_type, board_title, board_content, board_user, board_pw, board_views, board_regdate, board_moddate) " +
                     "VALUES       (            ?,           ?,             ?,          ?,        ?,           0,       DEFAULT,          NULL)";

        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try {
            conn = getConnetion();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, categoryType);
            pstmt.setString(2, boardTitle);
            pstmt.setString(3, boardContent);
            pstmt.setString(4, boardUser);
            pstmt.setString(5, boardPw);
            return pstmt.executeUpdate();
        } catch (Exception e){
            e.printStackTrace();
        }finally {
            tripleEx(conn, pstmt, rs);
        }
        return -1; // 데이터베이스 오류
    }

    /** 게시글 보기 (detail) */
    public Board getBoard(int boardId){
        String SQL = "SELECT * " +
                       "FROM board " +
                      "WHERE board_id = ?";
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try{
            conn = getConnetion();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardId);
            rs = pstmt.executeQuery();
            if(rs.next()){
                Board board = new Board();
                board.setBoard_id(rs.getInt("board_id"));
                board.setCategory_type(rs.getString("category_type"));
                board.setBoard_user(rs.getString("board_user"));
                board.setBoard_pw(rs.getString("board_pw"));
                board.setBoard_title((rs.getString("board_title")));
                board.setBoard_content(rs.getString("board_content"));
                int viewCount = rs.getInt("board_views");
                viewCount++;
                upViews(viewCount,boardId);
                board.setBoard_views(viewCount);
                board.setBoard_regdate(rs.getTimestamp("board_regdate"));
                board.setBoard_moddate(rs.getTimestamp("board_moddate"));
                return board;
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            tripleEx(conn, pstmt, rs);
        }
        return null;
    }

    /** 게시글 조회수 증가 */
    public int upViews(int viewCount, int boardId){
        String SQL = "UPDATE board " +
                        "SET board_views = ? " +
                      "WHERE board_id = ?";
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try{
            conn = getConnetion();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, viewCount);
            pstmt.setInt(2, boardId);
            return pstmt.executeUpdate();
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            tripleEx(conn, pstmt, rs);
        }
        return -1;  // 데이터베이스 오류
    }

    /** 수정, 삭제를 위한 비밀번호 재확인 */
    public String password(int boardId){
        String SQL = "SELECT board_pw " +
                       "FROM board " +
                      "WHERE board_id = ?";
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try{
            conn = getConnetion();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1,boardId);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return rs.getString("board_pw");
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally {
            tripleEx(conn, pstmt, rs);
        }
        return "";
    }

    /** 게시글 수정하기 (비밀번호 재확인 이후) */
    public int modify(  String boardTitle,
                        String boardContent,
                        int boardId,
                        String boardPw){
        String SQL = "UPDATE board " +
                        "SET board_title = ?," +
                           " board_content = ?," +
                           " board_moddate = NOW() " +
                      "WHERE board_id = ? " +
                        "AND board_pw = ?";
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try{
            conn = getConnetion();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1,boardTitle);
            pstmt.setString(2,boardContent);
            pstmt.setInt(3,boardId);
            pstmt.setString(4,boardPw);
            return pstmt.executeUpdate();
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            tripleEx(conn, pstmt, rs);
        }
        return -1;
    }


    /** 게시글 삭제하기 (비밀번호 재확인 이후) */
    public int delete(int boardId){
        String SQL = "DELETE " +
                     "FROM board " +
                     "WHERE board_id = ? ";
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try{
            conn = getConnetion();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1,boardId);
            return pstmt.executeUpdate();
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            tripleEx(conn, pstmt, rs);
        }
        return -1;
    }
}