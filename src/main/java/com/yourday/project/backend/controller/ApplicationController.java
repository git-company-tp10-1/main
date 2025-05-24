package com.yourday.project.backend.controller;

import com.yourday.project.backend.entity.Application;
import com.yourday.project.backend.entity.Notes;
import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.security.JwtUtil;
import com.yourday.project.backend.service.ApplicationService;

import com.yourday.project.backend.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/app")
public class ApplicationController {

    private final ApplicationService applicationService;


    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private UserService userService;


    public ApplicationController(ApplicationService applicationService) {
        this.applicationService = applicationService;
    }

    @PostMapping("/save")
    public ResponseEntity<Void> saveApps(@RequestBody List<Application> apps, HttpServletRequest request) {
        String token = jwtUtil.extractTokenFromRequest(request);
        String userEmail = jwtUtil.extractEmail(token);

        User user = userService.findByEmail(userEmail);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid token");
        }

        applicationService.saveAllApps(apps, user);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/total")
    public ResponseEntity<List<Application>> getTotalApps(@RequestParam String startDate, @RequestParam String endDate, HttpServletRequest request) {
        try {

            String token = jwtUtil.extractTokenFromRequest(request);
            String userEmail = jwtUtil.extractEmail(token);


            User user = userService.findByEmail(userEmail);
            if (user == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }


            LocalDate start = LocalDate.parse(startDate);
            LocalDate end = LocalDate.parse(endDate);


            if (start.isAfter(end)) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
            }

            List<Application> apps = applicationService.findByUserAndUsageDateBetween(user, start, end);

            return ResponseEntity.ok(apps);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
