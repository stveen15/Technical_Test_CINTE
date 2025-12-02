package examples.products;
import com.intuit.karate.junit5.Karate;


public class products_Test {
    @Karate.Test
    Karate productsKarate() {
        return Karate.run("products").relativeTo(getClass());
    }

     @Karate.Test
    Karate testSolo() {
        return Karate.run("products").tags("@solo").relativeTo(getClass());
    }
}

