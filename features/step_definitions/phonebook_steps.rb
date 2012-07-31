Given /^I have following persons defined:$/ do |table|
  # table is a | D.Chelimsky    | +79272717777    |pending
  table.hashes.each do |record|
    person = Person.create!(name: record[:name])
    person.phone_numbers.create!(number: record[:phone_number])
  end
end
When /^I click name of "([^"]*)"$/ do |person_name|
  person = Person.find_by_name(person_name)
  page.find("#best_in_place_person_#{person.id}_name").click
end
Then /^I should see input for "([^"]*)" name$/ do |person_name|
  person = Person.find_by_name(person_name)
  page.should have_css("input[value='#{person.name}']")
end
Then /^I wait (\d+) second.{0,1}$/ do |amount|
  sleep amount.to_i
end
When /^there should not be person named "([^"]*)"$/ do |person_name|
  Person.should_not exist(name: person_name)
end
When /^there should be person named "([^"]*)"$/ do |person_name|
  Person.should exist(name: person_name)
end
When /^I click phone of "([^"]*)"$/ do |person_name|
  person = Person.find_by_name(person_name)
  number = person.phone_numbers.first
  page.find("#best_in_place_phone_number_#{number.id}_number").click
end
Then /^I should see input for "([^"]*)" phone$/ do |person_name|
  person = Person.find_by_name(person_name)
  number = person.phone_numbers.first
  page.should have_css("input[value='#{number.number}']")
end
Then /^person named "([^"]*)" should have number "([^"]*)"$/ do |person_name, number_expected|
  person = Person.find_by_name(person_name)
  number = person.phone_numbers.first
  number.number.should == number_expected
end
When /^I click delete link for "([^"]*)" and confirm request$/ do |person_name|
  person = Person.find_by_name(person_name)
  page.find("#delete_person_#{person.id}").click
  sleep 1
  page.driver.browser.switch_to.alert.accept
end
Then /^downloaded file should contains:$/ do |table|
  lines = page.source.split("\n")

  # table is a | D.Chelimsky    | +79272717777    |pending
  table.hashes.each do |record|
    lines.should include "#{record[:name]}\t#{record[:phone_number]}"
  end
end
Then /^there should be person named "([^"]*)" with phone number "([^"]*)"$/ do |person_name, phone_number|
  person = Person.find_by_name(person_name)
  person.phone_numbers.collect{|x| x.number}.should include phone_number
end
When /^I click link to add phone for "([^"]*)"$/ do |person_name|
  person = Person.find_by_name(person_name)
  page.find("#add_number_for_#{person.id}").click
end
When /^person named "([^"]*)" should have "([^"]*)" phone numbers$/ do |person_name, phones_amount|
  person = Person.find_by_name(person_name)
  person.phone_numbers.count.should == phones_amount.to_i
end
When /^I click link to delete phone number belonging to "([^"]*)" and confirm request$/ do |person_name|
  person = Person.find_by_name(person_name)
  phone_number = person.phone_numbers.first
  page.find("#delete_phone_number_#{phone_number.id}").click
  sleep 1
  page.driver.browser.switch_to.alert.accept
end
Then /^I should see "([^"]*)" record$/ do |record_count|
  page.should have_css(".person", :times => record_count.to_i)
end