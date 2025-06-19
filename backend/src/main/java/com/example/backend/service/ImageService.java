package com.example.backend.service;

import com.example.backend.dto.ImageListWrapper;
import com.example.backend.entity.Image;
import com.example.backend.entity.Location;
import com.example.backend.entity.User;

import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;
import java.util.ArrayList;
import java.util.List;

@WebService
@SOAPBinding(style = SOAPBinding.Style.RPC)
public interface ImageService {

    @WebMethod
    ImageListWrapper getImages();

    @WebMethod
    Image getImage(int id);

    @WebMethod
    String uploadImage(int locationId,
                      String base64ImageData,
                       String filename,
                       String caption,String token);

    @WebMethod
    String updateImage(int imageId,
                       String base64ImageData,
                       String filename,
                       String caption,String token);

    @WebMethod
    String deleteImage(int id,String token);

    @WebMethod
    ArrayList<Image> getImagesByLocation(int locationId);

    @WebMethod
    String getImageAsBase64(int imageId);
}
