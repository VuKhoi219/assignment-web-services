package com.example.backend.service;

import com.example.backend.entity.User;

import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;

@WebService
@SOAPBinding(style = SOAPBinding.Style.RPC)
public interface UserService {
    @WebMethod
    String register(String username, String password, String email, String role);

    @WebMethod
    String login(String username, String password);
}
