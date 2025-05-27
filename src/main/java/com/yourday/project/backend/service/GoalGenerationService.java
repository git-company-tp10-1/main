package com.yourday.project.backend.service;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yourday.project.backend.entity.Application;
import com.yourday.project.backend.entity.Notes;
import com.yourday.project.backend.entity.Steps;
import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.interfase.ApplicationRepository;
import com.yourday.project.backend.interfase.NotesRepository;
import com.yourday.project.backend.interfase.StepsRepository;
import com.yourday.project.backend.interfase.UserRepository;
import com.yourday.project.backend.security.OpenRouterConfig;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
public class GoalGenerationService {


    private final ObjectMapper objectMapper;
    private final StepsRepository stepsRepository;
    private final NotesService notesService;
    private final ApplicationService applicationService;
    private final OpenRouterConfig openRouterConfig;

    public GoalGenerationService(UserRepository userRepository, ApplicationRepository applicationRepository, NotesRepository notesRepository, ObjectMapper objectMapper, StepsRepository stepsRepository, NotesService notesService, ApplicationService applicationService, OpenRouterConfig openRouterConfig) {
        this.objectMapper = objectMapper;
        this.stepsRepository = stepsRepository;
        this.notesService = notesService;
        this.applicationService = applicationService;
        this.openRouterConfig = openRouterConfig;
    }

    public Map<String, Object> generateUserGoals(User user) throws Exception {



        LocalDate today = LocalDate.now();



        Steps steps = stepsRepository.findTotalStepsByUserIdAndUsageDate(user.getId().toString(), today);


        List<Notes> notes = notesService.getNotesForDate(today, user);
        String notesText = notes.stream()
                .map(Notes::getContent)
                .collect(Collectors.joining("\n"));

        List<Application> apps = applicationService. findByUserAndUsageDateBetween(user, today, today);
        String appsText = apps.stream()
                .map(app -> String.format(
                        "%s: %d мин",
                        app.getAppName(),
                        TimeUnit.MILLISECONDS.toMinutes(app.getUsageTimeMillis())
                ))
                .collect(Collectors.joining("\n"));

        // 4. Генерируем цели через AI
        Map<String, Object> aiResponse = generateGoalsViaAI(
                notesText,
                steps.getStepCount(),
                appsText
        );

        // 5. Форматируем ответ для фронта
        return formatForFrontend(aiResponse);
    }

    private Map<String, Object> generateGoalsViaAI(String notes, int steps, String appUsage) throws Exception {
        Map<String, Object> request = new HashMap<>();
        request.put("model", "qwen/qwq-32b:free");
        request.put("temperature", 0.7);

        String prompt = String.format(
                "Сгенерируй 3-5 очень кратких целей на день (максимум 7 слов каждая) Обязательно НА РУССКОМ на основе:\n" +
                        "Заметки: %s\nШаги: %d\nИспользование приложений: %s\n\n" +
                        "Ответ ТОЛЬКО в формате: {\"goals\":[\"цель 1\",\"цель 2\"]} " +
                        "Без объяснений, комментариев и поля reasoning. НИКАКИХ ЛИШНИХ КОММЕНТАРИЕВ",
                notes, steps, appUsage
        );

        request.put("messages", List.of(Map.of(
                "role", "user",
                "content", prompt
        )));


        String response = sendOpenRouterRequest(request);

        JsonNode rootNode = objectMapper.readTree(response);
        String content = rootNode.path("choices")
                .get(0)
                .path("message")
                .path("content")
                .asText();

        // Дополнительная обработка для удаления переносов строк
        content = content.replace("\n", "").replace("  ", "");

        try {
            return objectMapper.readValue(content, Map.class);
        } catch (Exception e) {
            // Если AI вернул невалидный JSON, попробуем извлечь goals вручную
            Pattern pattern = Pattern.compile("\"goals\":\\s*\\[(.*?)\\]");
            Matcher matcher = pattern.matcher(content);
            if (matcher.find()) {
                String goalsStr = "[" + matcher.group(1) + "]";
                List<String> goals = objectMapper.readValue(goalsStr, List.class);
                return Map.of("goals", goals);
            }
            throw e;
        }

    }

    private Map<String, Object> formatForFrontend(Map<String, Object> aiResponse) {
        Map<String, Object> result = new HashMap<>();
        List<String> goals = (List<String>) aiResponse.getOrDefault("goals", List.of());

        // Добавляем дефолтные цели, если ИИ не вернул ничего полезного
        if (goals.isEmpty()) {
            goals = List.of(
                    "Сходить на прогулку",
                    "Выпить 1.5 литра воды",
                    "Сделать перерыв каждый час"
            );
        }


        result.put("goals", goals);


        return result;
    }

    private String sendOpenRouterRequest(Map<String, Object> requestBody) throws Exception {
        HttpClient client = HttpClient.newHttpClient();

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(openRouterConfig.getApiUrl()))
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + openRouterConfig.getApiKey())
                .header("HTTP-Referer", "https://yourdomain.com")
                .POST(HttpRequest.BodyPublishers.ofString(
                        objectMapper.writeValueAsString(requestBody))
                )
                .build();

        HttpResponse<String> response = client.send(
                request, HttpResponse.BodyHandlers.ofString()
        );

        if (response.statusCode() != 200) {
            throw new RuntimeException("Request failed: " + response.body());
        }

        return response.body();
    }
}