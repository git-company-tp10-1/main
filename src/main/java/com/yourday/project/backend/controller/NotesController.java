package com.yourday.project.backend.controller;

import com.yourday.project.backend.entity.Notes;
import com.yourday.project.backend.service.NotesService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/notes")
public class NotesController {

    private final NotesService noteService;


    public NotesController(NotesService noteService) {
        this.noteService = noteService;
    }



    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Notes>> getNotesByUserId(@PathVariable String userId) {
        List<Notes> notes = noteService.getNotesByUserId(userId);
        return ResponseEntity.ok(notes);
    }
}

