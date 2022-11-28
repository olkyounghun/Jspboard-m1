package com.example.jspboard.board;

import java.sql.Timestamp;

public class Board {
    private Integer board_id;
    private String category_type;
    private String board_title;
    private String board_content;
    private String board_user;
    private String board_pw;
    private Integer board_views;
    private Timestamp board_regdate;
    private Timestamp board_moddate;

    public Integer getBoard_id() {
        return board_id;
    }

    public void setBoard_id(Integer board_id) {
        this.board_id = board_id;
    }

    public String getCategory_type() {
        return category_type;
    }

    public void setCategory_type(String category_type) {
        this.category_type = category_type;
    }

    public String getBoard_title() {
        return board_title;
    }

    public void setBoard_title(String board_title) {
        this.board_title = board_title;
    }

    public String getBoard_content() {
        return board_content;
    }

    public void setBoard_content(String board_content) {
        this.board_content = board_content;
    }

    public String getBoard_user() {
        return board_user;
    }

    public void setBoard_user(String board_user) {
        this.board_user = board_user;
    }

    public String getBoard_pw() {
        return board_pw;
    }

    public void setBoard_pw(String board_pw) {
        this.board_pw = board_pw;
    }

    public Integer getBoard_views() {
        return board_views;
    }

    public void setBoard_views(Integer board_views) {
        this.board_views = board_views;
    }

    public Timestamp getBoard_regdate() {
        return board_regdate;
    }

    public void setBoard_regdate(Timestamp board_regdate) {
        this.board_regdate = board_regdate;
    }

    public Timestamp getBoard_moddate() {
        return board_moddate;
    }

    public void setBoard_moddate(Timestamp board_moddate) {
        this.board_moddate = board_moddate;
    }

    @Override
    public String toString() {
        return "Board{" +
                "board_id=" + board_id +
                ", category_type='" + category_type + '\'' +
                ", board_title='" + board_title + '\'' +
                ", board_content='" + board_content + '\'' +
                ", board_user='" + board_user + '\'' +
                ", board_pw='" + board_pw + '\'' +
                ", board_views=" + board_views +
                ", board_regdate=" + board_regdate +
                ", board_moddate=" + board_moddate +
                '}';
    }


}

