@WebServlet("/ChatbotServlet")
public class ChatbotServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String query = request.getParameter("query").toLowerCase();
        String answer = "Xin lỗi, mình chưa hiểu ý bạn. Bạn có thể hỏi về [bảo trì] hoặc [giá sân].";

        if (query.contains("bảo trì")) {
            answer = "Sân 3 đang bảo trì từ 12h-14h hằng ngày nhé!";
        } else if (query.contains("giá")) {
            answer = "Giá sân trung bình là 25.000đ/giờ. Bạn có thể xem bảng giá chi tiết ở tab đặt sân.";
        }

        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(answer);
    }
}