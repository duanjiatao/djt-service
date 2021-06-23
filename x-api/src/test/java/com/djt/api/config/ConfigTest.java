package com.djt.api.config;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

/**
 * @author 　djt317@qq.com
 * @since 　 2021-06-22
 */
@SpringBootTest
public class ConfigTest {

    @Autowired
    private HomeConfig homeConfig;

    @Test
    public void testHomeConfig() {
        System.out.println(homeConfig);
    }

}
