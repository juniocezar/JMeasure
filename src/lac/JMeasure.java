package lac;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Connects to the SmartPower2 device through telnet and collects sample values.
 * @author juniocezar
 */
public class JMeasure {    
    private Socket sock;
    private BufferedReader br;
    private BufferedWriter bw;
    private String outFile;
    private boolean enabled = false;
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        if (args.length != 2) {
            System.out.println("Syntax: java -cp . lac.jmeasure output_file server_ip_address");
            System.exit(1);
        }
        
        String outFile = args[0];
        String ip = args[1];
        System.out.println("Initiating JMeasure\n\nOutput file: " + outFile);
        
        JMeasure jm = new JMeasure();
        jm.setOutput(outFile);
        jm.connect(ip);
        jm.collect();
        
    }
    
    /**
     * Connects to the telnet server.
     */
    public void connect(String ip){
        try {
            sock = new Socket(ip, 23);
        } catch (IOException ex) {
            Logger.getLogger(JMeasure.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void setOutput(String filename) {
        outFile = filename;
    }
    
    /**
     * Collects and processes the outputs of the telnet connection (Smartpower2)   
     */
    private void collect() {        
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
                
                //if (values.length != 3) {
                    // found tag 1, which enables the measurement
                    if (log.contains("START")) {
                        System.out.println("-> Measurement started, " + 
                                " writing to output file.");
                        initiated = true;
                  //      continue;
                    }
                    // found tag 2, which disables the measurement
                    if (log.contains("FINISH")) {
                        System.out.println("-> Measurement stopped, " + 
                                " closing output file.");
                        break;
                    }
                    
                 //   System.out.println("Received unformmated input: " + log);
                 //   continue;
                //}
                
                if (initiated && values[0].equals("LOG:")) {
                    System.out.println(values[1] + " " + values[2]);
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
