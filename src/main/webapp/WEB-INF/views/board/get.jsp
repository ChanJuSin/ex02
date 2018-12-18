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
            				
            				<sec:authentication property="principal" var="pinfo" />
            				<sec:authorize access="isAuthenticated()">
            					<c:if test="${pinfo.username eq board.writer }">
            						<button data-oper='modify' class="btn btn-default">Modify</button>
            					</c:if>
            				</sec:authorize>
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
								<input type="hidden" name="type" value="<c:out value='${cri.type }'/>">
								<input type="hidden" name="keyword" value="<c:out value='${cri.keyword }'/>">
							</form>
            			</div>
            		</div>
            	</div>
            </div>
            
            <div class="row">
            	<div class="col-lg-12">
            		<div class="panel panel-default">
            			<div class="panel-heading">
            				<i class="fa fa-comments fa-fw"></i> Reply
            				<sec:authorize access="isAuthenticated()">
            					<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New Reply</button>
            				</sec:authorize>
            			</div>
            			
            			<div class="panel-body">
            				<ul class="chat"></ul>
            			</div>
            			
            			<div class="panel-footer">
            			
            			</div>
            		</div>
            	</div>
            </div>
            
            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            	<div class="modal-dialog">
            		<div class="modal-content">
            			<div class="modal-header">
            				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            				<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
            			</div>
            			
            			<div class="modal-body">
            				<div class="form-group">
            					<label>Replyer</label>
            					<input class="form-control" name="replyer" value="replyer" readonly="readonly">
            				</div>
            				
            				<div class="form-group">
            					<label>Reply</label>
            					<input class="form-control" name="reply" value="New Reply!!">
            				</div>
            				
            				<div class="form-group">
            					<label>Reply Date</label>
            					<input class="form-control" name="replyDate" value="">
            				</div>
            			</div>
            			
            			<div class="modal-footer">
            				<button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
            				<button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
            				<button id="modalRegisterBtn" type="button" class="btn btn-primary">Register</button>
            				<button id="modalCloseBtn" type="button" class="btn btn-default">Close</button>
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
            				<div class="uploadResult">
            					<ul></ul>
            				</div>
            			</div>
            		</div>
            	</div>
            </div>
