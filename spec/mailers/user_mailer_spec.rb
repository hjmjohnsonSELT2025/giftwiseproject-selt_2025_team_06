require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { User.create!(username: "tester", email: "tester@example.com", password: "oldpassword") }

  let(:mail) { UserMailer.password_changed(user) }


  it "renders the headers" do
    expect(mail.subject).to eq("Your password has been updated")
    expect(mail.to).to eq([user.email])
    expect(mail.from).to eq(["group6@giftwise.com"])
  end

  it "renders the body" do
    expect(mail.body.encoded).to match("Hello #{user.username}")
    expect(mail.body.encoded).to match("password was successfully updated")
  end
end