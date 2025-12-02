package examples.carts;
import com.intuit.karate.junit5.Karate;


public class carts_Test {
    @Karate.Test
    Karate cartsKarate() {
        return Karate.run("carts").relativeTo(getClass());
    }
}

