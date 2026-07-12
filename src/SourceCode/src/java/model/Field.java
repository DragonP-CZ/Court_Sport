package model;

import java.io.Serializable;

public class Field implements Serializable {
    private int fieldId;
    private int categoryId;
    private String fieldName;
    private double pricePerSlot;
    private String status;
    private String description;
    private String categoryName; 

    public Field() {}
    public int getFieldId() { return fieldId; }
    public void setFieldId(int fieldId) { this.fieldId = fieldId; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getFieldName() { return fieldName; }
    public void setFieldName(String fieldName) { this.fieldName = fieldName; }

    public double getPricePerSlot() { return pricePerSlot; }
    public void setPricePerSlot(double pricePerSlot) { this.pricePerSlot = pricePerSlot; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
}