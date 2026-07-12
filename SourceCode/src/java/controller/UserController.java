package controller;

import dao.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "UserController", urlPatterns = {"/admin/users"})
public class UserController extends HttpServlet {
    
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {     
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        List<User> userList = userDAO.findAllUsers();
        request.setAttribute("adminUserList", userList);       
        request.getRequestDispatcher("user.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {       
        String action = request.getParameter("action");        
        if ("toggleStatus".equals(action)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String currentStatus = request.getParameter("status");
                String newStatus = "ACTIVE".equals(currentStatus) ? "LOCKED" : "ACTIVE";
                if (userDAO.updateUserStatus(userId, newStatus)) {
                    response.sendRedirect(request.getContextPath() + "/admin/users?msg=update_success");
                } 
                else {
                    response.sendRedirect(request.getContextPath() + "/admin/users?error=failed");
                }
            } 
            catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/admin/users?error=invalid_id");
            }
        } 
        else {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
}