<script src="/resources/js/reply.js"></script>
<script>
	const csrfHeaderName = "${_csrf.headerName}";
	const csrfTokenValue = "${_csrf.token}";

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
		
		const bnoValue = "<c:out value='${board.bno}'/>";
		const replyUL = $(".chat");
		
		// 댓글 목록 페이지에 해당하는 댓글 리스트를 가져와 댓글 목록 뷰를 생성하여 뿌려줌
		function showList(page) {
			replyService.getList({bno: bnoValue, page: page || 1}, function(replyCnt, list) {
				let str = "";
				
				if (page === -1) {
					pageNum = Math.ceil(replyCnt / 10.0);
					showList(pageNum);
					return;
				}
				
				if (list === null || list.length === 0) {
					return;
				}
				
				for (let i = 0, len = list.length || 0; i < len; i++) {
					str += "<li class='left clearfix' data-rno=" + list[i].rno + ">";
					str += "	<div>";
					str += "		<div class='header'>";
					str += "			<strong class='primary-font'>" + list[i].replyer + "</strong>";
					str += "			<small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small>";
					str += "		</div>";
					str += "		<p>" + list[i].reply + "</p>";
					str += "	</div>";
					str += "</li>";
				}

				replyUL.html(str);
				showReplyPage(replyCnt);
			});
		}
		
		let pageNum = 1;
		const replyPageFooter = $(".panel-footer");
		
		// 댓글 목록 페이징 처리
		function showReplyPage(replyCnt) {
			let endNum = Math.ceil(pageNum / 10.0) * 10;
			let startNum = endNum - 9;
			let prev = startNum != 1;
			let next = false;
			
			if (endNum * 10 >= replyCnt) {
				endNum = Math.ceil(replyCnt / 10.0);
			}
			
			if (endNum * 10 < replyCnt) {
				next = true;
			}
			
		 	let str = "<ul class='pagination pull-right'>"
		 	
		 	if (prev) {
		 		str += "<li calss='page-item'>";
		 		str += "	<a class='page-link' href=" + (startNum -1) + ">Previous</a>";
		 		str += "</li>";
		 	}
		 	
		 	for (let i = startNum; i <= endNum; i++) {
		 		let active = pageNum == i ? "active" : "";
		 		
				str += "<li class='page-item "+active+"'>";
				str += "	<a class='page-link' href=" + i + ">" + i +  "</a>";
				str += "</li>";
		 	}
		 	
		 	if (next) {
		 		str += "<li class='page-item'>";
		 		str += "	<a class='page-link' href=" + (endNum + 1) + ">Next</a>";
		 		str += "</li>";
		 	}
		 	
		 	str += "</ul>";
		 	replyPageFooter.html(str);
		}
		showList(1);
		
		// 페이징 처리된 a 태그 클릭 처리
		replyPageFooter.on("click", "li a", function(e) {
			e.preventDefault();
			const targetPageNum = $(this).attr("href");
			pageNum = targetPageNum;
			showList(pageNum);
		});
		
		const modal = $(".modal");
		const modalInputReply = modal.find("input[name='reply']");
		const modalInputReplyer = modal.find("input[name='replyer']");
		const modalInputReplyDate = modal.find("input[name='replyDate']");
		const modalModBtn = $("#modalModBtn");
		const modalRemoveBtn = $("#modalRemoveBtn");
		const modalRegisterBtn = $("#modalRegisterBtn");
		const modalCloseBtn = $("#modalCloseBtn");
		
		let replyer;
		
		<sec:authorize access="isAuthenticated()">
			replyer = "<sec:authentication property='principal.username'/>";
		</sec:authorize>
		
		// 댓글등록 모달창 show
		$("#addReplyBtn").on("click", function() {
			modal.find("input").val("");
			modal.find("input[name='replyer']").val(replyer);
			modalInputReplyDate.closest("div").hide();
			modal.find("button[id != 'modalCloseBtn']").hide();
			modalRegisterBtn.show();
			modal.modal("show");
		});
		
		// 댓글 모달창 close
		modalCloseBtn.on("click", function() {
			modal.modal("hide");
		});
		
		// 댓글 등록 처리
		modalRegisterBtn.on("click", function() {
			const reply = {
					reply: modalInputReply.val(),
					replyer: modalInputReplyer.val(),
					bno: bnoValue
			};
			
			replyService.add(reply, function(result) {
				alert(result);
				modal.find("input").val("");
				modal.modal("hide");
				showList(-1);
			});
		});
		
		// 댓글 조회 처리
		$(".chat").on("click", "li", function() {
			const rno = $(this).data("rno");
			replyService.get(rno, function(reply) {
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
				modal.data("rno", reply.rno);
				modal.find("button[id != 'modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				modal.modal("show");
			});
		});
		
		// 댓글 수정 처리
		modalModBtn.on("click", function() {
			const originalReplyer = modalInputReplyer.val();
			
			const reply = {
					rno: modal.data("rno"),
					reply: modalInputReply.val(),
					replyer: originalReplyer
			};
			
			if (replyer != originalReplyer) {
				alert("자신이 작성한 댓글만 수정이 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			replyService.update(reply, function(result) {
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
		// 댓글 삭제 처리
		modalRemoveBtn.on("click", function() {
			const originalReplyer = modalInputReplyer.val();
			
			const rno = modal.data("rno");
			
			if (replyer != originalReplyer) {
				alert("자신이 작성한 댓글만 삭제가 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			replyService.remove(rno, originalReplyer, function(result) {
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
		const bno = "<c:out value='${board.bno}' />";
		
		$.getJSON("/board/getAttachList", {bno: bno}, function(arr) {
			let str = "";
			
			$(arr).each(function(i , attach) {
				let fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
				
				if (attach.fileType) {
					str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'>";
					str += "	<div>";
					str += "		<span>" + attach.fileName + "</span><br/>";
					str += "		<img src='/display?fileName="+fileCallPath+"'>";
					str += "	</div>";
					str += "</li>";
				} else {
					str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"'>";
					str += "	<div>";
					str += "		<span>" + attach.fileName + "</span><br/>";
					str += "		<img src='/resources/img/attach.png'>";
					str += "	</div>";
					str += "</li>";
				}
			});
			
			$(".uploadResult ul").html(str);
		});
		
		function showImage(fileCallPath) {
			$(".bigPictureWrapper").css("display", "flex").show();
			$(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"'>").animate({width: "100%", height: "100%"}, 1000);
		}
		
		$(".uploadResult").on("click", "li", function() {
			const li = $(this);
			const path = encodeURIComponent(li.data("path") + "/" + li.data("uuid") + "_" + li.data("filename"));
			
			if (li.data("type")) {
				showImage(path.replace(new RegExp(/\\/g), "/"));
			} else {
				self.location = "/download?fileName=" + path;
			}
		});
		
		$(".bigPictureWrapper").on("click", function() {
			$(".bigPicture").animate({width: "0%", height: "0%"}, 1000);
			setTimeout(function() {
				$(".bigPictureWrapper").hide();
			}, 1000);
		});
	});
	
	$(document).ajaxSend(function(e, xhr, options) {
		xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	});
</script>
<%@ include file="../includes/footer.jsp" %>