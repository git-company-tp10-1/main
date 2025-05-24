package com.yourday.project.backend.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.GenericGenerator;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
public class Application {
    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(name = "UUID", strategy = "org.hibernate.id.UUIDGenerator")
    @Column(name = "ID_uuid", columnDefinition = "CHAR(36)", updatable = false, nullable = false)
    private String id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_user_uuid", referencedColumnName = "id", nullable = false)
    private User user;

    @Column(name = "package_name", nullable = false, length = 255)
    private String packageName;

    @Column(name = "app_name", nullable = false, length = 255)
    private String appName;

    @Column(name = "usage_time_millis", nullable = false)
    private Long usageTimeMillis;

    @Column(name = "usage_date", nullable = false)
    private LocalDate usageDate;


    public Application() {
    }

    public UUID getId() {
        return id != null ? UUID.fromString(id) : null;
    }


    public void setId(UUID uuid) {
        this.id = uuid != null ? uuid.toString() : null;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getAppName() {
        return appName;
    }

    public void setAppName(String appName) {
        this.appName = appName;
    }

    public Long getUsageTimeMillis() {
        return usageTimeMillis;
    }

    public void setUsageTimeMillis(Long usageTimeMillis) {
        this.usageTimeMillis = usageTimeMillis;
    }



    public LocalDate getUsageDate() {
        return usageDate;
    }

    public void setUsageDate(LocalDate usageDate) {
        this.usageDate = usageDate;
    }
}
