package com.yourday.project.backend.interfase;


import com.yourday.project.backend.entity.Steps;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StepsRepository extends JpaRepository<Steps, String>
{

    Steps findByUserId(String userId);
}
