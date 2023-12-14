package com.training;
import com.training.util.RestUtil;
import java.util.HashMap;
import java.util.Map;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class TrainingUiApplication {

	public static String subjects = null;
	public static void main(String[] args)  throws JsonProcessingException {
		RestUtil restUtil = new RestUtil();
		Map<String, Object>params = new HashMap<String, Object>();
		subjects = restUtil.get("http://localhost:8000/subject", params);
		SpringApplication.run(TrainingUiApplication.class, args);
	}

	public static String getSubjects(){
		return subjects;
	}
}
