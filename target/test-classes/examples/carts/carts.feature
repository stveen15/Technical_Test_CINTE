Feature: Testing with Carts Endpoint.

    Background: 
        * url 'https://fakestoreapi.com'
    
    #1. Happy path

    Scenario: get all carts
        Given path 'carts'
        When method get
        Then status 200
        And print response
    
    Scenario: get cart id
        Given path 'carts', 1
        When method get
        Then status 200
        And print response
    
    Scenario: get user id
        Given path 'carts', 1
        When method get
        Then status 200
        * def id_user = response.userId
        And print id_user

    Scenario: get products by cart id
        Given path 'carts', 2
        When method get
        Then status 200
       * def cart_products = response.products
        And print response

    Scenario: Post new cart
        * def new_cart = read('classpath:examples/Data/cartsbody.json')
        * set new_cart.products[0] = {productId: 1, quantity: 3}
        Given path 'carts'
        When method post
        Then status 201
        And print response  

     Scenario: Post new cart inside another cart
        * def new_cart = read('classpath:examples/Data/cartsbody.json')
        * set new_cart.products[0] = {productId: 2, quantity: 10}
        Given path 'carts', 1
        When method post
        Then status 404
        And print response  

     Scenario: Add new products to cart
        * def new_cart = read('classpath:examples/Data/cartsbody.json')
        * set new_cart.products[0] = {productId: 3, quantity: 1}
        * set new_cart.products[1] = {productId: 4, quantity: 2}
        * set new_cart.products[2] = {productId: 5, quantity: 3}
        Given path 'carts', 2
        When method put
        Then status 200
        And print response

      Scenario: Post the same product to the cart
       * def new_cart = read('classpath:examples/Data/cartsbody.json')
        * set new_cart.products[0] = {productId: 10, quantity: 1}
        * set new_cart.products[1] = {productId: 10, quantity: 1}
        * set new_cart.products[2] = {productId: 10, quantity: 1}
        Given path 'carts', 2
        When method put
        Then status 200
        And print response 

    Scenario: Delete carts
        Given path 'carts', 2
        When method delete
        Then status 200
        And print response

#2. Some bugs found in the Fake Store API
    Scenario: Get non-existent cart
        Given path 'carts', 100
        When method get
        Then status 400
        And print response
  
    Scenario: Delete cart that doesn't exist
        Given path 'carts', 500
        When method delete
        Then status 400
        And print response

    Scenario: Post a cart without products
        * def new_cart2 = read('classpath:examples/Data/cartsbody.json')
        * set new_cart2.products[0] = {}
        Given path 'carts'
        When method post
        Then status 400
        And print response
    
    Scenario: Post a product with zero quantity
        * def new_cart2 = read('classpath:examples/Data/cartsbody.json')
        * set new_cart2.products[0] = {productId: 1, quantity: 0}
        Given path 'carts'
        When method post
        Then status 400
        And print response

    Scenario: Change the owner of the cart
        Given path 'carts', 1
        When method get
        Then status 200
        * def get_cart = response
        #In this test case, the API shouldn't allow this, because a cart has its own user. It doesn't make sense if someone tries to change it.
        * set get_cart.userId = 2000
        Given path 'carts'
        When method get
        Then status 400
        And print response