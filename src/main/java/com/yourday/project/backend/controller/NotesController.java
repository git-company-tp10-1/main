package com.yourday.project.backend.controller;

import com.yourday.project.backend.entity.Notes;
import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.interfase.UserRepository;
import com.yourday.project.backend.security.JwtFilter;
import com.yourday.project.backend.security.JwtUtil;
import com.yourday.project.backend.service.NotesService;
import com.yourday.project.backend.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/notes")
public class NotesController {

    private final NotesService noteService;


    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private UserService userService;




    public NotesController(NotesService noteService) {
        this.noteService = noteService;
    }





    @PostMapping("/save")
    public ResponseEntity<Void> saveNote(@RequestBody Notes note, HttpServletRequest request) {
        String token = jwtUtil.extractTokenFromRequest(request);
        String userEmail = jwtUtil.extractEmail(token);

        User user = userService.findByEmail(userEmail);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid token");
        }
        noteService.saveNotes(note, user);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/update")
    public ResponseEntity<Void> updateNote(@RequestBody Notes note, HttpServletRequest request) {
        String token = jwtUtil.extractTokenFromRequest(request);
        String userEmail = jwtUtil.extractEmail(token);

        User user = userService.findByEmail(userEmail);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid token");
        }
        noteService.updateNotes(note, user);
        return ResponseEntity.ok().build();


    }

    @PostMapping("/delete")
    public ResponseEntity<Void> deleteNote(@RequestBody Notes note, HttpServletRequest request) {
        String token = jwtUtil.extractTokenFromRequest(request);
        String userEmail = jwtUtil.extractEmail(token);

        User user = userService.findByEmail(userEmail);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid token");
        }
        noteService.deleteNotes(note, user);
        return ResponseEntity.ok().build();


    }
}

