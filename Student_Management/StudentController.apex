public class StudentController {

    // Object for Form
    public Student__c stu { get; set; }

    // List for Table
    public List<Student__c> studentList { get; set; }

    // Edit Mode Boolean
    public Boolean isEdit { get; set; }

    // Selected Student Id
    public Id selectedStudentId { get; set; }

    // Constructor
    public StudentController() {

        stu = new Student__c();

        isEdit = false;

        getStudents();
    }

    // Fetch Student Records
    public void getStudents() {

        studentList = [
            SELECT Id,
                   Name,
                   Roll_No__c,
                   Class__c,
                   Mobile__c,
                   Email__c
            FROM Student__c
            ORDER BY Roll_No__c
        ];
    }

    // Save or Update Student
    public PageReference saveStudent() {

        try {

            // Update Existing Record
            if(isEdit) {

                update stu;

                ApexPages.addMessage(
                    new ApexPages.Message(
                        ApexPages.Severity.CONFIRM,
                        'Student Updated Successfully!'
                    )
                );

            }
            // Insert New Record
            else {

                insert stu;

                ApexPages.addMessage(
                    new ApexPages.Message(
                        ApexPages.Severity.CONFIRM,
                        'Student Saved Successfully!'
                    )
                );
            }

            // Reset Form
            stu = new Student__c();

            isEdit = false;

            // Refresh Table
            getStudents();

        }
        catch(Exception e) {

            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    e.getMessage()
                )
            );
        }

        return null;
    }

    // Edit Student
    public void editStudent() {

        stu = [
            SELECT Id,
                   Name,
                   Roll_No__c,
                   Class__c,
                   Mobile__c,
                   Email__c
            FROM Student__c
            WHERE Id = :selectedStudentId
            LIMIT 1
        ];

        isEdit = true;
    }

    // Delete Student
    public void deleteStudent() {

        Student__c s = [
            SELECT Id
            FROM Student__c
            WHERE Id = :selectedStudentId
            LIMIT 1
        ];

        delete s;

        ApexPages.addMessage(
            new ApexPages.Message(
                ApexPages.Severity.CONFIRM,
                'Student Deleted Successfully!'
            )
        );

        getStudents();
    }

    // Cancel Edit
    public void cancelEdit() {

        stu = new Student__c();

        isEdit = false;
    }
}
