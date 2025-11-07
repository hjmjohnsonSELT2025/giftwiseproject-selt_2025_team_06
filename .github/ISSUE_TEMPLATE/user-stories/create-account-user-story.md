---
name: Create Account User Story
about: Create connextra style user story for account creation
title: 'Create an Account'
labels: ['user-story', 'registration']
assignees: 'CJ Tobler'
---

**As a busy mother,**

**I want to have an account on this site for my tracking,**

**So that I can properly plan the right gifts for all of those I know.**

---

### **Background**
Users have already been added to the database.

### **Given**
The following users exist:

| username   | password |
|-------------|----------|
| Username65  | Pass65   |
| Username32  | Pass32   |
| Username40  | Pass40   |

---

# <span style="color:#e63946;">Scenario:</span> Invalid Password in Account Creation
<span style="color:#3a86ff;">When</span> I am on the **create account page**  
<span style="color:#3a86ff;">And</span> I enter all of my credentials  
<span style="color:#3a86ff;">And</span> I enter my password as <span style="color:#3a8600;">pass</span>   
<span style="color:#3a86ff;">Then</span> I press the **“Submit”** button  
<span style="color:#3a86ff;">Then</span> I should get an error: **"Password invalid"**

---

# <span style="color:#e63946;">Scenario:</span> No Password in Account Creation
<span style="color:#3a86ff;">When</span> I am on the **create account page**  
<span style="color:#3a86ff;">And</span> I enter all of my credentials  
<span style="color:#3a86ff;">And</span> I leave the password empty  
<span style="color:#3a86ff;">Then</span> I press the **“Submit”** button  
<span style="color:#3a86ff;">Then</span> I should get an error: **"Password invalid"**

---

# <span style="color:#e63946;">Scenario:</span> DOB Missing in Account Creation
<span style="color:#3a86ff;">When</span> I am on the **create account page**  
<span style="color:#3a86ff;">And</span> I enter all of my credentials  
<span style="color:#3a86ff;">And</span> I leave the DOB empty  
<span style="color:#3a86ff;">Then</span> I press the **“Submit”** button  
<span style="color:#3a86ff;">Then</span> I should get an error: **"DOB empty"**

---

# <span style="color:#e63946;">Scenario:</span> Hobbies Empty in Account Creation
<span style="color:#3a86ff;">When</span> I am on the **create account page**  
<span style="color:#3a86ff;">And</span> I enter all of my credentials  
<span style="color:#3a86ff;">And</span> I leave the hobbies empty  
<span style="color:#3a86ff;">Then</span> I press the **“Submit”** button  
<span style="color:#3a86ff;">Then</span> I should get an error: **"Hobbies empty"**

---

# <span style="color:#e63946;">Scenario:</span> Occupation Empty in Account Creation
<span style="color:#3a86ff;">When</span> I am on the **create account page**  
<span style="color:#3a86ff;">And</span> I enter all of my credentials  
<span style="color:#3a86ff;">And</span> I leave the occupation box empty  
<span style="color:#3a86ff;">Then</span> I press the **“Submit”** button  
<span style="color:#3a86ff;">Then</span> I should be taken to the **home page**  
<span style="color:#3a86ff;">And</span> I should be logged in as the new user

---

# <span style="color:#e63946;">Scenario:</span> Username Taken in Account Creation
<span style="color:#3a86ff;">When</span> I am on the **create account page**  
<span style="color:#3a86ff;">And</span> I enter all of my credentials  
<span style="color:#3a86ff;">And</span> I enter my username as <span style="color:#3a8600;">Username65</span>  
<span style="color:#3a86ff;">Then</span> I press the **“Submit”** button  
<span style="color:#3a86ff;">Then</span> I should get an error: **"Username taken"**