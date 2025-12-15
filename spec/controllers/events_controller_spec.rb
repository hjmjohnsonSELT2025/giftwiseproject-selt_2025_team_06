require 'spec_helper'
require 'rails_helper'

describe EventsController do
  render_views
  let(:user) { User.create!(username: "tester", email: "tester@example.com", password: "oldpassword") }

  before do
    # Simulate login by setting session
    session[:user_id] = user.id
  end

  describe 'creating event' do
    it 'should render the new event page when new is called' do
      get :new
      expect(response).to render_template(:new)
    end
    it 'should redirect to user dashboard with a flash message if event is created successfully' do
      fake_event = double('Event', save: true)
      expect(Event).to receive(:new).and_return(fake_event)
      post :add_event, params: { title: 'random', event_date: 'random_date', location: 'random_location', budget: 100, theme: 'random_theme' }
      expect(response).to redirect_to(events_path)
      expect(flash[:notice]).to eq('Event created successfully')
    end
    it 'should have the user stay on event creation page with a flash message if create event button is clicked and one of the fields is blank' do
      post :add_event, params: { title: 'random', event_date: '', location: 'random_location', budget: 100, theme: '' }
      expect(response).to redirect_to(new_event_path)
      expect(flash[:alert]).to eq('Please fill out all the fields')
    end
  end

  describe 'attendees page' do
    let(:host) { User.create!(username: "host", email: "host@example.com", password: "password") }
    let(:event) { Event.create!(title: "Holiday Party", event_date: Date.today, location: "Clubhouse", budget: 100, theme: "Festive", host: host) }
    let(:giver) { User.create!(username: "giver", email: "giver@example.com", password: "password") }
    let(:recipient) { User.create!(username: "recipient", email: "recipient@example.com", password: "password") }

    before do
      GiftGiver.create!(event: event, user: giver)
      Recipient.create!(event: event, user: recipient)
    end

    it 'renders the attendees template' do
      get :attendees, params: { id: event.id }
      expect(response).to render_template(:attendees)
    end

    it 'shows gift givers and recipients in the response body' do
      get :attendees, params: { id: event.id }
      expect(response.body).to include("giver")
      expect(response.body).to include("recipient")
    end
  end
end

# Here, we will add out search features as well alongsids the events controller