package com.yourday.project.backend.service;

import com.yourday.project.backend.entity.Goals;

import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.interfase.GoalsRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class GoalsService {

    private final GoalsRepository goalsRepository;

    public GoalsService(GoalsRepository goalsRepository) {
        this.goalsRepository = goalsRepository;
    }


    public void saveGoal(Goals goal, User user) {
        goal.setUser(user);
        goalsRepository.save(goal);
    }


    public Goals updateGoal(Goals goals, User user) {
        if (goals == null || user == null || goals.getContent() == null) {
            throw new IllegalArgumentException("Goals, User, and Content cannot be null");
        }

        Goals existingGoal = goalsRepository.findByUserAndContent(user, goals.getContent())
                .orElseThrow(() -> new IllegalArgumentException(
                        "Goal not found for user " + user.getId() + " with content " + goals.getContent()
                ));


        existingGoal.setStatus(goals.getStatus());
        existingGoal.setUpdatedAt(LocalDateTime.now());
        existingGoal.setContent(goals.getContent());


        return goalsRepository.save(existingGoal);
    }

    public void deleteGoal(Goals goals, User user) {
        if (goals == null || user == null || goals.getContent() == null) {
            throw new IllegalArgumentException("Goals, User, and Content cannot be null");
        }

        Goals existingGoal = goalsRepository.findByUserAndContent(user, goals.getContent())
                .orElseThrow(() -> new IllegalArgumentException(
                        "Goal not found for user " + user.getId() + " with content " + goals.getContent()
                ));

        goalsRepository.delete(existingGoal);

    }

    public List<Goals> findAllGoalsByUserId(UUID userId) {
        return goalsRepository.findByUserId(userId.toString());
    }


}
