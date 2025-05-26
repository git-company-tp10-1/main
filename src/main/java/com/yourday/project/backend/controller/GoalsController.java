package com.yourday.project.backend.controller;

import com.yourday.project.backend.entity.Goals;

import com.yourday.project.backend.entity.Notes;
import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.security.JwtUtil;
import com.yourday.project.backend.service.GoalsService;

import com.yourday.project.backend.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/goals")
public class GoalsController {

    private final GoalsService goalsService;


    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private UserService userService;

    public GoalsController(GoalsService goalsService) {
        this.goalsService = goalsService;
    }

    @PostMapping("/save")
    public ResponseEntity<Void> saveGoal(@RequestBody Goals goal, HttpServletRequest request) {
        String token = jwtUtil.extractTokenFromRequest(request);
        String userEmail = jwtUtil.extractEmail(token);

        User user = userService.findByEmail(userEmail);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid token");
        }
        goalsService.saveGoal(goal, user);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/update")
    public ResponseEntity<Void> updateNote(@RequestBody Goals goal, HttpServletRequest request) {
        String token = jwtUtil.extractTokenFromRequest(request);
        String userEmail = jwtUtil.extractEmail(token);

        User user = userService.findByEmail(userEmail);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid token");
        }
        goalsService.updateGoal(goal, user);
        return ResponseEntity.ok().build();


    }

    @PostMapping("/delete")
    public ResponseEntity<Void> deleteNote(@RequestBody Goals goal, HttpServletRequest request) {
        String token = jwtUtil.extractTokenFromRequest(request);
        String userEmail = jwtUtil.extractEmail(token);

        User user = userService.findByEmail(userEmail);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid token");
        }
        goalsService.deleteGoal(goal, user);
        return ResponseEntity.ok().build();

    }

    @GetMapping("/total")
    public ResponseEntity<List<Goals>> findAllGoalsByUserId(HttpServletRequest request) {

        String token = jwtUtil.extractTokenFromRequest(request);
        String userEmail = jwtUtil.extractEmail(token);

        User user = userService.findByEmail(userEmail);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid token");
        }

        List<Goals> goals = goalsService.findAllGoalsByUserId(user.getId());
        return ResponseEntity.ok(goals);

    }
}
