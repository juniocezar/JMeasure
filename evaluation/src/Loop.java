import lac.JMeasure;

public class Loop {
  public static void main(String[] args) {
    if (args.length != 1) {
      System.err.println("Err: wrong syntax.\n" +
            "Example: java -cp . Loop ${iterations}");
      return;
    }

    JMeasure jm = new JMeasure();
    jm.enableMonitor();

    int it = Integer.parseInt(args[0]);
    int j = 0;

    jm.startMeasurement();
    while(j < it) {
      j++;
    }
    jm.stopMeasurement();
  }
}
