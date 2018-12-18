<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>     
<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-itmes: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
	align-content: center;
	text-align: center;
}

.uploadResult ul li img {
	width: 100px;
}

.uploadResult ul li span {
	color: white;
}

.bigPictureWrapper {
	position: absolute;
	display: none;
	justify-content: center;
	align-items: center;
	top: 0%;
	width: 100%;
	height: 100%;
	background-color: gray;
	z-index: 100;
	background: rgba(255, 255, 255, 0.5);
}

.bigPicture {
	position: relative;
	display: flex;
	justify-content: center;
	align-items: center;
}

.bigPicture img {
	width: 600px;
}
</style>        
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
	            				
	            				<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
	            				
	            				<sec:authentication property="principal" var="pinfo" />
	            				<sec:authorize access="isAuthenticated()">
	            					<c:if test="${pinfo.username eq board.writer }">
		            					<button type="submit" data-oper="modify" class="btn btn-default">Modify</button>
		            					<button type="submit" data-oper="remove" class="btn btn-danger">Remove</button>
	            					</c:if>
	            				</sec:authorize>
	            				<button type="submit" data-oper="list" class="btn btn-info">List</button>
            				</form>
            			</div>
            		</div>
            	</div>
            </div>
            
             <div class="bigPictureWrapper">
            	<div class="bigPicture"></div>
            </div>
            
            <div class="row">
            	<div class="col-lg-12">
            		<div class="panel panel-default">
            			<div class="panel-heading">Files</div>
            			<div class="panel-body">
            				<div class="form-group uploadDiv">
            					<input type="file" name='uploadFile' multiple>
            				</div>
            				
            				<div class="uploadResult">
            					<ul></ul>
            				</div>
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
		}  else if (operation === "modify") {
			let str = "";
			
			$(".uploadResult ul li").each(function(i, obj) {
				const li = $(obj);
				str += "<input type='hidden' name='attachVOList["+i+"].fileName' value='"+li.data('filename')+"'>";
				str += "<input type='hidden' name='attachVOList["+i+"].uuid' value='"+li.data('uuid')+"'>";
				str += "<input type='hidden' name='attachVOList["+i+"].uploadPath' value='"+li.data('path')+"'>";
				str += "<input type='hidden' name='attachVOList["+i+"].fileType' value='"+li.data('type')+"'>";
			});
			
			formObj.append(str).submit();
		}
		
		formObj.submit();
	});
	
	const bno = "<c:out value='${board.bno}'/>";
	$.getJSON("/board/getAttachList", {bno: bno}, function(arr) {
		let str = "";
		
		$(arr).each(function(i, attach) {
			let fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
			
			if (attach.fileType) {
				str += "<li style='display: inline-block; margin-left: 5px;' data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'>";
				str += "	<div>";
				str += "		<span>" + attach.fileName + "</span>";
                str += "		<button type='button' data-file='"+fileCallPath+"' data-type='image' class='btn btn-warning btn-circle'>";
                str += "			<i class='fa fa-times'></i>"
                str += "		</button><br>";
                str += "		<img src='/display?fileName="+fileCallPath+"'>";
                str += "	</div>";
				str += "</li>";
			} else {
				str += "<li style='display: inline-block; margin-left: 5px;' data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'>";
				str += "	<div>";
				str += "		<span>" + attach.fileName + "</span>";
				str += "		<button type='button' data-file='"+fileCallPath+"' data-type='file' class='btn btn-warning btn-circle'>";
				str += "			<i class='fa fa-times'></i>";
				str += "		</button><br>";
				str += "		<img src='/resources/img/attach.png' style='height: 100px; width: 100px;'>";
				str += "	</div>";
				str += "</li>";
			}
			
			$(".uploadResult ul").html(str);
		});
	});
	
	$(".uploadResult").on("click", "button", function() {
		if (confirm("Remove this file?")) {
			const targetLi = $(this).closest("li");
			targetLi.remove();
		}
	});
	
	const regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	const maxSize = 5242880; // 5MB
	
	function checkExtension(fileName, fileSize) {
		if (fileSize >= maxSize) {
			alert("파일 사이즈 초과");
			return false;
		}
		
		if (regex.test(fileName)) {
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		return true;
	}
	
	function showUploadedFile(uploadResultArr) {
		if (!uploadResultArr || uploadResultArr.length === 0) {
			return;
		}
		
		const thumbnailTarget = $(".uploadResult ul");
		let str = "";
		
		$(uploadResultArr).each(function(i, obj) {
            let fileCallPath = "";
			if (obj.image) {
				fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
				str += "<li style='display: inline-block; margin-left: 5px;' data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'>";
				str += "	<div>";
				str += "		<span>" + obj.fileName + "</span>";
                str += "		<button type='button' data-file='"+fileCallPath+"' data-type='image' class='btn btn-warning btn-circle'>";
                str += "			<i class='fa fa-times'></i>"
                str += "		</button><br>";
                str += "		<img src='/display?fileName="+fileCallPath+"' style='height: 100px; width: 100px;'>";
                str += "	</div>";
				str += "</li>";
			} else {
				fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
				const fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
				
				str += "<li style='display: inline-block; margin-left: 5px;' data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'>";
				str += "	<div>";
				str += "		<span>" + obj.fileName + "</span>";
				str += "		<button type='button' data-file='"+fileCallPath+"' data-type='file' class='btn btn-warning btn-circle'>";
				str += "			<i class='fa fa-times'></i>";
				str += "		</button><br>";
				str += "		<img src='/resources/img/attach.png' style='height: 100px; width: 100px;'>";
				str += "	</div>";
				str += "</li>";
			}
		});
		
		thumbnailTarget.append(str);
	}
	
	const csrfHeaderName = "${_csrf.headerName}";
	const cstfTokenValue = "${_csrf.token}";
	const cloneUploadDiv = $(".uploadDiv").clone();
	$("body").on("change", "input[type=file]", function(e) {
		const formData = new FormData();
		const inputFile = $("input[name='uploadFile']");
		const file = inputFile[0].files;
		
		if (!checkExtension(file[0].name, file[0].size)) {
			return false;
		}
		formData.append("uploadFile", file[0]);

		$.ajax({
			method: "post",
			url: "/uploadAjaxAction",
			data: formData,
			beforeSend: function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, cstfTokenValue);
			},
			processData: false,
			contentType: false,
			success: function(result) {
				showUploadedFile(result);
				$(".uploadDiv").html(cloneUploadDiv.html());
			}
		});
	});
});
</script>            
<%@ include file="../includes/footer.jsp" %>