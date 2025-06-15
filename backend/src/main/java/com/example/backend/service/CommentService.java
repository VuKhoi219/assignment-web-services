package com.example.backend.service;

import com.example.backend.dto.CommentListWrapper;
import com.example.backend.entity.Comment;
import com.example.backend.entity.Location;
import com.example.backend.entity.User;

import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;
import java.util.ArrayList;
import java.util.List;

@WebService
@SOAPBinding(style = SOAPBinding.Style.RPC)
public interface CommentService {
    @WebMethod
    CommentListWrapper getComments();
    @WebMethod
     Comment getComment(int id);
    @WebMethod
    String createComment(int  locationId, String comment, int userId, int rating);
    @WebMethod
    String updateComment( String Comment,int rating , int commentId );
    @WebMethod
    String deleteComment(int id);
    @WebMethod
    double getAverageRatingByLocation(int locationId);
}
