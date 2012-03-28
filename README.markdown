**E-school** project.

------------------------------------------------------------------------------

**Teacher phones**

- Show errors.
- Saving to DB.
- Added forms. 
- Basic tests for validations.

------------------------------------------------------------------------------

**Teacher education**

- Show errors.
- Saving to DB.
- Added forms for that.
- Basic tests for validations.

------------------------------------------------------------------------------

**Teacher**

- Now we can create basic teacher - saving user and teacher models.
- Test for teacher model (no integration tests).

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

**Database**

- Switched to PostgreSQL.

------------------------------------------------------------------------------

**Other**

- Added password encryption/decryption in User table.
- Updated to Rails 3.2

------------------------------------------------------------------------------

