package com.example.backend.dto;

public class CommentDTO {
    private Integer id;

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    private String comment;
    private int rating;

    public CommentDTO() {}
    public CommentDTO(Integer id,int rating, String comment) {
        this.id = id;
        this.comment = comment;

        this.rating = rating;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }
}
