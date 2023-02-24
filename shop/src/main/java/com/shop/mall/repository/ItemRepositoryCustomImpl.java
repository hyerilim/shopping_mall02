package com.shop.mall.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.util.StringUtils;

import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.core.types.dsl.Wildcard;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.shop.mall.constant.ItemSellStatus;
import com.shop.mall.dto.ItemSearchDto;
import com.shop.mall.dto.MainItemDto;
import com.shop.mall.dto.QMainItemDto;
import com.shop.mall.entity.Item;
import com.shop.mall.entity.QItem;
import com.shop.mall.entity.QItemImg;

import jakarta.persistence.EntityManager;

// ItemRepositoryCustom 상속
public class ItemRepositoryCustomImpl implements ItemRepositoryCustom {
	
	//동적으로 쿼리를 생성하지 위해 JPAQueryFactory 클래스 사용
	private JPAQueryFactory queryFactory;
	
	// JPAQueryFactory의 생성자로 EntityManager 객체를 넣어줌
	public ItemRepositoryCustomImpl(EntityManager em) {
		this.queryFactory = new JPAQueryFactory(em);
	}
	
	// 상품 판매 상태 조건이 전체(null)일 경우는 null을 리턴, 결과값이 null이면 where절에서 해당 조건은 무시됨.
	// 상품 판매 상태 조건이 null이 아니라 판매중 or 품절 상태라면 해당 조건의 상품만 조회
	private BooleanExpression searchSellStatusEq(ItemSellStatus searchSellStatus) {
		return searchSellStatus == null ? null : QItem.item.itemSellStatus.eq(searchSellStatus);
	}
	
	// searchDateType의 값에 따라서 dateTime의 값을 이전 시간의 값으로 세팅 후 해당 시간 이후로 등록된 상품만 조회
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
	
	// searchBy의 값에 따라서 상품명에 검색어를 포함하고 있는 상품 또는 상품 생성자의 아이디에 검색어를 포함하고 있는 상품을 조회하도록 조건값을 반환
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

        List<Item> content = queryFactory
                .selectFrom(QItem.item)
                .where(regDtsAfter(itemSearchDto.getSearchDateType()),
                        searchSellStatusEq(itemSearchDto.getSearchSellStatus()),
                        searchByLike(itemSearchDto.getSearchBy(),
                                itemSearchDto.getSearchQuery()))
                .orderBy(QItem.item.id.desc())
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        long total = queryFactory.select(Wildcard.count).from(QItem.item)
                .where(regDtsAfter(itemSearchDto.getSearchDateType()),
                        searchSellStatusEq(itemSearchDto.getSearchSellStatus()),
                        searchByLike(itemSearchDto.getSearchBy(), itemSearchDto.getSearchQuery()))
                .fetchOne()
                ;

        return new PageImpl<>(content, pageable, total);
    }
    
    
	
	//getMainItemPage 메소드 구현
	private BooleanExpression itemNmLike(String searchQuery) {
		return StringUtils.hasText(searchQuery) ? QItem.item.itemNm.like("%" + searchQuery +"%") : null;
	}
	
//	@Override
//	public Page<MainItemDto> getMainItemPage(ItemSearchDto itemSearchDto, Pageable pageable){
//		
//		QItem item = QItem.item;
//		QItemImg itemImg = QItemImg.itemImg;
//		
//		List<MainItemDto> results = queryFactory
//				.select(Projections.constructor(MainItemDto.class,
//						item.id,
//						item.itemNm, item.itemDetail,itemImg.imgUrl,item.price))
//				.from(itemImg)
//				.where(itemImg.repimgYn.eq("Y"))
//				.where(itemNmLike(itemSearchDto.getSearchQuery()))
//				.orderBy(item.id.desc())
//				.offset(pageable.getOffset())
//				.limit(pageable.getPageSize())
//				.fetch();
//
//		return new PageImpl<>( results , pageable, results.size());
//	}
	@Override
    public Page<MainItemDto> getMainItemPage(ItemSearchDto itemSearchDto, Pageable pageable) {
        QItem item = QItem.item;
        QItemImg itemImg = QItemImg.itemImg;

        List<MainItemDto> content = queryFactory
                .select(
                        new QMainItemDto(
                                item.id,
                                item.itemNm,
                                item.itemDetail,
                                itemImg.imgUrl,
                                item.price)
                )
                .from(itemImg)
                .join(itemImg.item, item)
                .where(itemImg.repimgYn.eq("Y"))
                .where(itemNmLike(itemSearchDto.getSearchQuery()))
                .orderBy(item.id.desc())
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        long total = queryFactory
                .select(Wildcard.count)
                .from(itemImg)
                .join(itemImg.item, item)
                .where(itemImg.repimgYn.eq("Y"))
                .where(itemNmLike(itemSearchDto.getSearchQuery()))
                .fetchOne()
                ;

        return new PageImpl<>(content, pageable, total);
    }
	
}
