class AIService
  def initialize
    @api_key = Rails.application.credentials.openai_api_key || ENV['OPENAI_API_KEY']
    @model = 'gpt-3.5-turbo'
    
    if @api_key.blank?
      Rails.logger.warn "AIService initialized without API key. ENV['OPENAI_API_KEY'] = #{ENV['OPENAI_API_KEY'].present? ? 'present' : 'blank'}"
    end
  end

  def generate_gift_ideas(recipient, event = nil, likes: nil, dislikes: nil)
    likes ||= JSON.parse(recipient.likes || '[]')
    dislikes ||= JSON.parse(recipient.dislikes || '[]')
    
    prompt = build_prompt(
      likes: likes,
      dislikes: dislikes,
      event: event
    )

    response = call_openai_api(prompt, likes: likes, dislikes: dislikes)
    parse_gift_ideas(response, likes: likes, dislikes: dislikes)
  end

  def chat(user_message, conversation_history, recipient, event = nil)
    likes = recipient.user_preferences.where(category: "like").includes(:preference).map { |up| up.preference.name }
    dislikes = recipient.user_preferences.where(category: "dislike").includes(:preference).map { |up| up.preference.name }
    
    if conversation_history.empty? || conversation_history.first['role'] != 'system'
      system_message = "You are a helpful gift recommendation assistant helping to find gifts for #{recipient.username}. "
      system_message += "Their likes: #{likes.join(', ') || 'None specified'}. "
      system_message += "Their dislikes: #{dislikes.join(', ') || 'None specified'}. "
      if event
        system_message += "Event: #{event.theme} on #{event.event_date}. Budget: $#{event.budget}. "
      end
      system_message += "Be conversational, helpful, and provide thoughtful gift suggestions."
      
      conversation_history = [{ role: 'system', content: system_message }] + conversation_history
    end
    
    messages = conversation_history.map do |msg|
      { role: msg['role'] || msg[:role], content: msg['content'] || msg[:content] }
    end

    messages << { role: 'user', content: user_message }
    
    response = call_openai_api_chat(messages)
    parse_chat_response(response)
  end
  
  private
  
  def build_prompt(likes:, dislikes:, event:)
    base_prompt = "You are a helpful gift recommendation assistant. "
    base_prompt += "Based on the following preferences, suggest 5-7 thoughtful gift ideas.\n\n"
    
    base_prompt += "Likes: #{likes.join(', ')}\n" if likes.any?
    base_prompt += "Dislikes: #{dislikes.join(', ')}\n" if dislikes.any?
    
    if event
      base_prompt += "\nEvent Details:\n"
      base_prompt += "- Theme: #{event.theme}\n" if event.theme
      base_prompt += "- Budget: $#{event.budget}\n" if event.budget
      base_prompt += "- Date: #{event.event_date}\n" if event.event_date
    end
    
    base_prompt += "\nPlease provide gift suggestions that:\n"
    base_prompt += "1. Align with their likes\n"
    base_prompt += "2. Avoid their dislikes\n"
    base_prompt += "3. Are thoughtful and personalized\n"
    if event&.budget
      base_prompt += "4. Fit within the budget of $#{event.budget}\n"
    end
    base_prompt += "\nFormat your response as a simple list, one gift idea per line, starting with a bullet point."
    
    base_prompt
  end

  def call_openai_api(prompt, likes: [], dislikes: [])
    if @api_key.blank?
      raise "AIService: No API key found. Check that OPENAI_API_KEY is set in .env file and server has been restarted."
    end

    require 'openai'

    client = OpenAI::Client.new(access_token: @api_key)
    
    response = client.chat(
      parameters: {
        model: @model,
        messages: [
          { role: 'system', content: 'You are a helpful gift recommendation assistant.' },
          { role: 'user', content: prompt }
        ],
        temperature: 0.7,
        max_tokens: 500
      }
    )

    Rails.logger.info "OpenAI API Response: #{response.inspect}"
    response
  rescue => e
    Rails.logger.error "OpenAI API Error: #{e.message}\n#{e.backtrace.join("\n")}"
    raise
  end

  def call_openai_api_chat(messages)
    if @api_key.blank?
      raise "AIService: No API key found. Check that OPENAI_API_KEY is set in .env file and server has been restarted."
    end

    require 'openai'

    client = OpenAI::Client.new(access_token: @api_key)
    
    response = client.chat(
      parameters: {
        model: @model,
        messages: messages,
        temperature: 0.7,
        max_tokens: 500
      }
    )

    Rails.logger.info "OpenAI Chat Response: #{response.inspect}"
    response
  rescue => e
    Rails.logger.error "OpenAI API Error: #{e.message}\n#{e.backtrace.join("\n")}"
    raise
  end

  def parse_gift_ideas(api_response, likes: [], dislikes: [])
    Rails.logger.info "Parsing API response: #{api_response.class} - #{api_response.keys.inspect}" if api_response.respond_to?(:keys)
    
    choices = api_response['choices'] || api_response[:choices]
    
    if choices && choices[0]
      message = choices[0]['message'] || choices[0][:message]
      content = message['content'] || message[:content]
      
      Rails.logger.info "Extracted content: #{content[0..100]}..." if content
      
      parsed = content.split("\n")
             .map(&:strip)
             .reject(&:empty?)
             .map { |line| line.gsub(/^[•\-\*]\s*/, '') }
             .reject(&:empty?)
      parsed
    else
      raise "Invalid API response format: #{api_response.inspect}"
    end
  end

  def parse_chat_response(api_response)
    choices = api_response['choices'] || api_response[:choices]
    
    if choices && choices[0]
      message = choices[0]['message'] || choices[0][:message]
      content = message['content'] || message[:content]
      content
    else
      raise "Invalid API response format: #{api_response.inspect}"
    end
  end
end