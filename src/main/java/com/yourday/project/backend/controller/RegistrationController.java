package com.yourday.project.backend.controller;



import com.yourday.project.backend.entity.Notes;
import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.service.RegistrationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;


@RestController
@RequestMapping("/auth")
public class RegistrationController {
    @Autowired
    private RegistrationService regService;

    @PostMapping("/register")
    public ResponseEntity<String> registerUser(@RequestBody User user, HttpSession session) {
        try {

            regService.registerUser(user);

            return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body("User registered successfully");
        } catch (IllegalArgumentException e) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("An unexpected error occurred.");
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody User user, HttpSession session) {
        try {
            User loggedInUser = regService.loginUser(user);

            session.setAttribute("userId", loggedInUser.getId());
            session.setAttribute("userName", loggedInUser.getName());

            return ResponseEntity.ok("Logged in successfully");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An unexpected error occurred.");
        }
    }



}
