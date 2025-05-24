package com.yourday.project.backend.interfase;

import com.yourday.project.backend.entity.Application;

import org.springframework.data.jpa.repository.JpaRepository;

public interface ApplicationRepository extends JpaRepository<Application, String> {

}
