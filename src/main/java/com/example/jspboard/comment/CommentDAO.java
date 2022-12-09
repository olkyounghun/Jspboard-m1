package com.example.jspboard.comment;

import com.example.jspboard.board.BoardDAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import static com.example.jspboard.board.BoardDAO.tripleEx;

public class CommentDAO {

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

    /** 덧글 생성 */
    public int WriteComment(int boardId,
                            String cmentUser,
                            String cmentPw,
                            String cmentContent
                            ){
        String SQL = "INSERT " +
                       "INTO comment (board_id, Cment_User, Cment_Password, Cment_Content, Cment_Regdate, Cment_Moddate) " +
                     "VALUES         (       ?,          ?,              ?,             ?,       DEFAULT,          NULL)";

        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try {
            conn = getConnetion();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardId);
            pstmt.setString(2, cmentUser);
            pstmt.setString(3, cmentPw);
            pstmt.setString(4, cmentContent);
            return pstmt.executeUpdate();
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            tripleEx(conn,pstmt,rs);
        }
        return -1;
    }

    /** 댓글 찾아오기 */
    public Comment SearchComment(int boardId){
        String SQL = "SELECT * " +
                       "FROM comment " +
                      "WHERE board_id = ? ";
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try{
            conn =getConnetion();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1,boardId);
            rs = pstmt.executeQuery();
            if(rs.next()){
                Comment Cment = new Comment();
                Cment.setCment_id(rs.getInt("Cment_Id"));
                Cment.setCment_user(rs.getString("Cment_User"));
                Cment.setCment_password(rs.getString("Cment_Password"));
                Cment.setCment_content(rs.getString("Cment_Content"));
                Cment.setCment_regdate(rs.getTimestamp("Cment_Regdate"));
                Cment.setCment_moddate(rs.getTimestamp("Cment_Moddate"));
                Cment.setCment_id(rs.getInt("Cment_Id"));
                return Cment;
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            BoardDAO.tripleEx(conn,pstmt,rs);
        }
        return null;
    }

    /** 덧글 삭제 */
    public int DeleteComment(int CmentId) {
        String SQL = "DELETE " +
                     "FROM comment " +
                     "WHERE Cment_Id = ? ";
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try{
            conn = getConnetion();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1,CmentId);
            return pstmt.executeUpdate();
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            tripleEx(conn, pstmt, rs);
        }
        return -1;
    }


}
