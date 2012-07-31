require 'cucumber/websteps'
When /^I click "([^"]*)"$/ do |link_name|
  click_link_or_button(link_name)
end