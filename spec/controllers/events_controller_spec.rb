require 'spec_helper'
require 'rails_helper'

describe EventsController do
  describe 'creating event' do
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
end