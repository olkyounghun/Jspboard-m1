package com.example.jspboard.comment;

import java.sql.Timestamp;

public class Comment {

    private Integer Cment_Id;

    private String Cment_User;

    private String Cment_Password;

    private String Cment_Content;

    private Timestamp Cment_Regdate;

    private Timestamp Cment_Moddate;

    public Integer getCment_Id() {
        return Cment_Id;
    }

    public void setCment_Id(Integer cment_Id) {
        Cment_Id = cment_Id;
    }

    public String getCment_User() {
        return Cment_User;
    }

    public void setCment_User(String cment_User) {
        Cment_User = cment_User;
    }

    public String getCment_Password() {
        return Cment_Password;
    }

    public void setCment_Password(String cment_Password) {
        Cment_Password = cment_Password;
    }

    public String getCment_Content() {
        return Cment_Content;
    }

    public void setCment_Content(String cment_Content) {
        Cment_Content = cment_Content;
    }

    public Timestamp getCment_Regdate() {
        return Cment_Regdate;
    }

    public void setCment_Regdate(Timestamp cment_Regdate) {
        Cment_Regdate = cment_Regdate;
    }

    public Timestamp getCment_Moddate() {
        return Cment_Moddate;
    }

    public void setCment_Moddate(Timestamp cment_Moddate) {
        Cment_Moddate = cment_Moddate;
    }
}
