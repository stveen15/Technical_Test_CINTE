Feature: Authentication with auth endpoint
        
    Background: 
        * url 'https://fakestoreapi.com'

#1. Happy path    
    Scenario: Login with valid credentials
    #In this case will use the user with id 1: johnd, m38rmF$
    * def valid_credentials = { username: 'johnd', password: 'm38rmF$' }
    Given path 'auth', 'login'
    And request valid_credentials
    When method post
    Then status 201
    #Validate token will be a string, as documentation said
    And match response.token == '#string'
    And print response
    
    Scenario: validate response time
    * def valid_credentials = { username: 'johnd', password: 'm38rmF$' }
    Given path 'auth', 'login'
    And request valid_credentials
    When method post
    Then status 201
    And assert responseTime < 1000
    And print response

    Scenario: validate token not empty
    #In this case will use the user with id 1: johnd, m38rmF$
    * def valid_credentials = { username: 'johnd', password: 'm38rmF$' }
    Given path 'auth', 'login'
    And request valid_credentials
    When method post
    Then status 201
    #validate token won't be empty
    And match response.token != ''
    And print response

#2. Negative responses
    
    Scenario: Login with non-existent user
    * def invalid_credentials = { username: 'invalido', password: 'invalido!' }
    Given path 'auth', 'login'
    And request invalid_credentials
    When method post
    Then status 401
    And print response
    
    Scenario: Login with a invalid password
    #In this case will use the user with id 1: johnd
    * def invalid_credentials = { username: 'johnd', password: 'invalido!' }
    Given path 'auth', 'login'
    And request invalid_credentials
    When method post
    Then status 401
    And print response

    Scenario: Login without data
    * def invalid_credentials = {}
    Given path 'auth', 'login'
    And request invalid_credentials
    When method post
    Then status 400
    And print response  
    
    Scenario: Validate bad JSON body
    * def bad_json_body = '{ "username": "johnd", "password": m38rmF$ }' 
    Given path 'auth', 'login'
    And header Content-Type = 'application/json'
    And request bad_json_body      
    When method post
    Then status 400          
    And print response
