package com.djt.api.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 测试 Controlle
 *
 * @author 　djt317@qq.com
 * @since 　 2021-06-22
 */
@RestController
public class HelloController {

    @RequestMapping("/")
    public String index() {
        return "Hello World.";
    }

}