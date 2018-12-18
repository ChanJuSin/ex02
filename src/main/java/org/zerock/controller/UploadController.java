package org.zerock.controller;


import java.io.File;
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;
import org.zerock.util.RelatedFileUtil;

import net.coobird.thumbnailator.Thumbnailator;


@Controller
public class UploadController {
	
	@RequestMapping("hello")
	public @ResponseBody String hello() {
		return "hello";
	}

	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	public @ResponseBody ResponseEntity<List<AttachFileDTO>> uploadAjaxAction(MultipartFile[] uploadFile) throws Exception {
		List<AttachFileDTO> list = new ArrayList<>();
			 
		File fileUploadPath = new File(RelatedFileUtil.UPLOAD_FOLDER, RelatedFileUtil.getFolder());
		if (fileUploadPath.exists() == false) {
			fileUploadPath.mkdirs();
		}
			
		for (MultipartFile multipartFile : uploadFile) {
			AttachFileDTO attachFileDTO = new AttachFileDTO();
			
			String fileName = multipartFile.getOriginalFilename();
			fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
			attachFileDTO.setFileName(fileName);
			
			UUID uuid = UUID.randomUUID();
			String uplaodFileName = uuid.toString() + "_" + fileName;
			
			File saveFile = new File(fileUploadPath, uplaodFileName);
			multipartFile.transferTo(saveFile);
			
			attachFileDTO.setUuid(uuid.toString());
			attachFileDTO.setUploadPath(RelatedFileUtil.getFolder());
			
			if (RelatedFileUtil.checkImageType(saveFile)) {
				attachFileDTO.setImage(true);
				FileOutputStream thumbnail = new FileOutputStream(new File(fileUploadPath, "s_" + uplaodFileName));
				Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
				thumbnail.close();
			}
			
			list.add(attachFileDTO);
		}
		
		return new ResponseEntity<List<AttachFileDTO>>(list, HttpStatus.OK);
	}
	
	@GetMapping("/display")
	public @ResponseBody ResponseEntity<byte[]> getFile(String fileName) throws Exception {
		File file = new File(RelatedFileUtil.UPLOAD_FOLDER + fileName);
		
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", Files.probeContentType(file.toPath()));
		
		return new ResponseEntity<byte[]>(FileCopyUtils.copyToByteArray(file), headers, HttpStatus.OK);
	}
	
	/*
	 * 	파일 삭제
	 * 	@params String fileName, String fileType	
	 */
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/deleteFile")
	public @ResponseBody ResponseEntity<String> deleteFile(@RequestParam Map<String, String> fileInfo) throws Exception {
		File thumbNailFile = new File(RelatedFileUtil.UPLOAD_FOLDER, URLDecoder.decode(fileInfo.get("fileName"), "UTF-8"));
		thumbNailFile.delete();
		
		if (fileInfo.get("fileType").equals("image")) {
			String originalFilePath = thumbNailFile.getAbsolutePath().replace("s_", "");
			File originalFile = new File(originalFilePath);
			originalFile.delete();
		}
		
	    return new ResponseEntity<> ("deleted", HttpStatus.OK);
	}
	
	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
    public @ResponseBody ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName) {
	    Resource resource = new FileSystemResource(RelatedFileUtil.UPLOAD_FOLDER + fileName);
	    if (resource.exists() == false) {
	        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

	    String resourceName = resource.getFilename();
	    String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);
	    HttpHeaders headers = new HttpHeaders();

	    try {
	        String downloadName = null;

	        if (userAgent.contains("Trident")) {
	            downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replace("\\+", " ");
            } else if (userAgent.contains("Edge")) {
	            downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
            } else {
	            downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
            }

	    	headers.add("Content-Disposition", "attachment; filename=" + downloadName);
		} catch (UnsupportedEncodingException e) {
	    	e.printStackTrace();
		}
	    return new ResponseEntity<>(resource, headers, HttpStatus.OK);
    }
	
}
