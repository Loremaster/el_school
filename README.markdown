**E-school** project.

-----------------------------------------------------------------------------

**Parent**

- Can view Meetings.
- Can view Events.
- Can view journal of his children for chosen subject.

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
- Can create/update and see dates of lessons.
- Can create/update pupils attendances.
- Can create/update pupils estimations.
- Can create/update pupils results.
- Can create/update homeworks.

------------------------------------------------------------------------------

**Admin**

- Can create backup and restore system from backup.
- Admin now can update user login/pass.
- Can create teacher and school head.


------------------------------------------------------------------------------

**Other**

- New rake:db tasks.
- Switched to PostgreSQL.
- Added password encryption/decryption in User table.
- Updated to Rails 3.2
- Libraries updated.

------------------------------------------------------------------------------

**Bugs**

- Huge bug fixed with Zentest. To do that you should upgrade rubygems: `gem update --system 1.8.25`

