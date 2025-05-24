package com.yourday.project.backend.service;


import com.yourday.project.backend.entity.Steps;
import com.yourday.project.backend.entity.User;

import com.yourday.project.backend.interfase.StepsRepository;
import org.springframework.stereotype.Service;


import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class StepsService {

    private final StepsRepository stepsRepository;



    public StepsService(StepsRepository stepsRepository) {
        this.stepsRepository = stepsRepository;

    }

    public Steps getStepsByUserId(String userId) {
        return stepsRepository.findByUserId(userId);
    }

    public void saveSteps(Steps steps, User user) {
        steps.setUser(user);
        stepsRepository.save(steps);
    }


    public int getTotalSteps(UUID userId, LocalDateTime startDate, LocalDateTime endDate) {
        List<Steps> steps = stepsRepository.findTotalStepsByUserIdAndUsageDateBetween(userId.toString(), startDate, endDate);
        return steps.stream().mapToInt(Steps::getStepCount).sum();
    }

}
