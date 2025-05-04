package com.yourday.project.backend.interfase;

import com.yourday.project.backend.entity.Notes;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotesRepository extends JpaRepository<Notes, String> {
    List<Notes> findByUserId(String userId);
}
