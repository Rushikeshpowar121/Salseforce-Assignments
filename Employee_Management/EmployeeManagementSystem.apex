public class EmployeeManagementSystem {

    // DISPLAY MENU
    public static void showMenu() {

        System.debug('==============================');
        System.debug(' EMPLOYEE MANAGEMENT SYSTEM ');
        System.debug('==============================');
        System.debug('1. Add Employee');
        System.debug('2. View Employees');
        System.debug('3. Update Employee');
        System.debug('4. Delete Employee');
        System.debug('==============================');
    }

    // ADD EMPLOYEE
    public static void addEmployee(
        String empName,
        Integer empId,
        String email,
        Date dob,
        String department
    ) {

        Employee__c emp = new Employee__c();

        emp.Name = empName;
        emp.Emp_ID__c = empId;
        emp.Email__c = email;
        emp.DOB__c = dob;
        emp.Department__c = department;

        insert emp;

        System.debug('Employee Added Successfully!');
    }

    // VIEW EMPLOYEES
    public static void viewEmployees() {

        List<Employee__c> empList = [

            SELECT Id,
                   Name,
                   Emp_ID__c,
                   Email__c,
                   DOB__c,
                   Department__c
            FROM Employee__c
            ORDER BY Emp_ID__c

        ];

        System.debug('========== EMPLOYEE RECORDS ==========');

        if(empList.isEmpty()) {

            System.debug('No Employee Records Found');
        }

        for(Employee__c emp : empList) {

            System.debug(

                'Emp ID : ' + emp.Emp_ID__c +
                ' | Name : ' + emp.Name +
                ' | Email : ' + emp.Email__c +
                ' | DOB : ' + emp.DOB__c +
                ' | Department : ' + emp.Department__c

            );
        }
    }

    // UPDATE EMPLOYEE
    public static void updateEmployee(
        Integer empId,
        String newDepartment,
        String newEmail
    ) {

        List<Employee__c> empList = [

            SELECT Id,
                   Department__c,
                   Email__c
            FROM Employee__c
            WHERE Emp_ID__c = :empId
            LIMIT 1

        ];

        if(empList.isEmpty()) {

            System.debug('Employee Not Found');
            return;
        }

        Employee__c emp = empList[0];

        emp.Department__c = newDepartment;
        emp.Email__c = newEmail;

        update emp;

        System.debug('Employee Updated Successfully!');
    }

    // DELETE EMPLOYEE
    public static void deleteEmployee(Integer empId) {

        List<Employee__c> empList = [

            SELECT Id
            FROM Employee__c
            WHERE Emp_ID__c = :empId
            LIMIT 1

        ];

        if(empList.isEmpty()) {

            System.debug(' Employee Not Found');
            return;
        }

        delete empList[0];

        System.debug('Employee Deleted Successfully!');
    }
}

























































// SHOW MENU
//EmployeeManagementSystem.showMenu();

// OPTION 1 → ADD EMPLOYEE
//EmployeeManagementSystem.addEmployee(
//    'Aarav Sharma',
//    104,
//    'aarav104@gmail.com',
//    Date.newInstance(2002,8,15),
//    'Finance'
//);

// OPTION 2 → VIEW EMPLOYEES
//EmployeeManagementSystem.viewEmployees();

// OPTION 3 → UPDATE EMPLOYEE
//EmployeeManagementSystem.updateEmployee(
//    104,
//    'Marketing',
//    'aarav.updated@gmail.com'
//);

// OPTION 4 → DELETE EMPLOYEE
//EmployeeManagementSystem.deleteEmployee(104);

// VIEW AGAIN
//EmployeeManagementSystem.viewEmployees();
