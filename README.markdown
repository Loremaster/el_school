**E-school** project.

**Installtion notes**

1) Install gems and make sure that tests pass:

```shell
 $ bundle install
 $ rake db:create:all
 $ rake db:migrate
 $ rake db:test:prepare
 $ rake spec
```

2) Launch app:

```shell
 $ rails s
```

3) Also you probably'd like to use .rvmrc file to set correct version. To use it you should do that:

```shell
 $ cd this_app
 $ rvm rvmrc trust DIR
```

4) You can view erd-diagramm of the project in app/erd.pdf. If you want to generate newer version make sure
   that you installed `Graphviz 2.22` and then run in terminal `bundle exec erd`
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

- Bumped to Rails 3.2.11
- Using twitter bootstrap via gem.
- New rake:db tasks.
- Switched to PostgreSQL.
- Added password encryption/decryption in User table.

------------------------------------------------------------------------------

**Bugs**

- Huge bug fixed with Zentest. To do that you should upgrade rubygems: `gem update --system 1.8.25`

