import java.util.HashMap;
import java.util.Map;

public class Situation {
    private final Map<Value, Double> map = new HashMap<Value, Double>();

    public double get(Value value) {
        return map.get(value);
    }

    public void set(Value va, double value) {
        map.put(va, value);
    }

}
