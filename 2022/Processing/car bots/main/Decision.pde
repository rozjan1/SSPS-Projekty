import java.util.HashMap;
import java.util.Map;

public class Decision {
    private final Map<Action, Double> map = new HashMap<Action, Double>();

    public double getValueForAction(Action action) {
        return map.get(action);
    }

    public void setValueForAction(Action action, double value) {
        map.put(action, value);
    }

    public Action getAction() {
        double bestDecisionValue = -10000;
        Action bestAction = null;
        for (Action act : map.keySet()) {
            if (map.get(act) > bestDecisionValue) {
                bestDecisionValue = map.get(act);
                bestAction = act;
            }
        }
        return bestAction;
    }
}
