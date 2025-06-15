package com.example.backend.dto;

import java.util.List;

public class CommentListWrapper {
    private List<CommentDTO> comments;
    public CommentListWrapper() {}
    public CommentListWrapper(List<CommentDTO> comments) {
        this.comments = comments;
    }
    public List<CommentDTO> getComments() {
        return comments;
    }
    public void setComments(List<CommentDTO> comments) {
        this.comments = comments;
    }
}
