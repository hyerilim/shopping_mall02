package com.shop.mall.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class TestController {
	
	@GetMapping(value="/admin/test/new")
	public String testForm() {
		return "jsp/test/testForm";
	}
}
