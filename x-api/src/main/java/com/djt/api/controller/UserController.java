package com.djt.api.controller;

import com.djt.api.entity.User;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * @author 　djt317@qq.com
 * @since 　 2021-06-22
 */
@RestController
@RequestMapping(value = "/users")
public class UserController {

    /**
     * 创建线程安全的Map，模拟users信息的存储
     */
    private static final Map<Long, User> USERS = Collections.synchronizedMap(new HashMap<>());

    /**
     * 处理"/users/"的GET请求，用来获取用户列表
     */
    @GetMapping("/")
    public List<User> getUserList() {
        // 还可以通过@RequestParam从页面中传递参数来进行查询条件或者翻页信息的传递
        return new ArrayList<>(USERS.values());
    }

    /**
     * 处理"/users/"的POST请求，用来创建User
     *
     * @param user user
     */
    @PostMapping("/")
    public String postUser(@RequestBody User user) {
        // @RequestBody注解用来绑定通过http请求中application/json类型上传的数据
        USERS.put(user.getId(), user);
        return "success";
    }

    /**
     * 处理"/users/{id}"的GET请求，用来获取url中id值的User信息
     *
     * @param id id
     */
    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id) {
        // url中的id可通过@PathVariable绑定到函数的参数中
        return USERS.get(id);
    }

    /**
     * 处理"/users/{id}"的PUT请求，用来更新User信息
     *
     * @param id   id
     * @param user user
     */
    @PutMapping("/{id}")
    public String putUser(@PathVariable Long id, @RequestBody User user) {
        User u = USERS.get(id);
        u.setName(user.getName());
        u.setAge(user.getAge());
        USERS.put(id, u);
        return "success";
    }

    /**
     * 处理"/users/{id}"的DELETE请求，用来删除User
     *
     * @param id id
     */
    @DeleteMapping("/{id}")
    public String deleteUser(@PathVariable Long id) {
        USERS.remove(id);
        return "success";
    }

}