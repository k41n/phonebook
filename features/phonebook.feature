Feature:
  Create a phonebook which allows to keep peoples names and phones.
  It has one page which allows to add, edit and remove via ajax.
  it also allows to download the phonebook as a text file
  (e.g. tab-separated) and also upload a new version.

  When it uploads a file, it updates the phonebook, creating, updating and
  deleting records as appropriate. In short it has to sync the manual
  added data with the uploaded file.

  Background:
    Given I have following persons defined:
      | name           | phone_number    |
      | D.Chelimsky    | +79272717777    |
      | A.Hellesoy     | +79021234567    |
      | D.H. Hansson   | +79061231231    |
      | Y.Matsumoto    | +72760987654    |
    Given I am on the phonebook page

  Scenario: Show existing person
    Then I should see "D.Chelimsky"

  @javascript
  Scenario: Edit existing person
    When I click name of "D.Chelimsky"
    Then I should see input for "D.Chelimsky" name
    When I fill in "name" with "David Chelimsky"
    And I press "OK"
    Then I should see "Changes applied"
    Then I wait 6 seconds
    And I should not see "Changes applied"
    And there should not be person named "D.Chelimsky"
    But there should be person named "David Chelimsky"

  @javascript
  Scenario: Unable to make empty name while editing
    When I click name of "D.Chelimsky"
    Then I should see input for "D.Chelimsky" name
    When I fill in "name" with ""
    And I press "OK"
    Then I should see "Name can't be blank"

  @javascript
  Scenario: Edit existing person's number
    When I click phone of "D.Chelimsky"
    Then I should see input for "D.Chelimsky" phone
    When I fill in "number" with "+78342234234"
    And I press "OK"
    Then I should see "Changes applied"
    Then I wait 6 seconds
    And I should not see "Changes applied"
    Then person named "D.Chelimsky" should have number "+78342234234"

  @javascript
  Scenario: Delete record
    When I click delete link for "D.Chelimsky" and confirm request
    And I wait 1 second
    Then there should not be person named "D.Chelimsky"
    And I should not see "D.Chelimsky"

  Scenario: Download phonebook
    When I click "Download for sync"
    Then downloaded file should contains:
      | name           | phone_number    |
      | D.Chelimsky    | +79272717777    |
      | A.Hellesoy     | +79021234567    |
      | D.H. Hansson   | +79061231231    |
      | Y.Matsumoto    | +72760987654    |

  @javascript
  Scenario: Upload phonebook
    When I click "Upload sync"
    And I attach the file "phonebook.txt" to "sync"
    And I press "Upload"
    And I wait 1 second
    Then I should see "4 deleted records"
    Then I should see "1 new records"
    Then there should be person named "Newborn Person" with phone number "+7987123232"

  @javascript
  Scenario: Upload same phonebook changes nothing
    When I click "Upload sync"
    And I attach the file "same.txt" to "sync"
    And I press "Upload"
    And I wait 1 second
    Then I should see "0 deleted records"
    Then I should see "0 new records"
    Then I should see "0 updated records"

  @javascript
  Scenario: Upload phonebook with doubled phone
    When I click "Upload sync"
    And I attach the file "phonebook_double.txt" to "sync"
    And I press "Upload"
    And I wait 1 second
    Then I should see "4 deleted records"
    Then I should see "1 new records"
    Then there should be person named "Newborn Person" with phone number "+7987123232"
    And person named "Newborn Person" should have "2" phone numbers

  @javascript
  Scenario: Upload damaged
    When I click "Upload sync"
    And I attach the file "phonebook_damaged.txt" to "sync"
    And I press "Upload"
    And I wait 1 second
    Then I should see "0 deleted records"
    Then I should see "0 new records"
    Then I should see "0 updated records"

  @javascript
  Scenario: Upload phonebook with phones updated
    When I click "Upload sync"
    And I attach the file "update_phonebook.txt" to "sync"
    And I press "Upload"
    And I wait 1 second
    Then I should see "4 updated records"
    Then there should be person named "D.Chelimsky" with phone number "+11111111111"

  @javascript
  Scenario: Add second phone number
    When I click link to add phone for "D.Chelimsky"
    And I fill in "number" with "+55555555555"
    And I press "Add"
    And I should see "New number has been added"
    Then there should be person named "D.Chelimsky" with phone number "+55555555555"
    And person named "D.Chelimsky" should have "2" phone numbers
    And I should see "+55555555555"

  @javascript
  Scenario: Unable to add same phone number to one person
    When I click link to add phone for "D.Chelimsky"
    And I fill in "number" with "+79272717777"
    And I press "Add"
    And I should see "Number has already been taken"
    And person named "D.Chelimsky" should have "1" phone numbers
    And I should not see "+55555555555"

  @javascript
  Scenario: Unable to change same phone number to one person
    When I click link to add phone for "D.Chelimsky"
    And I fill in "number" with "+55555555555"
    And I press "Add"
    And I should see "New number has been added"
    Then there should be person named "D.Chelimsky" with phone number "+55555555555"
    And person named "D.Chelimsky" should have "2" phone numbers
    And I should see "+55555555555"
    When I click phone of "D.Chelimsky"
    Then I should see input for "D.Chelimsky" phone
    When I fill in "number" with "+55555555555"
    And I press "OK"
    Then I should see "Number has already been taken"

  @javascript
  Scenario: Add new record
    When I click "Add new record"
    And I fill in "Name" with "J. Nicklas"
    And I fill in "Phone number" with "+55555555555"
    And I press "Add"
    And I should see "Record has been added"
    And I should see "J. Nicklas"
    Then there should be person named "J. Nicklas" with phone number "+55555555555"

  @javascript
  Scenario: Add new record with no name specified
    When I click "Add new record"
    And I fill in "Phone number" with "+55555555555"
    And I press "Add"
    And I should see "Name can't be blank"

  @javascript
  Scenario: Add new record with existing name specified
    When I click "Add new record"
    And I fill in "Name" with "D.Chelimsky"
    And I fill in "Phone number" with "+55555555555"
    And I press "Add"
    Then there should be person named "D.Chelimsky" with phone number "+55555555555"
    And person named "D.Chelimsky" should have "2" phone numbers

  @javascript
  Scenario: Delete number
    When I click link to delete phone number belonging to "D.Chelimsky" and confirm request
    And I should see "No numbers known"
    And person named "D.Chelimsky" should have "0" phone numbers

  @javascript
  Scenario: Search by name
    And I fill in "Search" with "Chel"
    And I wait 1 second
    Then I should see "1" record

  @javascript
  Scenario: Search by phone
    And I fill in "Search" with "+7902"
    And I wait 1 second
    Then I should see "1" record