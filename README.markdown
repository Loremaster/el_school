**E-school** project.


------------------------------------------------------------------------------

**Class head**

- Creating events for class_head's class.

------------------------------------------------------------------------------

**School head**

- Creating/editing timetables.
- Creating/editing parents.
- Creating/editing orders.
- Now he can filter users by class.
- Creating/editing classes (class code, date of creating, and class head for this class).
  - NOTICE! If you choose pupils for one class and these pupils were already in other class
    then they'll be only in this class!
- Creating/editing subjects.
- Choosing subjects for teachers.
- Creating/editing pupils.
- Creating/editing class heads.

------------------------------------------------------------------------------

**Teacher**

- Can log-in.

------------------------------------------------------------------------------

**Admin**

- Admin now can update user login/pass.
- Now we can also add teacher phones.
- Added new method to show error messages of User, Teacher, Teacher education.
- Now we can also fill forms of teacher education.
- Date validation - format dd.mm.yyyy and date existance. Checking via method of controller (i didn't find good method for that).
- Keep data in forms even if user did some mistakes. Added for that some tests.
- Added russian error messages for creation of User. All errors in schoolhead popup as flash message.
and contains russian words. For translation words i use locale, it set as :en (default). 
- Added password and login generation (for class head). Plus some tests for that.
- Redirect admin from root of site to his list of users.
- Redirect admin after signing-in to his page.
- Added links (with active states) in admin toolbar.
- Added beginner signing in.
- Added rights to view admin page only by admin.


------------------------------------------------------------------------------

**Other**

- New rake:db tasks.
- Switched to PostgreSQL.
- Added password encryption/decryption in User table.
- Updated to Rails 3.2
- Libraries updated.

------------------------------------------------------------------------------

**Bugs**

------------------------------------------------------------------------------

**TODO**

- Test events on school head page.
- Rewrite admin controller.
- Remove choosing sex by default for all controller which use that.