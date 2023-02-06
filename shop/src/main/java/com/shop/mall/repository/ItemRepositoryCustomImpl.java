package com.shop.mall.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.util.StringUtils;

import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.shop.mall.constant.ItemSellStatus;
import com.shop.mall.dto.ItemSearchDto;
import com.shop.mall.entity.Item;
import com.shop.mall.entity.QItem;

import jakarta.persistence.EntityManager;

public class ItemRepositoryCustomImpl implements ItemRepositoryCustom {
	
	private JPAQueryFactory queryFactory;
	
	public ItemRepositoryCustomImpl(EntityManager em) {
		this.queryFactory = new JPAQueryFactory(em);
	}
	
	private BooleanExpression searchSellStatusEq(ItemSellStatus searchSellStatus) {
		return searchSellStatus == null ? null : QItem.item.itemSellStatus.eq(searchSellStatus);
	}
	
	private BooleanExpression regDtsAfter(String searchDateType) {
		LocalDateTime dateTime = LocalDateTime.now();
		
		if(StringUtils.pathEquals("all", searchDateType) || searchDateType == null) {
			return null;
		} else if (StringUtils.pathEquals("1d", searchDateType)) {
			dateTime = dateTime.minusDays(1);
		} else if (StringUtils.pathEquals("1w", searchDateType)) {
			dateTime = dateTime.minusWeeks(1);
		} else if(StringUtils.pathEquals("1m", searchDateType)) {
			dateTime = dateTime.minusMonths(1);
		} else if(StringUtils.pathEquals("6m", searchDateType)) {
			dateTime = dateTime.minusMonths(6);
		}
		return QItem.item.regTime.after(dateTime);
	}
	
	private BooleanExpression searchByLike(String searchBy, String searchQuery) {
		
		if(StringUtils.pathEquals("itemNm", searchBy)) {
			return QItem.item.itemNm.like("%"+searchQuery+"%");
		} else if(StringUtils.pathEquals("createdBy", searchBy)) {
			return QItem.item.createdBy.like("%"+searchQuery+"%");
		}
		return null;
	}
	
	@Override
	public Page<Item> getAdminItemPage(ItemSearchDto itemSearchDto, Pageable pageable) {
		List<Item> results = queryFactory
				.selectFrom(QItem.item)
				.where(regDtsAfter(itemSearchDto.getSearchDateType())
						, searchSellStatusEq(itemSearchDto.getSearchSellStatus())
						, searchByLike(itemSearchDto.getSearchBy(),
				itemSearchDto.getSearchQuery()))
							.orderBy(QItem.item.id.desc())
							.offset(pageable.getOffset())
							.limit(pageable.getPageSize())
							.fetch();

				return new PageImpl<>(results , pageable, results.size());
	}
}
