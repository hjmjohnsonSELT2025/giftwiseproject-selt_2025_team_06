---
name: Login User Story
about: Create connextra style user story for logging into an account
title: 'Login to Account'
labels: ['user-story', 'login']
assignees: 'CJ Tobler'
---

**As a busy mother,**

**I want to be able to log in to my account to view all of the events assigned to me,**

**So that I can get access to all of my events that I will be attending.**

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

# <span style="color:#e63946;">Scenario:</span> Successful Login
<span style="color:#3a86ff;">When</span> I enter <span style="color:#3a8600;">Username65</span> in the username box  
<span style="color:#3a86ff;">And</span> I enter <span style="color:#3a8600;">Pass65</span> in the password box  
<span style="color:#3a86ff;">And</span> I press the **“Log In”** button  
<span style="color:#3a86ff;">Then</span> I should be taken to the **home page**  
<span style="color:#3a86ff;">And</span> I should be logged in as <span style="color:#3a8600;">Username65</span>

---

# <span style="color:#e63946;">Scenario:</span> Unsuccessful Login - Password
<span style="color:#3a86ff;">When</span> I enter <span style="color:#3a8600;">Username65</span> in the username box  
<span style="color:#3a86ff;">And</span> I enter <span style="color:#3a8600;">Pass32</span> in the password box  
<span style="color:#3a86ff;">And</span> I press the **“Log In”** button  
<span style="color:#3a86ff;">Then</span> I should remain on the **login page**  
<span style="color:#3a86ff;">And</span> I should see **"Incorrect password"**

---

# <span style="color:#e63946;">Scenario:</span> Unsuccessful Login - Username
<span style="color:#3a86ff;">When</span> I enter <span style="color:#3a8600;">unknown32</span> in the username box  
<span style="color:#3a86ff;">And</span> I enter <span style="color:#3a8600;">Pass32</span> in the password box  
<span style="color:#3a86ff;">And</span> I press the **“Log In”** button  
<span style="color:#3a86ff;">Then</span> I should remain on the **login page**  
<span style="color:#3a86ff;">And</span> I should see **"Username doesn't exist"**