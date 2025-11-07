---
name: View Events User Story
about: Create connextra style user story for viewing upcoming events on the home page
title: 'View Upcoming Events from Home Page'
labels: ['user-story', 'view-events']
assignees: 'CJ Tobler'
---

**As a popular person,**

**I want to be able to view the three events with the closest upcoming dates on my home page as a means of extra notification on when they are happening,**

**So that I can keep track of all of the events I am going to.**

---

### **Background**
Events have been added to the database, and the user is attending all of them.

### **Given**
The following events exist:

| event_name     | event_date  | event_owner   | event_budget |
|----------------|--------------|----------------|----------------|
| Birthday Party | 2025-11-20   | Sarah Miller   | 50             |
| Family Dinner  | 2025-12-25   | Jame Carter    | 250            |
| Secret Santa   | 2025-12-15   | Olivia Newton  | 150            |

---

# <span style="color:#e63946;">Scenario:</span> Seeing All Events on the Home Page
<span style="color:#3a86ff;">When</span> I am on the **home page**  
<span style="color:#3a86ff;">Then</span> I should see all the events I’m registered to

---

# <span style="color:#e63946;">Scenario:</span> Viewing Events with No Gifts Bought
<span style="color:#3a86ff;">When</span> I am on the **home page**  
<span style="color:#3a86ff;">Then</span> I should see all events I’m registered to  
<span style="color:#3a86ff;">And</span> I can see which events still need gifts

---

# <span style="color:#e63946;">Scenario:</span> Seeing Role in Each Event
<span style="color:#3a86ff;">When</span> I am on the **home page**  
<span style="color:#3a86ff;">Then</span> I should see all events I’m registered to  
<span style="color:#3a86ff;">And</span> I should see my role in each event  
<span style="color:#3a86ff;">And</span> I should see the recipient if I’m a giver

---

# <span style="color:#e63946;">Scenario:</span> Seeing Budget for Each Event
<span style="color:#3a86ff;">When</span> I am on the **home page**  
<span style="color:#3a86ff;">Then</span> I should see all events I’m registered to  
<span style="color:#3a86ff;">And</span> I should see how much to spend at each event

---

# <span style="color:#e63946;">Scenario:</span> Navigating to Event from Home Page
<span style="color:#3a86ff;">When</span> I am on the **home page**  
<span style="color:#3a86ff;">Then</span> I should see all events I’m registered to  
<span style="color:#3a86ff;">And</span> when I click on an event  
<span style="color:#3a86ff;">Then</span> I should be on that event’s page
