package com.cnblogs.hoojo.fabric.app;

import com.google.common.base.Optional;
import com.google.common.base.Preconditions;
import okhttp3.*;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.util.Strings;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class AppRequestServlet extends HttpServlet {

	private static final long serialVersionUID = 5957612323202932473L;
	
	private static final String REMOTE_URL = "http://localhost:4000/";
    private static final OkHttpClient client = new OkHttpClient();
    private static final MediaType JSON = MediaType.parse("application/json; charset=utf-8");
    private static final MediaType FORM = MediaType.parse("application/x-www-form-urlencoded; charset=utf-8");
    
    private static String serverURL;

    @Override
    public void init(ServletConfig config) throws ServletException {
    	super.init(config);
    	
    	serverURL = Optional.<String>fromNullable(config.getInitParameter("SERVER_URL")).or(REMOTE_URL);
    }

    private void write(HttpServletResponse resp, String text) throws IOException {
        PrintWriter out = resp.getWriter();

        out.write(text);

        out.flush();
        out.close();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


        try {
            String action = req.getParameter("action");
            Preconditions.checkArgument(!Strings.isBlank(action), "参数 action 不能为空");

            if (StringUtils.contains(action, "users")) {
                String params = req.getParameter("params");

                write(resp, post(action, params));
            } else {
                String token = req.getParameter("token");
                String json = req.getParameter("json");

                Preconditions.checkArgument(!Strings.isBlank(token), "参数 token 不能为空");
                Preconditions.checkArgument(!Strings.isBlank(action), "参数 json 不能为空");

                write(resp, post(action, token, json));
            }
        } catch (Exception e) {
            write(resp, e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


        try {
            String action = req.getParameter("action");
            String token = req.getParameter("token");

            Preconditions.checkArgument(!Strings.isBlank(action), "参数 action 不能为空");
            Preconditions.checkArgument(!Strings.isBlank(token), "参数 token 不能为空");

            write(resp, this.get(action, token));
        } catch (Exception e) {
            write(resp, e.getMessage());
        }
    }


    private String get(String action, String token) throws Exception {
        Request request = new Request.Builder()
                .addHeader("authorization", token)
                .addHeader("content-type", "application/json")
                .url(serverURL + action)
                .build();

        Response response = client.newCall(request).execute();
        return response.body().string();
    }


    private String post(String action, String token, String json) throws Exception {

        RequestBody body = RequestBody.create(JSON, json);

        Request request = new Request.Builder()
                .addHeader("authorization", token)
                .url(serverURL + action)
                .post(body)
                .build();

        Response response = client.newCall(request).execute();

        return response.body().string();
    }

    private String post(String action, String params) throws Exception {
        RequestBody body = RequestBody.create(FORM, params);

        Request request = new Request.Builder()
                .url(serverURL + action)
                .post(body)
                .build();

        Response response = client.newCall(request).execute();

        return response.body().string();
    }
}
