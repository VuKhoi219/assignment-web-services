package com.example.backend.dto;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.List;

@XmlRootElement(name = "locationList")
@XmlAccessorType(XmlAccessType.FIELD)
public class LocationListWrapper {
    @XmlElement(name = "location")
    private List<LocationDTO> locations;

    public LocationListWrapper() {}

    public LocationListWrapper(List<LocationDTO> locations) {
        this.locations = locations;
    }

    public List<LocationDTO> getLocations() {
        return locations;
    }

    public void setLocations(List<LocationDTO> locations) {
        this.locations = locations;
    }
}