package com.djt.utils;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import lombok.extern.log4j.Log4j2;
import org.apache.commons.lang3.StringUtils;

/**
 * 数据转换提取工具类
 *
 * @author 　djt317@qq.com
 * @since 　 2021-02-04
 */
@Log4j2
public class DataParseUtils {

    /**
     * 转换字符串为json对象
     *
     * @param str 字符串
     * @return json
     */
    public static JSONObject parseJsonObject(String str) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject = JSON.parseObject(str);
        } catch (Exception e) {
            log.error("Json转换失败:{}", e.getMessage());
        }
        return jsonObject;
    }

    /**
     * 从Json对象中获取Long类型值
     *
     * @param jsonObject json
     * @param key        key
     * @return long
     */
    public static Long getNumFromJson(JSONObject jsonObject, String key) {
        if (null == jsonObject || !jsonObject.containsKey(key)) {
            return 0L;
        }
        String value = jsonObject.getString(key);
        if (StringUtils.isNumeric(value)) {
            return Long.parseLong(value);
        }
        return 0L;
    }
}
