package com.yourday.project.backend.entity;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import org.hibernate.annotations.GenericGenerator;

import java.time.LocalDateTime;
import java.util.UUID;


@Entity
public class User {

    @Id
    @GeneratedValue(generator = "uuid")
    @GenericGenerator(name = "uuid", strategy = "uuid2")
    @Column(columnDefinition = "CHAR(36)", updatable = false, nullable = false)
    @JsonIgnore
    private String id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    private boolean is_premium;

    @Column(name = "created_at", nullable = false)
    @JsonIgnore
    private LocalDateTime created_at;


    @Column(name = "updated_at")
    @JsonIgnore
    private LocalDateTime updated_at;





    public User(UUID id, String email, String name, String password, boolean isPremium) {
        this.id = String.valueOf(id);
        this.name = name;
        this.email = email;
        this.password = password;
        this.is_premium = isPremium;
        this.created_at = LocalDateTime.now();
        this.updated_at = LocalDateTime.now();
    }

    public User() {}

    public UUID getId() {
        return id != null ? UUID.fromString(id) : null;
    }


    public void setId(UUID uuid) {
        this.id = uuid != null ? uuid.toString() : null;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isPremium() {
        return is_premium;
    }

    public void setPremium(boolean premium) {
        is_premium = premium;
    }

    public LocalDateTime getCreated_at() {
        return created_at;
    }

    public void setCreated_at(LocalDateTime createdAt) {
        this.created_at = createdAt;
    }

    public LocalDateTime getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(LocalDateTime updatedAt) {
        this.updated_at = updatedAt;
    }

    @PrePersist
    protected void onCreate() {
        this.created_at = LocalDateTime.now();
        this.updated_at = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updated_at = LocalDateTime.now();
    }



}
