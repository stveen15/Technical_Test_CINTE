Feature: Testing with Users Endpoint.

    Background: 
        * url 'https://fakestoreapi.com'
    
    #1. Happy path

    Scenario: get all users
        Given path 'users'
        When method get
        Then status 200
        And print response
    
    Scenario: get an user by id
        Given path 'users', 1
        When method get
        Then status 200
        And print response

    Scenario: validate data type
        Given path 'users', 1
        When method get
        Then status 200
        And match response contains {id: '#number', username: '#string', email: '#string', password:'#string' }
        And print response
    
    Scenario: Create a new user and valide creation
        * def new_user = read('classpath:examples/Data/userbody.json')
        * set new_user.username = "mairons"
        * set new_user.email = "correo@correo.com"
        * set new_user.password = "contraseña"
        Given path 'users'
        And request new_user
        When method post
        Then status 201
        * def validate_user_created = response.id
        And print response
        Given path 'users', validate_user_created
        When method get
        Then status 200
        #This API allows make this request, but doesn't return  data of new users created
        And print response

    
    Scenario: Edit a existent user.
        * def user_already_created = read('classpath:examples/Data/userbody.json')
        * set user_already_created.username = "username editado"

        Given path 'users', 1
        And request user_already_created
        When method put
        Then status 200
        And print response
    
    Scenario: Delete users
        Given path 'users', 2
        When method delete
        Then status 200
        And print response
    
    #2. Some bugs found in the Fake Store API

    Scenario: Get a non-existent id user
        Given path 'carts', 500
        When method get
        Then status 400
        And print response
    
    Scenario: Create new user with missing data
    #This test will take into account the required fields documented in the app
        * def new_user2 = read('classpath:examples/Data/userbody.json')
    #Create a new user with only username field
        * set new_user2.username = "mairons"
        Given path 'users'
        And request new_user2
        When method post
        Then status 400
        And print response
    
    Scenario: Create new user with an username already created ("johnd" by user with id "1")
        * def username_already_created = read('classpath:examples/Data/userbody.json')
        * set username_already_created.username = "johnd"
        * set username_already_created.email = "jhonr@example.com"
        * set username_already_created.password = "contraseña"
        Given path 'users'
        When method post
    #This depends of businees logic 
        Then status 400
        And print response
    
    Scenario: Create a user with a password that has low validation requirements
        * def password_validation = read('classpath:examples/Data/userbody.json')
        * set password_validation.username = "usuario"
        * set password_validation.email = "jhonr@example.com"
        #This could be a system security flaw
        * set password_validation.password = "c"
        Given path 'users'
        When method post
    #This depends of businees logic 
        Then status 400
        And print response

    Scenario: try to create a user without password
        * def password_validation = read('classpath:examples/Data/userbody.json')
        * set password_validation.username = "usuario2"
        * set password_validation.email = "jhonr@example.com"
        #This could be a system security flaw
        * set password_validation.password = ""
        Given path 'users'
        When method post
    #This depends of businees logic 
        Then status 400
        And print response
    
    Scenario: Try deleted a user non-existent
        Given path 'users', 5000
        When method delete
        Then status 400
        And print response
    
    Scenario: try to change id of a user already created
    #The id must be immutable
        * def user_id = read('classpath:examples/Data/userbody.json')
        * set user_id.id = 50
        Given path 'users', 6
        And request user_id
        When method delete
        Then status 400
        And print response