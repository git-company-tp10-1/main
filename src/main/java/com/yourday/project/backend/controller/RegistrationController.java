package com.yourday.project.backend.controller;



import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.service.RegistrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;


@RestController
@RequestMapping("/auth")
public class RegistrationController {
    @Autowired
    private RegistrationService regService;

    @PostMapping("/register")
    public ResponseEntity<String> registerUser(@RequestBody User user) {
        try {
            user.setId(UUID.randomUUID());
            regService.registerUser(user);



            return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body("User registered successfully with ID: " + user.getId());
        } catch (IllegalArgumentException e) {
            // Возвращаем ошибку с описанием проблемы
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
    public ResponseEntity<?> loginUser(@RequestBody User user) {
        try {
            User loggedInUser = regService.loginUser(user);

            // Можно возвращать только ограниченные данные (например, имя и email)
            return ResponseEntity.ok(Map.of(
                    "id", loggedInUser.getId(),
                    "email", loggedInUser.getEmail(),
                    "name", loggedInUser.getName(),
                    "isPremium", loggedInUser.isPremium()
            ));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An unexpected error occurred.");
        }
    }

}
