Simple evaluation of the smartpower2 device + JMeasure app

compile:
	javac -cp lib/jmeasure-linuxlib.jar -d bin src/Loop.java

run:
	java -cp bin:lib/jmeasure-linuxlib.jar Loop $iterations


Expected JavaVM bytecode:
Compiled from "Loop.java"
public class Loop {
  public Loop();
    Code:
       0: aload_0
       1: invokespecial #1                  // Method java/lang/Object."<init>":()V
       4: return

  public static void main(java.lang.String[]);
    Code:
       0: aload_0
       1: arraylength
       2: iconst_1
       3: if_icmpeq     15
       6: getstatic     #2                  // Field java/lang/System.err:Ljava/io/PrintStream;
       9: ldc           #3                  // String Err: wrong syntax.\nExample: java -cp . Loop ${iterations}
      11: invokevirtual #4                  // Method java/io/PrintStream.println:(Ljava/lang/String;)V
      14: return
      15: new           #5                  // class lac/JMeasure
      18: dup
      19: invokespecial #6                  // Method lac/JMeasure."<init>":()V
      22: astore_1
      23: aload_1
      24: invokevirtual #7                  // Method lac/JMeasure.enableMonitor:()Z
      27: pop
      28: aload_0
      29: iconst_0
      30: aaload
      31: invokestatic  #8                  // Method java/lang/Integer.parseInt:(Ljava/lang/String;)I
      34: istore_2
      35: iconst_0
      36: istore_3
      37: aload_1
      38: invokevirtual #9                  // Method lac/JMeasure.startMeasurement:()Z
      41: pop
LOOP  42: iload_3
 |    43: iload_2
 |    44: if_icmpge     53
 |    47: iinc          3, 1
END   50: goto          42
      53: aload_1
      54: invokevirtual #10                 // Method lac/JMeasure.stopMeasurement:()Z
      57: pop
      58: return
}

