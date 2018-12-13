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
            				<form role="form" action="/board/register" method="post">
            					<div class="form-group">
            						<label>Title</label>
            						<input type="text" class="form-control" name="title">
            					</div>
            					
            					<div class="form-group">
            						<label>Text area</label>
            						<textarea class="form-control" rows="3" name="content"></textarea>
            					</div>
            					
            					<div class="form-group">
            						<label>Writer</label>
            						<input type="text" class="form-control" name="writer">
            					</div>
            					
            					<button type="submit" class="btn btn-default">Submit Button</button>
            					<button type="reset" class="btn btn-default">Reset Button</button>
            				</form>
            			</div>
            		</div>
            	</div>
            </div>

			<div class="row">
				<div class="col-lg12">
					<div class="panel panel-default">
						<div class="panel-heading">File Attach</div>
						<div class="panel-body">
							<div class="form-group uploadDiv">
								<input type="file" name="uploadFile" multiple>
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
				str += "		<buton type='button' data-file='"+fileCallPath+"' data-type='file' class='btn btn-warning btn-circle'>";
				str += "			<i class='fa fa-times'></i>";
				str += "		</button><br>";
				str += "		<img src='/resources/img/attach.png' style='height: 100px; width: 100px;'>";
				str += "	</div>";
				str += "</li>";
			}
		});
		
		thumbnailTarget.append(str);
	}
	
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
			processData: false,
			contentType: false,
			success: function(result) {
				showUploadedFile(result);
				$(".uploadDiv").html(cloneUploadDiv.html());
			}
		});
	});
	
	const formObj = $("form[role='form']");
	$("button[type='submit']").on("click", function(e) {
		e.preventDefault();
		
		let str = "";
		
		$(".uploadResult ul li").each(function(i, obj) {
			const li = $(obj);
			
			str += "<input type='hidden' name='attachVOList["+i+"].fileName' value='"+li.data("filename")+"'>";
			str += "<input type='hidden' name='attachVOList["+i+"].uuid' value='"+li.data("uuid")+"'>";
			str += "<input type='hidden' name='attachVOList["+i+"].uploadPath' value='"+li.data("path")+"'>";
			str += "<input type='hidden' name='attachVOList["+i+"].fileType' value='"+li.data("type")+"'>";
		});
		
		formObj.append(str).submit();
	});
	
	$(".uploadResult").on("click", "button", function(e) {
		const targetFile = $(this).data("file");
		const type = $(this).data("type");
		const targetLi = $(this).closest("li");
		
		$.ajax({
			method: "post",
			url: "/deleteFile",
			data: {
				fileName: targetFile,
				fileType: type
			},
			success: function(result) {
				targetLi.remove();
			}
		});
	});
});
</script>
<%@ include file="../includes/footer.jsp" %>