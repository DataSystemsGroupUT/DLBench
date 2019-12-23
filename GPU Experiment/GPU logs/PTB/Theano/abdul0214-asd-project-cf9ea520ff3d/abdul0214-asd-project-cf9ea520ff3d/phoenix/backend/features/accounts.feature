Feature: Register user
  As a user
  Such that I could access the website
  I want to register for an account

  Scenario: Registering a user from app web page
    Given My email is "my.email@mail.net" and password is "some_password"
    When I click the register button
    Then I should receive a token

Feature: Sign in user
  As a user
  Such that I could access the website
  I want to login

  Scenario: Logging in from app web page
    Given the following users exist
      | email               | encrypted_password  |
      | my.email@mail.net | some_password       |
    And My email is "my.email@mail.net" and password is "some_password"
    When I click the login button
    Then I should receive a token

# 15.11-22.11
Feature: See map of Tartu
  As a user
  Such that I see the area of Tartu
  I want to see map of Tartu

  Scenario: Displaying map of Tartu
    Given the following users exist
      | email     | password |
      | myemail@test.com | mypassword |
    And I sign in with email "myemail@test.com" and password "mypassword"
    When I push the login button
    Then I see a map of Tartu

Feature: Search address
  As a user
  Such that I see destination
  I want to search for a certain address

  Scenario: Search for an address
    Given that I have logged in
    And I have navigated to the Home page
    And I can see a map
    When I type "Juhan Liivi 2" in the Search bar
    And I click to select a destination from the dropdown menu
    Then I see the searched destination on the map

Feature: Navigate to user profile
  As a user
  Such that I can navigate to my profile
  I want to have a navbar containing button to navigate to my profile

  Scenario: Navigate to my profile
    Given that I have logged in
    And I am at any view
    When I click on profile button on navbar
    Then I see my profile info

# 22.11-29.11
Feature: See parking houses and zones on the map
  As a user
  Such that I can recieve information about parking
  I want to see parking houses and zones explicitly on the map

  Scenario: See different parking zones and houses
    Given that I have logged in
    And I am at map view
    Then I see parking zones with different colors
    And I see parking houses as spots

Feature: See parking fees on map
  As a user
  Such that I can see fees about parking in some location
  I want to click on the map and see the fees on that spot

  Scenario: See parking fees on click
    Given that I have logged in
    And I am at map view
    And zones are displayed
    When I click on a zone or parking house
    Then I see parking fees

# 30.11-6.12

Feature: Starting parking on current location
  As a user
  Such that I can reserve a parking spot
  I want to click "start parking" to start parking period

  Scenario: Reserve a parking spot
    Given that I have logged in
    And I am at the map view
    And I have selected a parking spot
    When I click on "start parking"
    Then parking session at that spot is started for me
    
Feature: End parking on current location
  As a user
  Such that I can vacant a parking spot
  I want to click "end parking" to end parking period

  Scenario: Vacant a parking spot
    Given that I have logged in
    And I am at the map view
    When I click on "end parking"
    Then that parking session is ended

Feature: See available parking spots
  As a user
  Such that I can see the number of available parking spots
  I want to click on a street or parking house and see how many spots are available

  Scenario: See number of available parking spots
    Given that I have logged in
    And I am at the map view
    And I click on street or parking house
    And I see number of available parking spots
    When I start parking
    Then I see the number of available parking spots decreases by one
