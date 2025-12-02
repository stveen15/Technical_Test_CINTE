# Technical_Test_CINTE
Esta es la prueba técnica para QA tester junior - 02/12/2025 para la empresa CINTE

1. Datos aspirante.
```
Mairon Stveen Delgado García
Rol: QA tester Junior
Fecha de envío prueba: 02/12/2025
```


2. Tecnologías utilizadas

- Lenguaje: Java 17  
- Framework de automatización: [Karate](https://karatelabs.github.io/karate/)  
- Build tool: Maven  
- IDE: Visual Studio Code  

3. Estructura del proyecto.

```
pom.xml
src
test - java - examples 
                    products
                    carts
                    users
                    auth
                    data
                    ExamplesTest.java
```

4. Para ejecutar las pruebas escribir: mvn test -Dtest=ExamplesTest
- Si se solicita hacer las pruebas de un feature en especifico: mvn test -Dtest=users_Test 

5. Para visualizar el reporte de resutlados propio de Karate, usar la ruta (completar): target/karate-reports/karate-summary.html
6. Hallazgos principales: De los 4 features (products, carts, users, auth), tres presentan errores o inconsistencias (products, carts, users) y uno tuvo resultados satisfactorios (auth).
7. Los detalles de cada scenario están documentados en el documento word: "Informe prueba técnica Fake Store API.pdf"
 
