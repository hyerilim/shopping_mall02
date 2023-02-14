package com.shop.mall.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class IndexController {

	@GetMapping(value="/index")
	public String index() {
		return "jsp/index";
	}
	@GetMapping(value="/")
	public String root() {
		return "jsp/index";
	}
	
}
