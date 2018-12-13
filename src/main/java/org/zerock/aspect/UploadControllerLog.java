package org.zerock.aspect;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;


@Component
@Aspect
public class UploadControllerLog {

    private static final Logger log = LoggerFactory.getLogger(UploadControllerLog.class);

    @Around("execution(* org.zerock.controller.UploadController.downloadFile(..)) && args(userAgent, fileName)")
    public Object downLoadControllerLog(ProceedingJoinPoint joinPoint, String userAgent, String fileName) throws Throwable {
        log.info("==================================================================================");
        log.info("callMethod ----> " + joinPoint.getSignature());

        long startTime = System.currentTimeMillis();

        log.info("downLoadFilePath ----> " + "c:\\upload\\" + fileName);

        if (userAgent.contains("Trident")) {
            log.info("userBroswer ---->  IE");
        } else if (userAgent.contains("Edge")) {
            log.info("userBroswer ----> Edge");
        } else {
            log.info("userBroswer ----> Chrome");
        }

        Object result = joinPoint.proceed();

        long endTime = System.currentTimeMillis();
        log.info("total time ----> " + (endTime - startTime));
        log.info("==================================================================================");

        return result;
    }

}
