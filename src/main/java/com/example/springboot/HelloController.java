package com.example.springboot;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

	@GetMapping("/{title}/{firstName}/{lastName}")
	public String index(@PathVariable String title, @PathVariable String firstName, @PathVariable String lastName) {
		return "Greetings " + title + " " + firstName + " " + lastName + " from Spring Boot!";
	}

}
