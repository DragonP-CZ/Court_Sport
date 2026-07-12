package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Payment implements Serializable {
    private int paymentId;
    private int bookingId;
    private double amount;
    private String paymentMethod; // "CASH", "QR_CODE", "BANK_TRANSFER"
    private String paymentStatus; // "PENDING", "COMPLETED", "FAILED"
    private Timestamp paymentTime;

    public Payment() {}

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public Timestamp getPaymentTime() { return paymentTime; }
    public void setPaymentTime(Timestamp paymentTime) { this.paymentTime = paymentTime; }
}