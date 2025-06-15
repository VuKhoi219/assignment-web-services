package com.example.backend.dto;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.List;

@XmlRootElement(name = "imageList")
@XmlAccessorType(XmlAccessType.FIELD)
public class ImageListWrapper {

    @XmlElement(name = "image")
    private List<ImageDTO> images;

    public ImageListWrapper() {}

    public ImageListWrapper(List<ImageDTO> images) {
        this.images = images;
    }

    public List<ImageDTO> getImages() {
        return images;
    }

    public void setImages(List<ImageDTO> images) {
        this.images = images;
    }
}