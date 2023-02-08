package com.shop.mall.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class TestController {
	
	@GetMapping(value="/admin/test/new")
	public String testForm() {
		return "jsp/test/testForm";
	}
	
	@GetMapping(value="/test/testDate")
	public String testDate() {
		return "jsp/test/testDate";
	}
	
	@GetMapping(value="/test/testDate1")
	public String testDate1() {
		return "jsp/test/test3";
	}
	
	@GetMapping(value="/test/test1")
	public String test1() {
		return "jsp/test/test1";
	}
}
