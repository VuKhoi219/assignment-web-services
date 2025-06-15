package com.example.backend.entity;

import javax.persistence.*;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

@XmlRootElement
@XmlAccessorType(XmlAccessType.FIELD)
@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "username", nullable = true, length = 50)
    private String username;

    @Column(name = "password", nullable = true, length = 100)
    @XmlTransient // Không serialize password
    private String password;

    @Column(name = "email", nullable = true, length = 100)
    private String email;

    @Column(name = "role", nullable = true, length = 20)
    private String role;
    // One user can be a guide for many locations
    @OneToMany(mappedBy = "guide", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Location> guidedLocations;
    public User() {
    }

    public User(String username, String password, String email, String role) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.role = role;
    }

    // Getters & Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
    public List<Location> getGuidedLocations() {
        return guidedLocations;
    }

    public void setGuidedLocations(List<Location> guidedLocations) {
        this.guidedLocations = guidedLocations;
    }
}