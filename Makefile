INC=-I/opt/homebrew/include -I/opt/homebrew/Cellar/libomp/20.1.8/include
LIB=-L/opt/homebrew/lib -L/opt/homebrew/Cellar/libomp/20.1.8/lib -lgmp

build:
	clang++ parallel_modular_exponentiation.cpp -std=c++11 $(INC) $(LIB) -Xpreprocessor -fopenmp -lomp -o rsa_parallel
	clang++ rsa_serial.cpp -std=c++11 $(INC) $(LIB) -o rsa_serial
	clang++ rsa_parallel_naive_approach.cpp -std=c++11 $(INC) $(LIB) -Xpreprocessor -fopenmp -lomp -o rsa_naive

clean:
	rm -f rsa_parallel rsa_serial rsa_naive