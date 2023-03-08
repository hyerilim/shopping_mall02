<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 상세보기 페이지 -->
<script type="text/javascript">
	// 배너 목록
	function bannerList() {
		location.href = "/banner/list?page="+"${page}";
	}

	// 배너 수정
	function bannerUpdatePage() {
		location.href = "/banner/update/" + "${banner.bannerId}";
	}

	// 배너 종류 값(상세보기 페이지)
	var bannerKindValue = "${banner.bannerKind}";
	console.log("bannerKindValue : " + bannerKindValue);

	// DB에서 불러온 값과 같은 값을 가진 radio 버튼 checked 속성 넣기 
	$("input[name='bannerKind']").each(function() {
		console.log($(this).val());
		if ($(this).val() == bannerKindValue) {
			$(this).attr('checked', true);
		}

	});
	

	
</script>