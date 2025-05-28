package com.yourday.project.backend.controller;
import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.security.JwtUtil;
import com.yourday.project.backend.service.RegistrationService;
import com.yourday.project.backend.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;


    @PostMapping("/update")
    public ResponseEntity<?> updateUser(@RequestBody User userUpdate, HttpServletRequest request) {

        String token = jwtUtil.extractTokenFromRequest(request);
        String userEmail = jwtUtil.extractEmail(token);

        User user = userService.findByEmail(userEmail);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid token");
        }

        userService.updateUser(user, userUpdate);
        return ResponseEntity.ok().build();
    }
}
