package controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "AuthController", urlPatterns = {"/auth"})
public class AuthController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");       
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/home");
        } 
        else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        if ("login".equals(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            User user = userDAO.login(email, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                if (user.getRoleId() == 1) {
                    System.out.println("[AUTH LOG] Tai khoan ADMIN '" + user.getEmail() + "' dang nhap thanh cong. Dieu huong ve /admin.");
                    response.sendRedirect(request.getContextPath() + "/admin");
                } 
                else {
                    System.out.println("[AUTH LOG] Tai khoan USER '" + user.getEmail() + "' dang nhap thanh cong. Dieu huong ve /home.");
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            } 
            else {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=InvalidCredentials");
            }
        } 
        else if ("register".equals(action)) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            User newUser = new User();
            newUser.setFullName(fullName);
            newUser.setPhone(phone != null ? phone.trim() : "");
            newUser.setEmail(email != null ? email.trim() : "");
            newUser.setPasswordHash(password != null ? password.trim() : ""); 
            if (userDAO.register(newUser)) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=RegisterSuccess");
            } 
            else {
                response.sendRedirect(request.getContextPath() + "/register.jsp?error=RegisterFail");
            }
        }
    }
}