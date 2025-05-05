package com.yourday.project.backend.interfase;

import com.yourday.project.backend.entity.Notes;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface NotesRepository extends JpaRepository<Notes, String> {
    List<Notes> findByUserId(String userId);


}
