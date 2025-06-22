package com.example.backend.service;


import com.example.backend.dto.LocationDTO;
import com.example.backend.dto.LocationListWrapper;
import com.example.backend.entity.Comment;
import com.example.backend.entity.Image;
import com.example.backend.entity.Location;
import com.example.backend.entity.User;

import javax.annotation.security.RolesAllowed;
import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;
import javax.xml.bind.annotation.XmlSeeAlso;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@WebService
@SOAPBinding(style = SOAPBinding.Style.RPC)
@XmlSeeAlso({Location.class, User.class, Image.class, Comment.class}) // Quan trọng: khai báo các complex types
public interface LocationService {

    @WebMethod
    public LocationListWrapper getLocations();
    @WebMethod
    @WebResult(name = "return", targetNamespace = "")
    public Location getLocation(int id);
    @WebMethod
    Location createLocation(String title, String description, int guideId,String token);

    @WebMethod
    Location updateLocation(String title, String description, int id,String token);
    @WebMethod
    boolean deleteLocation(int id,String token);
//    @WebMethod
//    List<Location> getLocationByKey(String key);

}
