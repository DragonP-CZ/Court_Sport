package controller;

import dao.FieldDAO;
import dao.CategoryDAO; 
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Field;
import model.Category; 
import model.User;

@WebServlet(name = "FieldController", urlPatterns = {"/admin/fields"})
public class FieldController extends HttpServlet {
    private final FieldDAO fieldDAO = new FieldDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO(); 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=PlsLogin");
            return;
        }
        try {
            List<Field> fieldList = fieldDAO.findAll();
            request.setAttribute("adminFieldList", fieldList);
            List<Category> categoryList = categoryDAO.findAll(); 
            request.setAttribute("categoryList", categoryList);
            request.getRequestDispatcher("/admin/field.jsp").forward(request, response);           
        } 
        catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin?error=SystemFieldError");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=PlsLogin");
            return;
        }
        String action = request.getParameter("action");       
        if ("add".equals(action)) {
            try {
                String fieldName = request.getParameter("fieldName");
                int categoryId = Integer.parseInt(request.getParameter("categoryId"));
                double pricePerSlot = Double.parseDouble(request.getParameter("pricePerSlot"));
                String status = request.getParameter("status");
                String description = request.getParameter("description");
                if (fieldName == null || fieldName.trim().isEmpty() || pricePerSlot <= 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/fields?error=InvalidInput");
                    return;
                }
                Field newField = new Field();
                newField.setFieldName(fieldName);
                newField.setCategoryId(categoryId);
                newField.setPricePerSlot(pricePerSlot);
                newField.setStatus(status);
                newField.setDescription(description);
                if (fieldDAO.insert(newField)) {
                    System.out.println("[INFO LOG] Admin ID " + currentUser.getUserId() + " đã thêm mới sân đấu thành công: " + fieldName);
                    response.sendRedirect(request.getContextPath() + "/admin/fields?msg=add_success");
                } 
                else {
                    response.sendRedirect(request.getContextPath() + "/admin/fields?error=add_failed");
                }             
            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/admin/fields?error=InvalidNumber");
            }
        } 
        else if ("updateStatus".equals(action)) {
            try {
                int fieldId = Integer.parseInt(request.getParameter("fieldId"));
                String status = request.getParameter("status");
                if (fieldDAO.updateStatus(fieldId, status)) {                    
                    System.out.println("[INFO LOG] Admin ID " + currentUser.getUserId() + " đã cập nhật trạng thái Sân ID #" + fieldId + " sang: " + status);
                    response.sendRedirect(request.getContextPath() + "/admin/fields?msg=update_success");
                } 
                else {
                    response.sendRedirect(request.getContextPath() + "/admin/fields?error=update_failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/admin/fields?error=system_error");
            }
        }
        else if ("delete".equals(action)) {
            try {
                int fieldId = Integer.parseInt(request.getParameter("fieldId"));
                
                if (fieldDAO.delete(fieldId)) {              
                    System.out.println("[WARN LOG] Admin ID " + currentUser.getUserId() + " đã xóa sân đấu mang mã số ID #" + fieldId);
                    response.sendRedirect(request.getContextPath() + "/admin/fields?msg=delete_success");
                } 
                else {
                    response.sendRedirect(request.getContextPath() + "/admin/fields?error=delete_failed");
                }
            } 
            catch (Exception e) {
                e.printStackTrace();              
                response.sendRedirect(request.getContextPath() + "/admin/fields?error=foreign_key_constraint");
            }
        } 
        else {
            response.sendRedirect(request.getContextPath() + "/admin/fields");
        }
    }
}