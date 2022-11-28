package com.example.jspboard.file;

public class File {

    private Integer file_id;
    private String file_name;
    private String file_real_name;
    private Long file_size;
    private String file_path;

    private String file_type;

    public String getFile_type() {return file_type;}

    public void setFile_type(String file_type) {this.file_type = file_type;}

    public Integer getFile_id() {
        return file_id;
    }

    public void setFile_id(Integer file_id) {
        this.file_id = file_id;
    }

    public String getFile_name() {
        return file_name;
    }

    public Long getFile_size() {return file_size;}

    public void setFile_size(Long file_size) {this.file_size = file_size;}

    public String getFile_path() {return file_path;}

    public void setFile_path(String file_path) {this.file_path = file_path;}

    public void setFile_name(String file_name) {this.file_name = file_name;}

    public String getFile_real_name() {
        return file_real_name;
    }

    public void setFile_real_name(String file_real_name) {
        this.file_real_name = file_real_name;
    }

    @Override
    public String toString() {
        return "File{" +
                "file_id=" + file_id +
                ", file_name='" + file_name + '\'' +
                ", file_real_name='" + file_real_name + '\'' +
                ", file_size=" + file_size +
                ", file_path='" + file_path + '\'' +
                ", file_type='" + file_type + '\'' +
                '}';
    }
}
