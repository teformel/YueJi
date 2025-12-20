package com.yueji.common;

import com.google.gson.Gson;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class ResponseUtils {
    private static final Gson gson = new Gson();

    public static void writeJson(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }

    public static void writeJson(HttpServletResponse response, int code, String msg, Object data) throws IOException {
        Result result = new Result(code, msg, data);
        writeJson(response, result);
    }

    public static class Result {
        private int code;
        private String msg;
        private Object data;

        public Result(int code, String msg, Object data) {
            this.code = code;
            this.msg = msg;
            this.data = data;
        }
        // Getters ... to save checking Gson uses fields directly? No, Gson uses fields.
        // But for safety let's add no-args and getters if needed.
        // Gson can serialize private fields.
    }
}
