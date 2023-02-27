package com.shop.mall.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.shop.mall.dto.BannerDto;
import com.shop.mall.entity.BannerEntity;
import com.shop.mall.repository.BannerRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class BannerService {

	private final BannerRepository bannerRepository;
	
	// 배너 등록
	public void bannerSave(BannerDto bannerDto) {
		BannerEntity saveBannerEntity = BannerEntity.toSaveBannerEntity(bannerDto);
		bannerRepository.save(saveBannerEntity);
	}

	// 배너 목록
	public List<BannerDto> findAll() {
		List<BannerEntity> bannerEntityList = bannerRepository.findAll();
		List<BannerDto> bannerDtoList = new ArrayList<>();
		for(BannerEntity bannerEntity : bannerEntityList) {
			bannerDtoList.add(BannerDto.toListBannerDto(bannerEntity));
		}
		return bannerDtoList;
	}

	// 배너 상세조회
	public BannerDto findById(Long id) {
		Optional<BannerEntity> optionalBannerEntity = bannerRepository.findById(id);
		if(optionalBannerEntity.isPresent()) {
			BannerEntity bannerEntity = optionalBannerEntity.get();
			BannerDto bannerDto = BannerDto.toDetailBannerDto(bannerEntity);
			return bannerDto;
		} else {			
			return null;
		}
	}

	// 배너 수정
	public void bannerUpdate(BannerDto bannerDto) {
		BannerEntity updateBannerEntity = BannerEntity.toUpdateBannerEntity(bannerDto);
		bannerRepository.save(updateBannerEntity);
		
	}
	
}
