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
            			<div class="panel-heading">
            				Board List Page
            				<button id="regBtn" type="button" class="btn btn-xs pull-right">Register New Board</button>
            			</div>
            			<div class="panel-body">
            				<table class="table table-striped table-bordered table-hover">
            					<thead>
            						<tr>
            							<th>#번호</th>
            							<th>제목</th> 
            							<th>작성자</th> 
            							<th>작성일</th> 
            							<th>수정일</th>            							
            						</tr>
            					</thead>    
            					
            					<c:forEach items="${list }" var="board">
            						<tr>
            							<td><c:out value="${board.bno }"/></td>
            							<td><a class="move" href="<c:out value='${board.bno }'/>"><c:out value="${board.title }"/> <b>[<c:out value="${board.replyCnt }" />]</b></a></td>
            							<td><c:out value="${board.writer }"/></td>
            							<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate }"/></td>
            							<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate }"/></td>
            						</tr>
            					</c:forEach>
            				</table>
            			</div>
            		</div>
            	</div>
            </div>
            
            <div class="row">
            	<div class="col-lg-12">
            		<form id="searchForm" action="/board/list" method="get">
            			<select name="type">
            				<option value="" <c:out value="${pageMaker.cri.type == null ? 'selected' : '' }"/>>--</option>
            				<option value="T" <c:out value="${pageMaker.cri.type == 'T' ? 'selected' : '' }"/>>제목</option>
            				<option value="C" <c:out value="${pageMaker.cri.type == 'C' ? 'selected' : '' }"/>>내용</option>
            				<option value="W" <c:out value="${pageMaker.cri.type == 'W' ? 'selected' : '' }"/>>작성자</option>
            				<option value="TC" <c:out value="${pageMaker.cri.type == 'TC' ? 'selected' : '' }"/>>제목 or 내용</option>
            				<option value="TW" <c:out value="${pageMaker.cri.type == 'TW' ? 'selected' : '' }"/>>제목 or 작성자</option>
            				<option value="TCW" <c:out value="${pageMaker.cri.type == 'TCW' ? 'selected' : '' }"/>>제목 or 내용 or 작성자</option>
            			</select>
            			
            			<input type="text" name="keyword" value="<c:out value='${pageMaker.cri.keyword }'/>">
            			<input type="hidden" name="pageNum" value="<c:out value='${pageMaker.cri.pageNum }'/>">
            			<input type="hidden" name="amount" value="<c:out value='${pageMaker.cri.amount }'/>">
            			<button class="btn btn-default">Search</button>
            		</form>
            	</div>
            </div>
            
            <div class="row">
            	<div class="col-lg-12">
					<div class="pull-right">
					    <ul class="pagination">
					        <c:if test="${pageMaker.prev }">
					            <li class="paginate_button previous">
					                <a href="<c:out value='${pageMaker.startPage - 1 }' />">Previous</a>
					            </li>
					        </c:if>
					
					        <c:forEach begin="${pageMaker.startPage }" end="${pageMaker.endPage }" var="num">
					            <li class="paginate_button <c:out value='${pageMaker.cri.pageNum == num ? " active" : "" }' />">
					            <a href="<c:out value='${num }'/>">${num }</a>
					            </li>
					        </c:forEach>
					
					        <c:if test="${pageMaker.next }">
					            <li class="paginate_button next">
					                <a href="<c:out value='${pageMaker.endPage + 1 }' />">Next</a>
					            </li>
					        </c:if>
					
					        <form id="actionForm" action="/board/list" method="get">
					            <input type="hidden" name="pageNum" value="<c:out value='${pageMaker.cri.pageNum }'/>">
					            <input type="hidden" name="amount" value="<c:out value='${pageMaker.cri.amount }' />">
					            <input type="hidden" name="type" value="<c:out value='${pageMaker.cri.type }'/>">
					            <input type="hidden" name="keyword" value="<c:out value='${pageMaker.cri.keyword }'/>">
					        </form>
					    </ul>
					</div>            	
            	</div>
            </div>
            
			<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-lebelledby="myModalLabel" aria-hidden="true">
			    <div class="modal-dialog">
			        <div class="modal-content">
			            <div class="modal-header">
			                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			                <h4 class="modal-title" id="myModalLabel">Modal title</h4>
			            </div>
			            <div class="modal-body">처리가 완료되었습니다.</div>
			            <div class="modal-footer">
			                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			                <button type="button" class="btn btn-primary">Save changes</button>
			            </div>
			        </div>
			    </div>
			</div>            
            
<script>
$(function() {
	function checkModal(result) {
		// 현재 페이지의 history에 obj가 있을시 리턴
		if (result === "" || history.state) {
			return;
		}
		
		if (parseInt(result) > 0) {
			$(".modal-body").html("게시글 " + parseInt(result) + " 번이 등록되었습니다.");
		}
		
		$("#myModal").modal("show");
	}
	
	const result = "<c:out value='${result}' />";	
	
	checkModal(result);
	
	// 현재 페이지의 history에 obj 추가
	history.replaceState({}, null, null);
	
	$("#regBtn").on("click", function() {
		self.location = "/board/register";
	});
	
	const actionForm = $("#actionForm");
	
	// 페이징 처리된 버튼 클릭시 해당 페이지의 목록을 가지고옴
	$(".paginate_button a").on("click", function(e) {
		e.preventDefault();
		
		console.log("click");
		
		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		actionForm.submit();
	});
	
	// 페이징 처리후 게시물 조회하고 목록페이지 이동시 전에 보던 페이지번호의 정보가 보이게 처리함
	$(".move").on("click", function(e) {
		e.preventDefault();
		const bno = $(this).attr("href");
		// hidden태그에 게시물 번호 세팅
		actionForm.append("<input type='hidden' name='bno' value='"+bno+"' />");
		// actionForm 이동 경로를 조회페이지로 세팅
		actionForm.attr("action", "/board/get");
		actionForm.submit();
	});
	
	const searchForm = $("#searchForm");
	
	// 검색 버튼 클릭시 검색 처리
	$("#searchForm button").on("click", function(e) {
		e.preventDefault();
		
		if (!searchForm.find("option:selected").val()) {
			alert("검색종류를 선택하세요.");
			return false;
		}
		
		if (!searchForm.find("input[name='keyword']").val()) {
			alert("키워드를 입력하세요.");
			return false;
		}
		
		searchForm.find("input[name='pageNum']").val("1");
		searchForm.submit();
	});
});
</script>
<%@ include file="../includes/footer.jsp" %>