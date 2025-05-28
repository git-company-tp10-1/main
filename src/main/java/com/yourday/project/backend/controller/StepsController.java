package com.yourday.project.backend.controller;



import com.yourday.project.backend.entity.Notes;
import com.yourday.project.backend.entity.Steps;
import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.interfase.UserRepository;
import com.yourday.project.backend.security.JwtUtil;
import com.yourday.project.backend.service.StepsService;

import com.yourday.project.backend.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;


@RestController
@RequestMapping("/steps")
public class StepsController {

    private final StepsService stepsService;
    private final UserService userService;
    private final JwtUtil jwtUtil;


    public StepsController(StepsService stepsService, UserService userService, JwtUtil jwtUtil) {
        this.stepsService = stepsService;
        this.userService = userService;
        this.jwtUtil = jwtUtil;
    }


    @PostMapping("/save")
    public ResponseEntity<Void> saveStep(@RequestBody Steps steps, HttpServletRequest request) {
        String token = jwtUtil.extractTokenFromRequest(request);
        String userEmail = jwtUtil.extractEmail(token);

        User user = userService.findByEmail(userEmail);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid token");
        }
        stepsService.saveSteps(steps, user);
        return ResponseEntity.ok().build();
    }


    @GetMapping("/total")
    public ResponseEntity<Integer> getTotalSteps(@RequestParam String startDate, @RequestParam String endDate, HttpServletRequest request) {
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
                return ResponseEntity.badRequest().body(0);
            }


            int totalSteps = stepsService.getTotalSteps(user.getId(), start, end);
            return ResponseEntity.ok(totalSteps);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(0);
        }
    }
}
