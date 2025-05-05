package com.yourday.project.backend.service;



import com.yourday.project.backend.entity.Steps;
import com.yourday.project.backend.entity.User;

import com.yourday.project.backend.interfase.StepsRepository;
import com.yourday.project.backend.interfase.UserRepository;
import org.springframework.stereotype.Service;


import java.util.UUID;

@Service
public class StepsService {

    private final StepsRepository stepsRepository;
    private final UserRepository userRepository;;

    public StepsService(StepsRepository stepsRepository, UserRepository userRepository) {
        this.stepsRepository = stepsRepository;
        this.userRepository = userRepository;
    }

    public Steps getStepsByUserId(String userId) {
        return stepsRepository.findByUserId(userId);
    }

    public Steps saveSteps(Steps steps, UUID userID) {

        User user = userRepository.findById(userID)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        steps.setUser(user);


        return stepsRepository.save(steps);
    }
}
