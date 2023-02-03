package com.shop.mall.entity;

import com.shop.mall.constant.ItemSellStatus;
import com.shop.mall.dto.ItemFormDto;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name="item")
@Getter
@Setter
@ToString
public class Item extends BaseEntity{
	
    @Id
    @Column(name="item_id")
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;    //상품코드

    @Column(nullable= false, length=50)
    private String itemNm; //상품명

    @Column(name="price", nullable=false)
    private int price;  // 가격

    @Column(nullable=false)
    private int stockNumber;    // 재고수량

    @Lob
    @Column(nullable=false)
    private String itemDetail;  //상품 상세 설명

    @Enumerated(EnumType.STRING)
    private ItemSellStatus itemSellStatus;  //상품 판매 상태
    
    
    public void updateItem(ItemFormDto itemFormDto) {
    	this.itemNm = itemFormDto.getItemNm();
    	this.price = itemFormDto.getPrice();
    	this.stockNumber = itemFormDto.getStockNumber();
    	this.itemDetail = itemFormDto.getItemDetail();
    	this.itemSellStatus = itemFormDto.getItemSellStatus();
    }

}
