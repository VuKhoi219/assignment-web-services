package com.example.client.controller;

import com.mycompany.client.generated.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Simple Home Controller
 */
@WebServlet(name = "HomeController",value = "/")
public class HomeController extends HttpServlet {
    private LocationService getLocationsService(){
        LocationServiceImplService service = new LocationServiceImplService();
        return service.getLocationServiceImplPort();
    }
    // Place model class
    public static class Place {
        private int id;
        private String title;
        private String description;
        private String image;

        public Place(int id, String title, String description, String image) {
            this.id = id;
            this.title = title;
            this.description = description;
            this.image = image;
        }

        // Getters
        public int getId() { return id; }
        public String getTitle() { return title; }
        public String getDescription() { return description; }
        public String getImage() { return image; }

        // Setters
        public void setId(int id) { this.id = id; }
        public void setTitle(String title) { this.title = title; }
        public void setDescription(String description) { this.description = description; }
        public void setImage(String image) { this.image = image; }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get pagination parameters
        String pageParam = request.getParameter("page");
        String searchParam = request.getParameter("search");

        int currentPage = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        LocationService locationService = getLocationsService();
        LocationListWrapper wrapper = locationService.getLocations(); // Trả về LocationListWrapper
        List<LocationDTO> locations = wrapper.getLocation();
        // Convert LocationDTO objects to Place objects
        List<Place> places = new ArrayList<>();
        if (locations != null) {
            for (LocationDTO loc : locations) {
                Place place = new Place(
                        loc.getId(),
                        loc.getTitle(),
                        loc.getDescription(),
                        loc.getImageData()
                );
                System.out.println(loc.getId() + " - " + loc.getImageData());
                places.add(place);
            }
        }
        System.out.println("Total places created: " + places.size());

        // Filter places by search term
        List<Place> filteredPlaces = places;
        if (searchParam != null && !searchParam.trim().isEmpty()) {
            String searchTerm = searchParam.toLowerCase().trim();
            filteredPlaces = new ArrayList<>();
            for (Place place : places) {
                if (place.getTitle().toLowerCase().contains(searchTerm) ||
                        place.getDescription().toLowerCase().contains(searchTerm)) {
                    filteredPlaces.add(place);
                }
            }
        }

        System.out.println("Filtered places: " + filteredPlaces.size());

        // Pagination logic
        int itemsPerPage = 8;
        int totalItems = filteredPlaces.size();
        int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);

        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        int startIndex = (currentPage - 1) * itemsPerPage;
        int endIndex = Math.min(startIndex + itemsPerPage, totalItems);

        List<Place> paginatedPlaces = new ArrayList<>();
        if (startIndex < totalItems) {
            paginatedPlaces = filteredPlaces.subList(startIndex, endIndex);
        }

        System.out.println("Paginated places: " + paginatedPlaces.size());
        System.out.println("Current page: " + currentPage + "/" + totalPages);
        // Set attributes for JSP
        request.setAttribute("places", paginatedPlaces);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchTerm", searchParam != null ? searchParam : "");
        request.setAttribute("totalItems", totalItems);

        // Set content page and forward to layout
        request.setAttribute("content", "pages/home.jsp");
        request.getRequestDispatcher("layout.jsp").forward(request, response);
    }
}
