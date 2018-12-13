package org.zerock.util;

import java.io.File;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.Date;

public class RelatedFileUtil {

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
	
}
