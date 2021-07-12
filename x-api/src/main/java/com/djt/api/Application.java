package com.djt.api;

import lombok.extern.log4j.Log4j2;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;


/**
 * 服务启动类
 *
 * @author 　djt317@qq.com
 * @since 　 2021-06-21
 */
@Log4j2
@SpringBootApplication
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
        log.info("服务已启动...");
    }

}
