package com.shop.mall.controller;

import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.shop.mall.dto.BannerDto;
import com.shop.mall.service.BannerService;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
public class BannerController {
	
	private final BannerService bannerService;
	
	// 롤링 배너 페이지
	@GetMapping("/banner")
	public String bannerPage() {
		return "jsp/banner/banner";
	}
	
	// 배너 목록
	@GetMapping("/banner/list")
	public String bannerList(@PageableDefault(page=1) Pageable pageable, Model model) {
		
		log.info("배너 목록");
		
		Page<BannerDto> bannerList = bannerService. bannerListPaging(pageable);
		
		// 하단 페이지 번호 갯수
		int blockLimit =5;
		int startPage = (((int)(Math.ceil((double)pageable.getPageNumber() / blockLimit))) - 1 ) * blockLimit + 1;
		int endPage = ((startPage + blockLimit - 1 ) < bannerList.getTotalPages()) ? startPage + blockLimit - 1 : bannerList.getTotalPages();
		
		model.addAttribute("bannerList", bannerList);
		model.addAttribute("startPage", startPage);
		model.addAttribute("endPage", endPage);

		// List<BannerDto> bannerDtoList = bannerService.findAll();
		// model.addAttribute("bannerList", bannerDtoList);
		
		return "jsp/banner/bannerList";
	}
	
	// 배너 등록 페이지
	@GetMapping("/banner/listAdd")
	public String bannerListAdd(Model model) {
		
		log.info("배너 등록 페이지");
		
		model.addAttribute("bannerImg", new BannerDto());
		
		return "jsp/banner/bannerListAdd";
	}
	
	// 배너 등록
//	@PostMapping("/banner/create")
//	public String bannerCreate(@ModelAttribute BannerDto bannerDto) throws Exception{
//		
//		log.info("배너 등록");
//		
//		log.info("bannerDto : "+bannerDto);
//		
//		bannerService.bannerSave(bannerDto);
//		
//		return "redirect:/banner/list";
//	}
	
	// 배너 등록
	@PostMapping("/banner/new")
	@ResponseBody
	public Map<String, Object> bannerNew(@RequestParam Map<String, Object> params) throws Exception{
		
		log.info("배너 등록");
		
		log.info("params : "+params);
		
		// 글등록
		bannerService.bannerSave(params);
		
		return params;
	}
	
	// 배너 파일 등록
	@PostMapping("/banner/newFile")
	@ResponseBody
	// @RequestPart(value="bannerImages", required=false)
	// bannerImages에 들어있는 값이 없어도 통과 가능(필수 입력이 아님)
	public Map<String, Object> bannerNewFile(@RequestPart(value="bannerImages", required=false) List<MultipartFile> multipartFiles) throws Exception{
		
		log.info("배너 파일 등록");
		
		log.info("multipartFiles : "+multipartFiles);
		
		return bannerService.bannerFileSave(multipartFiles);
	}

	// 배너 상세조회
	@GetMapping("/banner/{id}")
	public String findById(@PathVariable Long id, Model model,@PageableDefault(page=1) Pageable pageable) {
		
		log.info("배너 상세조회");
		
		BannerDto bannerDto = bannerService.findById(id);
		model.addAttribute("banner", bannerDto);
		model.addAttribute("page", pageable.getPageNumber());
		return "jsp/banner/bannerListAdd";
		
	}
	
	// 배너 수정 페이지
	@GetMapping("/banner/update/{id}")
	public String bannerUpdatePage(@PathVariable Long id, Model model) {
		
		log.info("배너 수정 페이지");
		
		BannerDto bannerDto = bannerService.findById(id);
		
		model.addAttribute("bannerUpdate" , bannerDto);

		return "jsp/banner/bannerListAdd";
	}
	
	// 배너 수정
	@PostMapping("/banner/update")
	@ResponseBody
	public Map<String, Object> bannerUpdate(@RequestBody Map<String, Object> params) {
		
		log.info("배너 수정");
		
		log.info("params : "+params);
		
		bannerService.bannerUpdate(params);
		
		return params;
	}
	
	// 배너 선택삭제
	@PostMapping("/banner/delete")
	@ResponseBody
	public Map<String, Object> bannerCheckDelete(@RequestParam(value="bannerCheckArr[]") List<String> bannerCheckArr) throws Exception{
		
		log.info("배너 선택삭제");
		
		System.out.println(bannerCheckArr);
		
		return bannerService.bannerCheckDelete(bannerCheckArr);
		
	}
	
	
	
}
