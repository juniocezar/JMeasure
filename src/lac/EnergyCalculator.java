package lac;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Calculates the integral of values of time and instantaneous power through the
 * trapezoidal rule
 * @author juniocezar
 */
public class EnergyCalculator {
    BufferedReader inputBuffer;
    
    private double integral(double startTime, double finalTime, double partialSum, 
            int cont) {

	double h, result;

	h = (finalTime - startTime)/(cont);
	result = (partialSum * (h/2));	
	return result;
    }
    
    private double read() throws IOException {
	double powerValue, timeValue, actPower, prevPower;
        double startTime = 0, finalTime = 0, partialSum;
	int cont;

	cont = 0;
	prevPower = 0.0;
	actPower = 0.0;
	partialSum = 0.0;

        String line;
	while ((line = inputBuffer.readLine()) != null) {
            String[] values = line.split(" ");
            timeValue = Double.parseDouble(values[0]);
            powerValue = Double.parseDouble(values[1]);
		
            cont++;

            if (prevPower == 0.0) {
            	prevPower = powerValue;
		startTime = timeValue;
            } else {
		actPower = powerValue;
		partialSum += prevPower + actPower;
		prevPower = actPower;
		finalTime = timeValue;
            }
	}

	return integral(startTime, finalTime, partialSum, cont);	
    }
    
    public double calc(String filename) {
        double result = 0;
        try {
            // open file
            inputBuffer = new BufferedReader( new FileReader(filename));
            // read and calc
            result = read();                                
        } catch (Exception ex) {
            //
        }
        
        return result;
    }


}
