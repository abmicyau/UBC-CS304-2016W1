package entities;

import java.util.Date;

public class Employee {

    private int empID;
    private String email;
    private Date dateOfBirth;
    private String address;
    private String name;
    private String phoneNumber;
    private String gender;
    private String sin;

    public Employee(int empID, String email, Date dateOfBirth, String address, String name, String phoneNumber, String gender, String sin) {
        this.empID = empID;
        this.email = email;
        this.dateOfBirth = dateOfBirth;
        this.address = address;
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.gender = gender;
        this.sin = sin;
    }

    public int getEmpID() {
        return empID;
    }

    public String getEmail() {
        return email;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public String getAddress() {
        return address;
    }

    public String getName() {
        return name;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public String getGender() {
        return gender;
    }

    public String getSin() {
        return sin;
    }
}
