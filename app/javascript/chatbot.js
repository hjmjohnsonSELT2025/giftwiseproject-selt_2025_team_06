let chatbotInitialized = false;

document.addEventListener('turbo:before-cache', function() {
  chatbotInitialized = false;
});

document.addEventListener('turbo:load', function() {
  if (!chatbotInitialized) {
    initializeChatbot();
    chatbotInitialized = true;
  }
});

document.addEventListener('DOMContentLoaded', function() {
  if (!chatbotInitialized) {
    initializeChatbot();
    chatbotInitialized = true;
  }
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
  
  // Chat state variables
  let conversationHistory = [];
  let currentRecipientId = null;
  let currentRecipient = null;
  
  // Chat input elements
  const chatbotInput = document.getElementById('chatbot-input');
  const chatbotSendBtn = document.getElementById('chatbot-send-btn');
  const chatbotInputContainer = document.getElementById('chatbot-input-container');

  // Remove existing listeners to prevent duplicates
  const newBtn = chatbotBtn.cloneNode(true);
  chatbotBtn.parentNode.replaceChild(newBtn, chatbotBtn);
  const newChatbotBtn = document.getElementById('ai-gift-ideas-btn');

  newChatbotBtn.addEventListener('click', handleButtonClick);

  if (chatbotClose) {
    chatbotClose.addEventListener('click', handleCloseClick);
  }

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
    if (chatbotInputContainer) chatbotInputContainer.style.display = 'none';
    if (chatbotInput) chatbotInput.value = '';
    conversationHistory = [];
    currentRecipientId = null;
    currentRecipient = null;
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
            
            const newSelect = recipientSelect.cloneNode(true);
            recipientSelect.parentNode.replaceChild(newSelect, recipientSelect);
            const newRecipientSelect = document.getElementById('recipient_select');
            
            newRecipientSelect.addEventListener('change', function(e) {
              const recipientId = e.target.value;
              if (recipientId) {
                generateGiftIdeas(eventId, recipientId);
              }
            });
          }
        } else if (data.recipients && data.recipients.length === 1) {
          generateGiftIdeas(eventId, data.recipients[0].id);
        } else {
          addMessage('No recipients found for this event.', 'assistant');
        }
      })
      .catch(error => {
        console.error('Error loading recipients:', error);
        addMessage('Error loading recipients. The backend route may not be implemented yet.', 'assistant');
      });
  }

  function generateGiftIdeas(eventId, recipientId) {
    if (chatbotMessages) chatbotMessages.innerHTML = '';
    if (chatbotLoading) chatbotLoading.style.display = 'block';
    
    currentRecipientId = recipientId;
    conversationHistory = [];

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
          addMessage('Error: ' + data.error, 'assistant');
        } else {
          currentRecipient = data.recipient;
          
          addMessage(`Hello! I'm here to help you find the perfect gift for ${data.recipient.username}.`, 'assistant');
          addMessage(`I know they like: ${data.recipient.likes.join(', ') || 'Nothing specified'}`, 'assistant');
          addMessage(`And they dislike: ${data.recipient.dislikes.join(', ') || 'Nothing specified'}`, 'assistant');
          addMessage('<strong>Here are some gift suggestions:</strong>', 'assistant');
          
          if (data.gift_ideas && data.gift_ideas.length > 0) {
            data.gift_ideas.forEach(idea => {
              addMessage(`• ${idea}`, 'assistant');
            });
          } else {
            addMessage('No gift ideas generated. Please try again.', 'assistant');
          }
          
          addMessage('Feel free to ask me questions about these suggestions or request more ideas!', 'assistant');
          

          if (chatbotInputContainer) chatbotInputContainer.style.display = 'block';
          if (chatbotInput) chatbotInput.focus();

          conversationHistory = [
            { role: 'system', content: `You are a helpful gift recommendation assistant helping to find gifts for ${data.recipient.username}. Their likes: ${data.recipient.likes.join(', ') || 'None'}. Their dislikes: ${data.recipient.dislikes.join(', ') || 'None'}.` }
          ];
        }
      })
      .catch(error => {
        if (chatbotLoading) chatbotLoading.style.display = 'none';
        console.error('Error generating gift ideas:', error);
        addMessage('Error generating gift ideas. The backend route may not be implemented yet.', 'assistant');
      });
  }

  function sendMessage() {
    if (!chatbotInput || !chatbotInput.value.trim() || !currentRecipientId) return;
    
    const userMessage = chatbotInput.value.trim();
    chatbotInput.value = '';
    
    addMessage(userMessage, 'user');

    conversationHistory.push({ role: 'user', content: userMessage });

    if (chatbotLoading) chatbotLoading.style.display = 'block';

    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
    
    fetch(`/events/${eventId}/gift_ideas/chat.json`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify({
        recipient_id: currentRecipientId,
        message: userMessage,
        conversation_history: conversationHistory
      })
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
          addMessage('Error: ' + data.error, 'assistant');
        } else {
          addMessage(data.response, 'assistant');
          
          conversationHistory.push({ role: 'assistant', content: data.response });
        }
        
        if (chatbotInput) chatbotInput.focus();
      })
      .catch(error => {
        if (chatbotLoading) chatbotLoading.style.display = 'none';
        console.error('Error sending message:', error);
        addMessage('Error sending message. Please try again.', 'assistant');
        if (chatbotInput) chatbotInput.focus();
      });
  }

  function addMessage(text, type = 'assistant') {
    if (!chatbotMessages) return;
    
    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${type}`;
    messageDiv.innerHTML = text;
    chatbotMessages.appendChild(messageDiv);
    chatbotMessages.scrollTop = chatbotMessages.scrollHeight;
  }
  
  if (chatbotSendBtn) {
    chatbotSendBtn.addEventListener('click', sendMessage);
  }
  
  if (chatbotInput) {
    chatbotInput.addEventListener('keypress', function(e) {
      if (e.key === 'Enter') {
        sendMessage();
      }
    });
  }
}