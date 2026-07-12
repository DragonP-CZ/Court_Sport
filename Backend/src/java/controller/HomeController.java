package controller;

import dao.FieldDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Field;

@WebServlet(name = "HomeController", urlPatterns = {"/home", ""}) 
public class HomeController extends HttpServlet {

    private final FieldDAO fieldDAO = new FieldDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); 
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0); 
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            String categoryIdParam = request.getParameter("categoryId");
            int categoryId = 0;            
            if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
                categoryId = Integer.parseInt(categoryIdParam.trim());
            }
            List<Field> availableFields;
            if (categoryId == 0) {              
                availableFields = fieldDAO.findAll();
            } 
            else {             
                availableFields = fieldDAO.findAllByCategoryId(categoryId);
            }
            request.setAttribute("availableFields", availableFields);
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } 
        catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=SystemError");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}