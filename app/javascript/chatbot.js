document.addEventListener('turbo:load', function() {
    initializeChatbot();
  });
  
  document.addEventListener('DOMContentLoaded', function() {
    initializeChatbot();
  });
  
  function initializeChatbot() {
    const chatbotBtn = document.getElementById('ai-gift-ideas-btn');
    const chatbotPopup = document.getElementById('chatbot-popup');
    
    if (!chatbotBtn || !chatbotPopup) {
      return;
    }
  
    const chatbotClose = document.getElementById('chatbot-close-btn');
    const recipientSelect = document.getElementById('recipient_select');
    const recipientSelectContainer = document.getElementById('recipient-select-container');
    const chatbotMessages = document.getElementById('chatbot-messages');
    const chatbotLoading = document.getElementById('chatbot-loading');
    const eventId = window.location.pathname.split('/').pop();
  
    chatbotBtn.removeEventListener('click', handleButtonClick);
    chatbotBtn.addEventListener('click', handleButtonClick);
  
    if (chatbotClose) {
      chatbotClose.removeEventListener('click', handleCloseClick);
      chatbotClose.addEventListener('click', handleCloseClick);
    }
  
    chatbotPopup.removeEventListener('click', handlePopupClick);
    chatbotPopup.addEventListener('click', handlePopupClick);
  
    function handleButtonClick(e) {
      e.preventDefault();
      e.stopPropagation();
      chatbotPopup.classList.add('show');
      loadRecipients(eventId);
    }
  
    function handleCloseClick(e) {
      e.preventDefault();
      e.stopPropagation();
      closeChatbot();
    }
  
    function handlePopupClick(e) {
      if (e.target === chatbotPopup) {
        closeChatbot();
      }
    }
  
    function closeChatbot() {
      chatbotPopup.classList.remove('show');
      if (chatbotMessages) chatbotMessages.innerHTML = '';
      if (recipientSelectContainer) recipientSelectContainer.style.display = 'none';
      if (chatbotLoading) chatbotLoading.style.display = 'none';
    }
  
    function loadRecipients(eventId) {
      if (chatbotMessages) {
        chatbotMessages.innerHTML = '<div class="message assistant">Loading recipients...</div>';
      }
      
      fetch(`/events/${eventId}/gift_ideas/recipients.json`)
        .then(response => {
          if (!response.ok) {
            throw new Error('Failed to load recipients');
          }
          return response.json();
        })
        .then(data => {
          if (chatbotMessages) chatbotMessages.innerHTML = '';
          
          if (data.recipients && data.recipients.length > 1) {
            if (recipientSelectContainer) {
              recipientSelectContainer.style.display = 'block';
            }
            if (recipientSelect) {
              recipientSelect.innerHTML = '<option value="">-- Select a recipient --</option>';
              data.recipients.forEach(recipient => {
                const option = document.createElement('option');
                option.value = recipient.id;
                option.textContent = recipient.username;
                recipientSelect.appendChild(option);
              });
              recipientSelect.addEventListener('change', function(e) {
                const recipientId = e.target.value;
                if (recipientId) {
                  generateGiftIdeas(eventId, recipientId);
                }
              });
            }
          } else if (data.recipients && data.recipients.length === 1) {
            generateGiftIdeas(eventId, data.recipients[0].id);
          } else {
            addMessage('No recipients found for this event.');
          }
        })
        .catch(error => {
          console.error('Error loading recipients:', error);
          addMessage('Error loading recipients. The backend route may not be implemented yet.');
        });
    }
  
    function generateGiftIdeas(eventId, recipientId) {
      if (chatbotMessages) chatbotMessages.innerHTML = '';
      if (chatbotLoading) chatbotLoading.style.display = 'block';
  
      const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
  
      fetch(`/events/${eventId}/gift_ideas/generate.json`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({ recipient_id: recipientId })
      })
        .then(response => {
          if (!response.ok) {
            return response.json().then(err => { throw err; });
          }
          return response.json();
        })
        .then(data => {
          if (chatbotLoading) chatbotLoading.style.display = 'none';
          if (data.error) {
            addMessage('Error: ' + data.error);
          } else {
            addMessage(`<strong>Gift Ideas for ${data.recipient.username}</strong>`);
            addMessage(`Likes: ${data.recipient.likes.join(', ') || 'None specified'}`);
            addMessage(`Dislikes: ${data.recipient.dislikes.join(', ') || 'None specified'}`);
            addMessage('<strong>Gift Suggestions:</strong>');
            if (data.gift_ideas && data.gift_ideas.length > 0) {
              data.gift_ideas.forEach(idea => {
                addMessage(`• ${idea}`);
              });
            } else {
              addMessage('No gift ideas generated. Please try again.');
            }
          }
        })
        .catch(error => {
          if (chatbotLoading) chatbotLoading.style.display = 'none';
          console.error('Error generating gift ideas:', error);
          addMessage('Error generating gift ideas. The backend route may not be implemented yet.');
        });
    }
  
    function addMessage(text) {
      if (!chatbotMessages) return;
      
      const messageDiv = document.createElement('div');
      messageDiv.className = 'message assistant';
      messageDiv.innerHTML = text;
      chatbotMessages.appendChild(messageDiv);
      chatbotMessages.scrollTop = chatbotMessages.scrollHeight;
    }
  }