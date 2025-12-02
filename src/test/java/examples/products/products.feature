Feature: Test with Products Endpoint.

    Background: 
        * url 'https://fakestoreapi.com'

#1. Happy path in fake store api
    Scenario: Get all ids, an post new id with an id already create.
    Given path 'products'
    When method get
    Then status 200
    And print response
    * def product_id = response[1]

    * copy cheap_product = product_id
    * set cheap_product.title = "Producto barato"
    * set cheap_product.price = 50
    Given path 'products'
    When method post
    Then status 201
    #Fake Store Api do not support preview new items.
    And print response

    Scenario: Create a new id with a external JSON.
    * def external_json_product = read('classpath:examples/Data/productsbody.json')
    * set external_json_product.title = "Nuevo producto creado"
    * set external_json_product.price = 75000
    * set external_json_product.description = "Nueva descripción creada"
    * set external_json_product.category = "Nueva categoria"
    * set external_json_product.image = "https://img.freepik.com/vector-premium/icono-diseno-color-tiempo-prueba-movil_362714-11841.jpg?semt=ais_hybrid&w=740&q=80"
    Given path 'products'
    And request external_json_product
    When method post
    Then status 201
    And match response.title == "Nuevo producto creado"
    And match response.price == 75000
    And match response.description == "Nueva descripción creada"
    And match response.category == "Nueva categoria"
    And match response.image == "https://img.freepik.com/vector-premium/icono-diseno-color-tiempo-prueba-movil_362714-11841.jpg?semt=ais_hybrid&w=740&q=80"
    #Print new product correctly
    And print response
    * def new_product_created = response.id
    #But when it's try to get data with the get method, the API do not show anything. This it because the data is not save at all
    Given path 'products', new_product_created
    When method get
    And status 200
    And print response

    #Update product with put and path
    Scenario: Update data with put an patch
    * def update_data = read('classpath:examples/Data/productsbody.json') 
    * copy put_data = update_data
    * set put_data.title = "Titulo editado con nueva información con put"
    * set put_data.price = 50000
    * set put_data.description = "Descripcion editada con put"
    * set put_data.category = "Categoria editada con put"
    * set put_data.imagen = "Imagenput.com"
    Given path 'products', 2
    And request put_data
    When method put
    Then status 200
    And match response.title == "Titulo editado con nueva información con put"
    And print response
    
    * copy update_patch = update_data 
    * set update_patch.title = "Titulo editado con nueva información con path"
    Given path 'products', 3
    And request update_patch
    When method patch
    Then status 200
    And match update_patch.title == "Titulo editado con nueva información con path"
    And print response

    Scenario: Detele product already created
    Given path 'products', 3
    When method delete
    Then status 200
    And print response  

    Scenario: Validate data type
    Given path 'products', 1
    When method get
    Then status 200
    #here there is a aditional field called "rating", but the api documentation don't show it
    And match response contains {id: '#number', title: '#string', price:'#number', description: '#string', category:'#string', image: '#string'}
    And print response


#2. Some bugs found in the Fake Store API

    Scenario Outline: Get a product with a no-existent id
    Given path 'products', <id>
    When method get 
    Then status <status>
    And print response
    #id 500 should be 400 because id no dot exist, but fake store API send a 200 status
    Examples:
        |id|status|
        |1|200|
        |2|200|
        |3|200|
        |500|400|

    Scenario: Try to delete a id non-existent
    Given path 'products', 900
    When method delete
    Then status 400
    #The response should be 400, because this id do not exist.
    And print response

    Scenario: Validate data type
    Given path 'products', 1
    When method get
    Then status 400
    #Here it should return 400, because the field "title" has an invalid data type (number), but the endpoint responds with 200 instead of 400.
    And match response == {id: '#number', title: '#number', price:'#number', description: '#string', category:'#string', image: '#string', rating: {"rate":3.9,"count":120}}
    And print response   

    Scenario: Validate missing fields
    Given path 'products', 1
    When method get
    Then status 400
    # We will not validate the data type of the "rating" field. The API should return a 400 status, but it returns 200 instead.
    And match response == {id: '#number', title: '#string', price:'#number', description: '#string', category:'#string', image: '#string'}
    And print response 
   
    Scenario: Create new product with non-existent field
    * def invalid_new_product = read('classpath:examples/Data/productsbody.json')
    * set invalid_new_product.title = "Titulo nuevo"
    * set invalid_new_product.price = 40000
    * set invalid_new_product.description = "Nueva descripción"
    * set invalid_new_product.category = "Nueva categoría"
    * set invalid_new_product.image = "example.com"
    * set invalid_new_product.rating = {"rate":3.9,"count":120}
    #Another FIELD don't exist, so the status should be 400
    * set invalid_new_product.another = "No debería estara aquí este campo"
    Given path 'products'
    And request invalid_new_product
    When method post
    Then status 400
    And print response
    
    Scenario: range in price very high
     * def price_high = read('classpath:examples/Data/productsbody.json')
     #There are not validation about the price amount.
     * set price_high.price = 1000000000000000000000000000000000000000000000000000
     Given path 'products', 1
     And request price_high
     When method put
     Then status 200
     And print response 