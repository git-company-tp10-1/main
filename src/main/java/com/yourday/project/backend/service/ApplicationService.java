package com.yourday.project.backend.service;


import com.yourday.project.backend.entity.Application;
import com.yourday.project.backend.entity.Steps;
import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.interfase.ApplicationRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

import java.util.List;

@Service
public class ApplicationService {

    private final ApplicationRepository applicationRepository;


    public ApplicationService(ApplicationRepository applicationRepository) {
        this.applicationRepository = applicationRepository;
    }

    public void saveAllApps(List<Application> apps, User user) {

        for (Application app : apps) {
            app.setUser(user);
            applicationRepository.save(app);
        }
    }

    public List<Application> findByUserAndUsageDateBetween(User user, LocalDate start, LocalDate end) {

        List<Application> apps = applicationRepository.findTotalApplicationByUserIdAndUsageDateBetween(user.getId().toString(), start, end);
        apps.sort((a1, a2) -> Long.compare(a2.getUsageTimeMillis(), a1.getUsageTimeMillis()));

        return apps;
    }
}
