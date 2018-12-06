<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>    
    
<%@ include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Tables</h1>
                </div>
            </div>
            
            <div class="row">
            	<div class="col-lg-12">
            		<div class="panel panel-default">
            			<div class="panel-heading">Board Register</div>
            			<div class="panel-body">
            				<form role="form" action="/board/modify" method="post">
	            				<div class="form-group">
	            					<label>Bno</label>
	            					<input type="text" class="form-control" name="bno" value="<c:out value='${board.bno }'/>" readonly="readonly">
	            				</div>
	            				
	            				<div class="form-group">
	            					<label>Title</label>
	            					<input type="text" class="form-control" name="title" value="<c:out value='${board.title }'/>">
	            				</div>
	            				
	            				<div class="form-group">
	            					<label>Text area</label>
	            					<textarea class="form-control" rows="3" name="content"><c:out value="${board.content }" /></textarea>
	            				</div>
	            				
	            				<div class="form-group">
	            					<label>Writer</label>
	            					<input type="text" class="form-control" name="writer" value="<c:out value='${board.writer }'/>">
	            				</div>
	            				
	            				<div class="form-group">
	            					<label>RegDate</label>
	            					<input type="text" class="form-control" name="regDate" value="<fmt:formatDate pattern="yyyy/MM/dd" value='${board.regdate }' />" readonly >
	            				</div>
	            				
	            				<div class="form-group">
	            					<label>Update Date</label>
	            					<input type="text" class="form-control" name="regDate" value="<fmt:formatDate pattern="yyyy/MM/dd" value='${board.updateDate }' />" readonly >
	            				</div>
	            				
	      						<!-- 
	      							pageNum과 amount는 페이징 처리를 한뒤에 
									3페이지에서 게시글을 조회후 게시글 수정페이지에서 다시 목록페이지로 이동할때 전에 보던 3페이지를 
									다시 보여주기 위해서 필요하다.
									또한 수정, 삭제후에도 전에보던 3페이지를 보여주기 위해서 필요하다.
	      						 -->
	            				<input type="hidden" name="pageNum" value="<c:out value='${cri.pageNum }'/>">
	            				<input type="hidden" name="amount" value="<c:out value='${cri.amount }'/>">
	            				<input type="hidden" name="type" value="<c:out value='${cri.type }'/>">
	            				<input type="hidden" name="keyword" value="<c:out value='${cri.keyword }'/>">
	            				
	            				<button type="submit" data-oper="modify" class="btn btn-default">Modify</button>
	            				<button type="submit" data-oper="remove" class="btn btn-danger">Remove</button>
	            				<button type="submit" data-oper="list" class="btn btn-info">List</button>
            				</form>
            			</div>
            		</div>
            	</div>
            </div>
            
<script>
$(function() {
	const formObj = $("form");
	
	$("button").on("click", function(e) {
		e.preventDefault();
		
		const operation = $(this).data("oper");
		
		console.log(operation);
		
		if (operation === "remove") {
			formObj.attr("action", "/board/remove");
		} else if (operation === "list") { 
			// 게시물 목록 이동
			formObj.attr("action", "/board/list").attr("method", "get");
			
			// 게시물 목록 이동시 필요한 페이지 데이터 태그 복사
			const pageNumTag = $("input[name='pageNum']").clone();
			const amountTag = $("input[name='amount']").clone();
			const typeTag = $("input[name='type']").clone();
			const keywordTag = $("input[name='keyword']").clone();
			
			// 태그의 내용을 지운다. 요소 태그는 남아있음
			formObj.empty();
			// 페이지 데이터 태그 추가
			formObj.append(pageNumTag);
			formObj.append(amountTag);
			formObj.append(typeTag);
			formObj.append(keywordTag);
		} 
		
		formObj.submit();
	});
});
</script>            
<%@ include file="../includes/footer.jsp" %>