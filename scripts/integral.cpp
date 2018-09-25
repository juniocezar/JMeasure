/* 
	
	This program uses the trapezoidal rule to calculate the integral of
	values of time and instantaneous power. 

	Author: Tarsila Bessa Nogueira Assuncao
	Date:  02-16-2016 

	Compile: g++ integral.cpp -o integral
	Run: ./integral file.txt
	
*/

#include <iomanip>
#include <iostream>
#include <fstream>

void integral(double *startTime, double *finalTime, double *partialSum, int *cont, std::ofstream &output) {

	double h, result;

	h = (*finalTime - *startTime)/(*cont);

	result = (*partialSum * (h/2));
	
	std::cout << "The total consumed energy is: " << result << "\n";
}

void read(std::ifstream &input, std::ofstream &output) {
	double powerValue, timeValue, actPower, prevPower, startTime, finalTime, partialSum;
	int cont;

	cont = 0;
	prevPower = 0.0;
	actPower = 0.0;
	partialSum = 0.0;

	while (1) {
		input >> timeValue >> powerValue;

		if (input.eof()) {
			break;
		}

		cont++;

		if (prevPower == 0.0) {
			prevPower = powerValue;
			startTime = timeValue;
		}

		else {
			actPower = powerValue;
			partialSum += prevPower + actPower;
			prevPower = actPower;
			finalTime = timeValue;
		}
	}

	integral(&startTime, &finalTime, &partialSum, &cont, output);
	
}

int main (int argc, char *argv[]) {

	std::ifstream input;
	std::ofstream output;
	input.open(argv[1]);
	output.open("energy.txt");
	read(input, output);
	input.close();
	output.close();
}