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
            				<div class="form-group">
            					<label>Bno</label>
            					<input type="text" class="form-control" name="bno" value="<c:out value='${board.bno }'/>" readonly="readonly">
            				</div>
            				
            				<div class="form-group">
            					<label>Title</label>
            					<input type="text" class="form-control" name="title" value="<c:out value='${board.title }'/>" readonly="readonly">
            				</div>
            				
            				<div class="form-group">
            					<label>Text area</label>
            					<textarea class="form-control" rows="3" name="content" readonly="readonly"><c:out value="${board.content }" /></textarea>
            				</div>
            				
            				<div class="form-group">
            					<label>Writer</label>
            					<input type="text" class="form-control" name="writer" value="<c:out value='${board.writer }'/>" readonly="readonly">
            				</div>
            				
            				<button data-oper='modify' class="btn btn-default">Modify</button>
							<button data-oper='list' class="btn btn-info">List</button>
							
							<form id="operForm" action="/board/modify" method="get">
								<input type="hidden" id="bno" name="bno" value="<c:out value='${board.bno}'/>">
								<!-- 
									pageNum과 amount는 페이징 처리를 한뒤에 
									3페이지에서 게시글을 조회후 목록페이지로 이동할때 전에 보던 3페이지를 
									다시 보여주기 위해서 필요하다.
								 -->
								<input type="hidden" name="pageNum" value="<c:out value='${cri.pageNum }'/>">
								<input type="hidden" name="amount" value="<c:out value='${cri.amount }'/>">
							</form>
            			</div>
            		</div>
            	</div>
            </div>
<script>
	$(function() {
		const operForm = $("#operForm");
		
		$("button[data-oper='modify']").on("click", function(e) {
			operForm.attr("action", "/board/modify").submit();
		});
		
		$("button[data-oper='list']").on("click", function(e) {
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list");
			operForm.submit();
		});
	});
</script>
<%@ include file="../includes/footer.jsp" %>