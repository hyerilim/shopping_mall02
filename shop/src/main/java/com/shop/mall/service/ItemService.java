package com.shop.mall.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.shop.mall.dto.ItemFormDto;
import com.shop.mall.dto.ItemImgDto;
import com.shop.mall.dto.ItemSearchDto;
import com.shop.mall.dto.MainItemDto;
import com.shop.mall.entity.Item;
import com.shop.mall.entity.ItemImg;
import com.shop.mall.repository.ItemImgRepository;
import com.shop.mall.repository.ItemRepository;

import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class ItemService {
	
	private final ItemRepository itemRepository;
	private final ItemImgService itemImgService;
	private final ItemImgRepository itemImgRepository;

	public Long saveItem(ItemFormDto itemFormDto
							, List<MultipartFile> itemImgFileList) throws Exception {
		
	// 상품 등록
		// 상품 등록 폼으로부터 입력 받은 데이터를 이용하여 item 객체를 생성
		Item item = itemFormDto.createItem();
		// 상품 데이터 저장
		itemRepository.save(item);
		
	// 이미지 등록
		for(int i=0; i<itemImgFileList.size(); i++) {
			ItemImg itemImg = new ItemImg();
			itemImg.setItem(item);
			
			// 첫번째 이미지일 경우 대표 상품 이미지 여부 값을 "Y"로 세팅, 나머지 상품 이미지는 "N"으로 설정
			if(i==0)
				itemImg.setRepimgYn("Y");
			else
				itemImg.setRepimgYn("N");
			// 상품의 이미지 정보를 저장
			itemImgService.saveItemImg(itemImg, itemImgFileList.get(i));
		}
		return item.getId();
	}
	
	
	@Transactional(readOnly=true)		// 상품 데이터를 읽어오는 트랜젝션을 읽기 전용을 설정하면 JPA가 더티체킹(변경감지)을 수행하지 않아서 성능이 향상
	public ItemFormDto getItemDtl(Long itemId) {
		
		List<ItemImg> itemImgList = itemImgRepository.findByItemIdOrderByIdAsc(itemId);
		List<ItemImgDto> itemImgDtoList = new ArrayList<>();
		for (ItemImg itemImg : itemImgList) {
			ItemImgDto itemImgDto = ItemImgDto.of(itemImg);
			itemImgDtoList.add(itemImgDto);
		}
		
		Item item = itemRepository.findById(itemId).orElseThrow(EntityNotFoundException::new);
		ItemFormDto itemFormDto = ItemFormDto.of(item);
		itemFormDto.setItemImgDtoList(itemImgDtoList);
		
		return itemFormDto;
	}
	
	
	public Long updateItem(ItemFormDto itemFormDto, List<MultipartFile> itemImgFileList) throws Exception{
        //상품 수정
        Item item = itemRepository.findById(itemFormDto.getId())
                .orElseThrow(EntityNotFoundException::new);
        item.updateItem(itemFormDto);
        List<Long> itemImgIds = itemFormDto.getItemImgIds();

        //이미지 등록
        for(int i=0;i<itemImgFileList.size();i++){
            itemImgService.updateItemImg(itemImgIds.get(i),
                    itemImgFileList.get(i));
        }

        return item.getId();
    }
	
	
	@Transactional(readOnly=true)
	public Page<Item> getAdminItemPage(ItemSearchDto itemSearchDto, Pageable pageable) {
		return itemRepository.getAdminItemPage(itemSearchDto, pageable);
	}
	
	
	//메인페이지 보여줄 상품 데이터를 조회
	public Page<MainItemDto> getMainItemPage(ItemSearchDto itemSearchDto, Pageable pageable){
		return itemRepository.getMainItemPage(itemSearchDto, pageable);
	}

	
    public void ItemDelete(Item item) {
        this.itemRepository.delete(item);
    }
	
	
}
