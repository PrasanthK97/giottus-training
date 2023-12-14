package com.training.util;

import java.util.Map;

import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Configuration
@RestController

public class RestUtil {
    public String get(String url, Map<String, Object> params) throws JsonProcessingException {
        RestTemplate template = new RestTemplate();
        String reqBodyData = new ObjectMapper().writeValueAsString(params);
        HttpEntity<String> requestEntity = new HttpEntity<>(reqBodyData);
        ResponseEntity<String> response = template.getForEntity(url, String.class, requestEntity);
        return response.getBody();
        }

    public String post(String url, Map<String, Object> params) throws JsonProcessingException {
        RestTemplate template = new RestTemplate();
        HttpHeaders header = new HttpHeaders();
        header.setContentType(MediaType.APPLICATION_JSON);

        String reqBodyData = new ObjectMapper().writeValueAsString(params);
        HttpEntity<String> requestEntity = new HttpEntity<>(reqBodyData, header);
        ResponseEntity<String> response = template.postForEntity(url, requestEntity, String.class);
        return response.getBody();
    }
}
