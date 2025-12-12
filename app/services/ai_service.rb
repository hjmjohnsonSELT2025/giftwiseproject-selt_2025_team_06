class AIService
    def initialize
      @api_key = Rails.application.credentials.openai_api_key || ENV['OPENAI_API_KEY']
      @model = 'gpt-3.5-turbo' 
    end
  
  def generate_gift_ideas(recipient, event = nil)
    likes = JSON.parse(recipient.likes || '[]')
    dislikes = JSON.parse(recipient.dislikes || '[]')
    
    prompt = build_prompt(
      likes: likes,
      dislikes: dislikes,
      event: event
    )

    begin
      response = call_openai_api(prompt)
      parse_gift_ideas(response)
    rescue => e
      Rails.logger.error "AIService Error: #{e.message}"
      mock_response_gift_ideas
    end
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
  
    def call_openai_api(prompt)
      return mock_response if @api_key.blank?
  
      require 'net/http'
      require 'json'
  
      uri = URI('https://api.openai.com/v1/chat/completions')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.read_timeout = 30
      http.open_timeout = 10
  
      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'
      request['Authorization'] = "Bearer #{@api_key}"
  
      request.body = {
        model: @model,
        messages: [
          { role: 'system', content: 'You are a helpful gift recommendation assistant.' },
          { role: 'user', content: prompt }
        ],
        temperature: 0.7,
        max_tokens: 500
      }.to_json
  
      response = http.request(request)
      
      if response.code == '200'
        JSON.parse(response.body)
      else
        Rails.logger.error "OpenAI API Error: #{response.code} - #{response.body}"
        mock_response
      end
    rescue => e
      Rails.logger.error "OpenAI API Error: #{e.message}"
      mock_response
    end
  
    def parse_gift_ideas(api_response)
      if api_response['choices'] && api_response['choices'][0]
        content = api_response['choices'][0]['message']['content']
        content.split("\n")
               .map(&:strip)
               .reject(&:empty?)
               .map { |line| line.gsub(/^[•\-\*]\s*/, '') }
               .reject(&:empty?)
      else
        mock_response_gift_ideas
      end
    end
  
    def mock_response
      { 'choices' => [{ 'message' => { 'content' => mock_response_content } }] }
    end
  
    def mock_response_content
      "• A curated book collection based on their interests\n" \
      "• Artisan coffee beans and a French press\n" \
      "• A personalized art print\n" \
      "• A subscription to a book club\n" \
      "• A coffee tasting experience"
    end
  
    def mock_response_gift_ideas
      [
        "A curated book collection based on their interests",
        "Artisan coffee beans and a French press",
        "A personalized art print",
        "A subscription to a book club",
        "A coffee tasting experience"
      ]
    end
  end