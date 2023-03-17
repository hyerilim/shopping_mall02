package com.shop.mall.entity;

import static com.querydsl.core.types.PathMetadataFactory.*;

import com.querydsl.core.types.dsl.*;

import com.querydsl.core.types.PathMetadata;
import javax.annotation.processing.Generated;
import com.querydsl.core.types.Path;
import com.querydsl.core.types.dsl.PathInits;


/**
 * QItem is a Querydsl query type for Item
 */
@Generated("com.querydsl.codegen.DefaultEntitySerializer")
public class QItem extends EntityPathBase<Item> {

    private static final long serialVersionUID = 1070633167L;

    public static final QItem item = new QItem("item");

    public final QBaseEntity _super = new QBaseEntity(this);

    public final ListPath<CartItem, QCartItem> cartItem = this.<CartItem, QCartItem>createList("cartItem", CartItem.class, QCartItem.class, PathInits.DIRECT2);

    //inherited
    public final StringPath createdBy = _super.createdBy;

    public final NumberPath<Long> id = createNumber("id", Long.class);

    public final StringPath itemDetail = createString("itemDetail");

    public final ListPath<ItemImg, QItemImg> itemImg = this.<ItemImg, QItemImg>createList("itemImg", ItemImg.class, QItemImg.class, PathInits.DIRECT2);

    public final StringPath itemNm = createString("itemNm");

    public final EnumPath<com.shop.mall.constant.ItemSellStatus> itemSellStatus = createEnum("itemSellStatus", com.shop.mall.constant.ItemSellStatus.class);

    //inherited
    public final StringPath modifiedBy = _super.modifiedBy;

    public final ListPath<OrderItem, QOrderItem> orderItem = this.<OrderItem, QOrderItem>createList("orderItem", OrderItem.class, QOrderItem.class, PathInits.DIRECT2);

    public final NumberPath<Integer> price = createNumber("price", Integer.class);

    //inherited
    public final DateTimePath<java.time.LocalDateTime> regTime = _super.regTime;

    public final NumberPath<Integer> stockNumber = createNumber("stockNumber", Integer.class);

    //inherited
    public final DateTimePath<java.time.LocalDateTime> updateTime = _super.updateTime;

    public QItem(String variable) {
        super(Item.class, forVariable(variable));
    }

    public QItem(Path<? extends Item> path) {
        super(path.getType(), path.getMetadata());
    }

    public QItem(PathMetadata metadata) {
        super(Item.class, metadata);
    }

}

