package com.yourday.project.backend.service;


import com.yourday.project.backend.entity.Application;
import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.interfase.ApplicationRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ApplicationService {

    private final ApplicationRepository applicationRepository;


    public ApplicationService(ApplicationRepository applicationRepository) {
        this.applicationRepository = applicationRepository;
    }

    public void saveAllApps(List<Application> apps, User user) {

        for (Application app : apps) {
            app.setUser(user); // если есть связь с пользователем
            applicationRepository.save(app);
        }

    }
}
