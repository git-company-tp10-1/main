package com.yourday.project.backend.service;

import com.yourday.project.backend.entity.Goals;

import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.interfase.GoalsRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
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

    public void saveAiGoal(Map<String, Object> goalsMap, User user) {

        if (goalsMap == null || !goalsMap.containsKey("goals")) {
            throw new IllegalArgumentException("Invalid goals map format");
        }

        List<String> goalsList;
        try {
            goalsList = (List<String>) goalsMap.get("goals");
        } catch (ClassCastException e) {
            throw new IllegalArgumentException("Goals should be a list of strings");
        }

        goalsList.stream()
                .filter(content -> content != null && !content.isBlank())
                .forEach(content -> {
                    Goals goal = new Goals();
                    goal.setContent(content);
                    goal.setUser(user);
                    goal.setCreatedByUser(false);
                    goal.setStatus(Goals.GoalStatus.ACTIVE);
                    goalsRepository.save(goal);
                });
    }


    public List<Goals> findAllGoalsAiByUserId(UUID userId) {
        return goalsRepository.findByUserIdAndCreatedByUserFalse(userId.toString());
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
