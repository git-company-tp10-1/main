package com.yourday.project.backend.interfase;

import com.yourday.project.backend.entity.Application;


import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;

import java.util.List;

public interface ApplicationRepository extends JpaRepository<Application, String> {

    List<Application> findTotalApplicationByUserIdAndUsageDateBetween(String user, LocalDate usageDate, LocalDate usageDate2);
}
