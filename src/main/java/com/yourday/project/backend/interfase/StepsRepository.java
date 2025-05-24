package com.yourday.project.backend.interfase;


import com.yourday.project.backend.entity.Steps;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

import java.time.LocalDateTime;
import java.util.UUID;

public interface StepsRepository extends JpaRepository<Steps, String>
{

    Steps findByUserId(String userId);

    List<Steps> findTotalStepsByUserIdAndUsageDateBetween(String user, LocalDateTime usageDate, LocalDateTime usageDate2);
}
