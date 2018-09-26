package lac;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetSocketAddress;
import java.net.Socket;
import lac.EnergyCalculator;

/**
 * Connects to the SmartPower2 device through telnet and collects sample values.
 * @author juniocezar
 */
public class JMeasure {    
    private Socket sock;
    private BufferedReader br;
    private BufferedWriter bw;
    private String outFile;
    
    /**
     * Wrapper over System.out.println(String)
     * @param msg 
     */
    private static void show(String msg) {
        System.out.println(msg);
    }
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        if (args.length != 2) {
            System.out.println("Syntax: java -cp $CLASSPATH lac.jmeasure server_ip_address output_file");
            System.exit(1);
        }
        
        String outFile = args[1];
        String ip = args[0];        
        
        show("Initiating JMeasure");
        show("Outputs will be written to the file: " + outFile);
        
        JMeasure jm = new JMeasure();                
        jm.setOutput(outFile);
        
        if (!jm.connect(ip)) 
            return;     
	show("Connected to SmartPower2 Device");
        jm.collectSamples();
        
        EnergyCalculator ec = new EnergyCalculator();
        double energy = ec.calc(outFile);
        show("Total energy spent: " + energy);
    }
    
    /**
     * Connects to the telnet server.
     */
    public boolean connect(String ip){
        boolean success = true;
        try {
            sock = new Socket();
            sock.connect(new InetSocketAddress(ip, 23), 1000);
        } catch (IOException ex) {
            success = false;
            show("\nProblem while connecting to SmartPower through telnet.");
            show("Check if you are connected to the SmartPower WiFi network\n"
                    + "  and if you can reach the IP address: " + ip);
        }
        return success;
    }
    
    public void setOutput(String filename) {
        outFile = filename;
    }
    
    /**
     * Collects and processes the outputs of the telnet connection (Smartpower2)   
     */
    private void collectSamples() {        
        try {
            String log;
            boolean initiated = false;
            br = new BufferedReader(new InputStreamReader(sock.getInputStream()));
            bw = new BufferedWriter(new FileWriter(outFile));
        
            // read line by line, looking for tags and std out
            while ((log = br.readLine()) != null) {              
                String[] values = log.split(" ");
                
                // each log line should have 1 or 3 fields separated by " " in 
                // the following format: "LOG: TIMESTAMP POWERVALUE"
                // or: "TAG1" 
                
                if (values.length != 3) {
                    // found tag 1, which enables the measurement
                    if (log.contains("START")) {
                        show("Measurement started, " + 
                                " loggining data.");
                        initiated = true;
                        continue;
                    }
                    // found tag 2, which disables the measurement
                    if (log.contains("FINISH")) {
                        show("Measurement stopped, " + 
                                " closing output file.");
                        break;
                    }
                    
                    show("Received unformmated input: " + log);
                    continue;
                }
                
                if (initiated && values[0].equals("LOG:")) {
                    show(values[1] + " " + values[2]);
                    bw.write(values[1] + " " + values[2] + "\n");
                }
            }

            bw.close();
            br.close();
            sock.close();                        
        }
        catch(IOException e) {
          e.printStackTrace();
        }
    }
}
