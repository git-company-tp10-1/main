package com.yourday.project.backend.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import org.hibernate.annotations.GenericGenerator;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
public class Steps {
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

    @Column(name = "step_count", nullable = false)
    private Integer stepCount;

    @Column(name = "usage_date", nullable = false)
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate usageDate;

    @Column(name = "created_at", updatable = false, nullable = false)
    @JsonIgnore
    private LocalDateTime createdAt = LocalDateTime.now();


    public Steps() {
    }

    public UUID getId() {
        return id != null ? UUID.fromString(id) : null;
    }

    // И метод для установки UUID
    public void setId(UUID uuid) {
        this.id = uuid != null ? uuid.toString() : null;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Integer getStepCount() {
        return stepCount;
    }

    public void setStepCount(Integer stepCount) {
        this.stepCount = stepCount;
    }

    public LocalDate getUsageDate() {
        return usageDate;
    }

    public void setUsage(LocalDate usageDate) {
        this.usageDate = usageDate;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
