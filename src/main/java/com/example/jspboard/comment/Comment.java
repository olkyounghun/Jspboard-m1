package com.example.jspboard.comment;

import java.sql.Timestamp;

public class Comment {

    private Integer cment_id;

    private String cment_user;

    private String cment_password;

    private String cment_content;

    private Timestamp cment_regdate;

    private Timestamp cment_moddate;

    public Integer getCment_id() {
        return cment_id;
    }

    public void setCment_id(Integer cment_id) {
        this.cment_id = cment_id;
    }

    public String getCment_user() {
        return cment_user;
    }

    public void setCment_user(String cment_user) {
        this.cment_user = cment_user;
    }

    public String getCment_password() {
        return cment_password;
    }

    public void setCment_password(String cment_password) {
        this.cment_password = cment_password;
    }

    public String getCment_content() {
        return cment_content;
    }

    public void setCment_content(String cment_content) {
        this.cment_content = cment_content;
    }

    public Timestamp getCment_regdate() {
        return cment_regdate;
    }

    public void setCment_regdate(Timestamp cment_regdate) {
        this.cment_regdate = cment_regdate;
    }

    public Timestamp getCment_moddate() {
        return cment_moddate;
    }

    public void setCment_moddate(Timestamp cment_moddate) {
        this.cment_moddate = cment_moddate;
    }
}
