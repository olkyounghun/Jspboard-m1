    package com.example.jspboard.file;

    import com.example.jspboard.board.BoardDAO;
    import java.sql.*;

public class FileDAO {

    /** 데이터베이스와 연결 */
    public Connection getConnection(){
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

    /** 게시글 파일 업로드 */
    public int upload(int boardId, long fileSize,
                      String fileName, String fileRName, String filePath, String fileType){
        String SQL = "INSERT " +
                       "INTO file (board_id, file_size, file_name, file_real_name, file_path, file_type) " +
                     "VALUES      (       ?,         ?,         ?,              ?,         ?,         ?)";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try{
            conn = getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1,boardId);
            pstmt.setLong(2,fileSize);
            pstmt.setString(3,fileName);
            pstmt.setString(4,fileRName);
            pstmt.setString(5,filePath);
            pstmt.setString(6,fileType);
            return pstmt.executeUpdate();
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            BoardDAO.tripleEx(conn, pstmt, null);
        }
        return -1;
    }

    /** 해당 boardId의 파일이 존재하는지 확인하기 */
    public String chkFile(int board_id){
        String SQL = "SELECT file_id " +
                     "FROM file " +
                     "WHERE board_id = ? " +
                     "UNION ALL " +
                     "SELECT NULL AS file_id " +
                     "FROM file " +
                     "WHERE " +
                     "NOT EXISTS (SELECT file_id " +
                                        "FROM file " +
                                        "WHERE board_id = ? ) " +
                     "limit 1";
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try{
            conn = getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, board_id);
            pstmt.setInt(2, board_id);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return rs.getString("file_id");
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            BoardDAO.tripleEx(conn, pstmt, rs);
        }
        return "";
    }

    /** 해당 게시글의 파일 가져오기 */
    public String getRFile(int boardId){
        String SQL = "SELECT file_real_name " +
                     "FROM file " +
                     "WHERE board_id = ?";
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try{
            conn = getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardId);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return rs.getString("file_real_name");
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            BoardDAO.tripleEx(conn, pstmt, rs);
        }
        return "";
    }
    /** 해당 게시글의 boardId가 포함된 파일 가져오기 */
    public String getFile(int boardId){
        String SQL = "SELECT file_name " +
                "FROM file " +
                "WHERE board_id = ?";
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try{
            conn = getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardId);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return rs.getString("file_name");
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            BoardDAO.tripleEx(conn, pstmt, rs);
        }
        return "";
    }

    /** 파일Paht에 저장되어있는 날짜를 가져오기위해  */
    /** 게시글등록날짜를 지난이후에 수정으로 파일등록시
     * 해당 파일을 다운로드할때 에러 발생 (파일다운시 등록날짜로 폴더를 만들어 저장하기때문) */
    public String getFilePath(int boardId){
        String SQL = "SELECT file_path " +
                "FROM file " +
                "WHERE board_id = ?";
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try{
            conn = getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardId);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return rs.getString("file_path");
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            BoardDAO.tripleEx(conn, pstmt, rs);
        }
        return "";
    }

    /** 파일의 정보 가져오기 */
    public File getFileList(int board_id){
        String SQL = "SELECT * " +
                     "FROM file " +
                     "WHERE board_id = ?";
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try{
            conn = getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, board_id);
            rs = pstmt.executeQuery();
            if(rs.next()){
                File file = new File();
                file.setFile_id(rs.getInt("file_id"));
                file.setFile_name(rs.getString("file_name"));
                file.setFile_real_name(rs.getString("file_real_name"));
                file.setFile_path(rs.getString("file_path"));
                file.setFile_size(rs.getLong("file_size"));
                file.setFile_type(rs.getString("file_type"));
                return file;
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            BoardDAO.tripleEx(conn, pstmt, rs);
        }
        return null;
    }

    /** 게시물 수정시 파일을 없애거나 수정시 */
    public int Fmodify(  int boardId, long fileSize,
                         String fileName, String fileRName, String filePath, String fileType){
        String SQL = "UPDATE file " +
                        "SET file_size = ?," +
                        " file_name = ?," +
                        " file_real_name = ?, " +
                        " file_path = ?, " +
                        " file_type = ? " +
                        "WHERE board_id = ? ";
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try{
            conn = getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setLong(1,fileSize);
            pstmt.setString(2,fileName);
            pstmt.setString(3,fileRName);
            pstmt.setString(4,filePath);
            pstmt.setString(5,fileType);
            pstmt.setInt(6,boardId);
            return pstmt.executeUpdate();
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            BoardDAO.tripleEx(conn, pstmt, rs);
        }
        return -1;
    }

    /** 게시글 삭제시 해당글의 파일 삭제 (비밀번호 재확인 이후) */
    public int delete(int boardId){
        String SQL = "DELETE " +
                "FROM file " +
                "WHERE board_id = ? ";
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection conn = null;
        try{
            conn = getConnection();
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1,boardId);
            return pstmt.executeUpdate();
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            BoardDAO.tripleEx(conn, pstmt, rs);
        }
        return -1;
    }

}
