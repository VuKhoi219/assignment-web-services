package com.example.backend.dto;

public class ImageDTO {
    private Integer id;
    private String imageUrl;
    private String imageData;
    private String caption;
    public ImageDTO() {}

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getImageData() {
        return imageData;
    }

    public void setImageData(String imageData) {
        this.imageData = imageData;
    }

    public String getCaption() {
        return caption;
    }

    public void setCaption(String caption) {
        this.caption = caption;
    }

    public ImageDTO(Integer id, String imageUrl, String imageData, String caption) {
        this.id = id;
        this.imageUrl = imageUrl;
        this.imageData = imageData;
        this.caption = caption;
    }


}
