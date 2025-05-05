package com.yourday.project.backend.controller;

import com.yourday.project.backend.entity.Notes;
import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.interfase.UserRepository;
import com.yourday.project.backend.service.NotesService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/notes")
public class NotesController {

    private final NotesService noteService;
    private final UserRepository userRepository;


    public NotesController(NotesService noteService, UserRepository userRepository) {
        this.noteService = noteService;
        this.userRepository = userRepository;
    }



    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Notes>> getNotesByUserId(@PathVariable String userId) {
        List<Notes> notes = noteService.getNotesByUserId(userId);
        return ResponseEntity.ok(notes);
    }

    @PostMapping("/save")
    public ResponseEntity<String> saveNote(@RequestBody Notes noteRequest) {
        try {

            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String userEmail = authentication.getName();

            User user = userRepository.findByEmail(userEmail)
                    .orElseThrow(() -> new IllegalArgumentException("User not found"));


            Notes savedNote = noteService.saveNotes(noteRequest, user.getId());

            return ResponseEntity.ok("Note saved successfully with ID: " + savedNote.getId());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}

