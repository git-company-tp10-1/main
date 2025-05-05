package com.yourday.project.backend.controller;



import com.yourday.project.backend.entity.Steps;
import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.interfase.UserRepository;
import com.yourday.project.backend.service.StepsService;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;



@RestController
@RequestMapping("/steps")
public class StepsController {

    private final StepsService stepsService;
    private final UserRepository userRepository;


    public StepsController(StepsService stepsService, UserRepository userRepository) {
        this.stepsService = stepsService;
        this.userRepository = userRepository;
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<Steps> getNotesByUserId(@PathVariable String userId) {
         Steps step = stepsService.getStepsByUserId(userId);
        return ResponseEntity.ok(step);
    }

    @PostMapping("/save")
    public ResponseEntity<String> saveNote(@RequestBody Steps steps) {
        try {

            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String userEmail = authentication.getName();

            User user = userRepository.findByEmail(userEmail)
                    .orElseThrow(() -> new IllegalArgumentException("User not found"));


            Steps step = stepsService.saveSteps(steps, user.getId());

            return ResponseEntity.ok("Note saved successfully" );
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
