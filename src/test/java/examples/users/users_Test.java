package examples.users;
import com.intuit.karate.junit5.Karate;


public class users_Test {
    @Karate.Test
    Karate usersKarate() {
        return Karate.run("users").relativeTo(getClass());
    }
    
}
