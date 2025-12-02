package examples.auth;
import com.intuit.karate.junit5.Karate;


public class auth_Test {
    @Karate.Test
    Karate authKarate() {
        return Karate.run("auth").relativeTo(getClass());
    }
    
}
