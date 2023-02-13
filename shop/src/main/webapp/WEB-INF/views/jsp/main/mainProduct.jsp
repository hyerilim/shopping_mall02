<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <meta id="_csrf" name="_csrf" content="${_csrf.token}">
		<meta id="_csrf_header" name="_csrf_header"
				content="${_csrf.headerName}">
        <title>상품 리스트</title>
        <!-- Favicon-->
        <link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
        <!-- Bootstrap icons-->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet" />
        <!-- Core theme CSS (includes Bootstrap)-->

    </head>
    <body>
    
    <jsp:include page="../nav.jsp"></jsp:include>
    
        <!-- Navigation-->
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <div class="container px-4 px-lg-5">
                <a class="navbar-brand" href="#!">Start Bootstrap</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                        <li class="nav-item"><a class="nav-link active" aria-current="page" href="#!">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="#!">About</a></li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">Shop</a>
                            <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <li><a class="dropdown-item" href="#!">All Products</a></li>
                                <li><hr class="dropdown-divider" /></li>
                                <li><a class="dropdown-item" href="#!">Popular Items</a></li>
                                <li><a class="dropdown-item" href="#!">New Arrivals</a></li>
                            </ul>
                        </li>
                    </ul>
                    <form class="d-flex">
                        <button class="btn btn-outline-dark" type="submit">
                            <i class="bi-cart-fill me-1"></i>
                            Cart
                            <span class="badge bg-dark text-white ms-1 rounded-pill">0</span>
                        </button>
                    </form>
                </div>
            </div>
        </nav>
        <!-- Header-->
        <header class="bg-dark py-5">
            <div class="container px-4 px-lg-5 my-5">
                <div class="text-center text-white">
                    <h1 class="display-4 fw-bolder">Shop in style</h1>
                    <p class="lead fw-normal text-white-50 mb-0">With this shop hompeage template</p>
                </div>
            </div>
        </header>

        <!-- Section  리스트-->
        <div class="py-5">
            <div class="container px-4 px-lg-5 mt-5">
                
                <form>
                <div class="mx-quto input-group mb-5">
                	<input id="searchQuery" name="searchQuery" type="text" class="form-control mr-sm-2" placeholder="상품명 검색">
					<button id="searchBtn" type="submit" class="btn btn-outline-success my-2 my-sm-0">검색</button>
                </div>
                </form>
                
                <input type="hidden" name="searchQuery" value="${itemSearchDto.searchQuery}">
					<c:if test="${not empty itemSearchDto.searchQuery}">
					<p>'${itemSearchDto.searchQuery}' 검색결과</p>
				</c:if>
                
                <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-start">
                <c:forEach var="item" items="${items.getContent()}" varStatus="status">
                <input type="hidden" id="itemId" value="${item.id}">  
                <input type="hidden" id="count" value="1">  
                    <div class="col mb-5">
                        <div class="card h-100">
                            <!-- Product image-->
                        <a href="/item/${item.id}">상세
                        	<img class="card-img-top" src="${item.imgUrl}" alt="..." />
                       	</a>
                            <!-- Product details-->
                            <div class="card-body p-4">
                                <div class="text-center">
                                    <!-- Product name-->
                                    <h5 class="fw-bolder">${item.itemNm}</h5>
                        
                                    <!-- Product price-->
                                    가격 : ${item.price} 원
                                </div>
                            </div>
                            <!-- Product actions-->
                            <div class="card-footer p-4 pt-0 border-top-0 bg-transparent">
                                <div class="text-center">
                                    <a class="btn btn-outline-dark mt-auto" href="javascript:void(0);" onclick="addCart()">장바구니</a>
                                    <a class="btn btn-outline-dark mt-auto" href="javascript:void(0);" onclick="order()">구매하기</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    </c:forEach>
                    </div>
	페이징
                </div>
            </div>
        

        
            <!-- Footer-->
        <footer class="py-5 bg-dark">
            <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2022</p></div>
        </footer>
        <!-- Bootstrap core JS-->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Core theme JS-->
<script src="${pageContext.request.contextPath}/resources/js/cart.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/order.js"></script>       
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.6.3.js"></script>

    </body>
</html>
