package org.zerock.util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.zerock.domain.BoardAttachVO;

public class RelatedFileUtil {

	public static final String UPLOAD_FOLDER = "C:\\upload\\";
	
	public static String getFolder() throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator);
	}
	
	public static boolean checkImageType(File file) throws Exception {
		String contentType = Files.probeContentType(file.toPath());
		return contentType.startsWith("image");
	}
	
	public static void deleteFiles(List<BoardAttachVO> attachList) {
		if (attachList == null || attachList.size() == 0) {
			return;
		}
		
		attachList.forEach(attach -> {
			Path file = Paths.get(UPLOAD_FOLDER, attach.getUploadPath() + "\\" + attach.getUuid() + "_" + attach.getFileName());
			try {
				Files.deleteIfExists(file);
				if (Files.probeContentType(file).startsWith("image")) {
					Path thumbnail = Paths.get(UPLOAD_FOLDER + attach.getUploadPath() + "\\s_" + attach.getUuid() + "_" + attach.getFileName());
					Files.delete(thumbnail);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		});
	}
	
}
