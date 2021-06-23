package com.djt.api.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * Home 配置
 *
 * @author 　djt317@qq.com
 * @since 　 2021-06-22
 */
@Component
@ConfigurationProperties(prefix = "home")
@Data
public class HomeConfig {

    /**
     * 省份
     */
    private String province;
    /**
     * 城市
     */
    private String city;
    /**
     * 描述
     */
    private String desc;

}
