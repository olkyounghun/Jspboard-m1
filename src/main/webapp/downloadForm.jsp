<%@ page import="java.io.*"%>
<%@ page import="java.lang.*" %>
<%@ page import="com.example.jspboard.file.FileDAO" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
<head>
    <meta charset="UTF-8">
    <title>다운로드 중</title>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");

    /** 보내주는 파라미터를 받아줍니다. */
    int boardId = Integer.parseInt(request.getParameter("boardId"));

    /** "/"기준으로 file_path에 저장된 경로를 기준으로 다운로드폴더를 찾아 다운받도록 연결해준다. */
    String fileAddDate = new FileDAO().getFilePath(boardId);
    String[] fileCutDate = fileAddDate.split("/");
    // 예시 '/2022-11-22/99_Admin_poly-g07722548e_19201.jpg' >> 2022-11-22 가 나올것으로 예상

    /** 저장되어있는 경로의 파일을 다운받기위해 경로를 적어줍니다. 일일 날짜로 저장하고 있습니다. */
    String savePath = "C:\\\\Users\\\\Administrator\\\\Downloads\\\\BoardUploadFiles";
    String boardPath = savePath +"\\\\"+ fileCutDate[1];

    /** 파일은 boardId + boardUser + fileRname 으로 저장되어있습니다. */
    String fileName = request.getParameter("fileName");

    /** "_"기준으로 저장된 파일이름의 찐파일이름을 구하기위해 잘라서 찾는다. */
    String[] fileCutName = fileName.split("_");



    /** 게시물번호+작성자+파일명 으로 저장되기떼문에 파일명에 포함된 다수의 "_" 를 예상해서 합쳐줌 */
    StringBuilder fileRname = new StringBuilder(fileCutName[2]);
    if(fileCutName.length >= 3 ){
        for(int i = 3; i < fileCutName.length; i++){
            fileRname.append(fileCutName[i]);
        }
    }

    // Context에 대한 정보를 알아옴
    // ServletContext context = request.getServletContext(); // 서블릿에 대한 환경정보를 가져옴

    // 실제 파일이 저장되어 있는 폴더의 경로
    // String realFolder = context.getRealPath(boardPath);
    // 다운받을 파일의 전체 경로를 filePath에 저장
    // String filePath = realFolder + "\\\\" + fileName;

    InputStream in = null;
    OutputStream os = null;
    File file = null;
    boolean skip = false;
    String client;


    try{

        // 파일을 읽어 스트림에 담기
        try{
            file = new File(boardPath, fileName);
            in = new FileInputStream(file);
        }catch(FileNotFoundException fe){
            skip = true;
        }




        client = request.getHeader("User-Agent");

        // 파일 다운로드 헤더 지정
        response.reset() ;
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Description", "JSP Generated Data");


        if(!skip){


            // IE
            if(client.contains("MSIE")){
                response.setHeader ("Content-Disposition", "attachment; filename="+new String(fileRname.toString().getBytes("KSC5601"),"ISO8859_1"));

            }else{
                // 한글 파일명 처리
                fileRname = new StringBuilder(new String(fileRname.toString().getBytes(StandardCharsets.UTF_8), StandardCharsets.ISO_8859_1));

                response.setHeader("Content-Disposition", "attachment; filename=\"" + fileRname + "\"");
                response.setHeader("Content-Type", "application/octet-stream; charset=utf-8");
            }

            response.setHeader ("Content-Length", ""+file.length() );



            os = response.getOutputStream();
            byte[] b = new byte[(int)file.length()];
            int leng;

            while( (leng = in.read(b)) > 0 ){
                os.write(b,0,leng);
            }

        }else{

            response.setContentType("text/html;charset=UTF-8");
            PrintWriter script = response.getWriter();
            script.println("<script language='javascript'>alert('파일을 찾을 수 없습니다');history.back();</script>");

        }

        in.close();
        os.close();

    }catch(Exception e){
        e.printStackTrace();
    }
%>
</body>
</html>
