package com.yourday.project.backend.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
public class Goals {

    public enum GoalStatus {
        ACTIVE, COMPLETED, ARCHIVED, PENDING
    }

    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(name = "UUID", strategy = "org.hibernate.id.UUIDGenerator")
    @Column(name = "ID_uuid", columnDefinition = "CHAR(36)", updatable = false, nullable = false)
    @JsonIgnore
    private String id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_user_uuid", referencedColumnName = "id", nullable = false)
    @JsonIgnore
    private User user;

    @Column(name = "content", nullable = false, columnDefinition = "TEXT")
    private String content;

    @Column(name = "Created_by", nullable = false)
    private Boolean createdByUser = false; // true - системой , false - создано пользователем

    @Enumerated(EnumType.STRING)
    @Column(name = "Status", nullable = false, length = 255)
    private GoalStatus status;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false, nullable = false)
    @JsonIgnore
    private LocalDateTime createdAt = LocalDateTime.now();;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    @JsonIgnore
    private LocalDateTime updatedAt = LocalDateTime.now();;


    public Goals() {
    }

    public UUID getId() {
        return id != null ? UUID.fromString(id) : null;
    }


    public void setId(UUID uuid) {
        this.id = uuid != null ? uuid.toString() : null;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Boolean getCreatedByUser() {
        return createdByUser;
    }

    public void setCreatedByUser(Boolean createdByUser) {
        this.createdByUser = createdByUser;
    }

    public GoalStatus getStatus() {
        return status;
    }

    public void setStatus(GoalStatus status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
