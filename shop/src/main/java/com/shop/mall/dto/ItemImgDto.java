package com.shop.mall.dto;

import org.modelmapper.ModelMapper;

import com.shop.mall.entity.ItemImg;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ItemImgDto {

    private Long id;

    private String imgName; //이미지 파일명

    private String oriImgName;  //원본 이미지 파일명

    private String imgUrl;  //이미지 조회 경로

    private String repimgYn;    // 대표이미지 여부
    
    // 서로 다른 클래스의 값을 필드의 이름과 자료형이 같으면 getter, setter를 통해 값을 복사해서 객체를 반환
    // 멤버 변수로 ModelMapper 객체를 주가
    private static ModelMapper modelMapper = new ModelMapper();
    // ItemImg 엔티티 객체를 파라미터로 받아서 ItemImg 객체의 자료형과 멤버변수의 이름이 같을 때 ItemImgDto로 값을 복사해서 반환
    // static 메소드로 선언해 ItemImgDto 객체를 생성하지 않아도 호출
    public static ItemImgDto of(ItemImg itemImg) {
    	return modelMapper.map(itemImg,ItemImgDto.class);
    }
}
