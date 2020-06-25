/* Golden Measure implementation of Binary Coded Decimal Converter
*/

#include <chrono>    // now
#include <iostream>  // std::cout
#include <stdint.h>  // uint32_t
#include <stdio.h>   // printf
#include <vector>    // std::vector

using namespace std;

// return a vector of chars, one for each nibble of the BCD representation of the input
vector<char> BCD_Encoder(uint32_t input) {
    vector<char> output(10, 0);

    for (auto i = 32; i > 0; i--) {
        // check if nibble >= 5, if so += 3
        for (auto j = 0; j < 10; j++) {
            if (output[j] >= 5) { output[j] += 3; }
        }

        // shift left
        for (auto j = 9; j > 0; j--) {
            output[j] <<= 1;
            if ((output[j - 1] & 0b00001000) != 0) { output[j] += 1; }
        }
        // shift input into first register
        output[0] <<= 1;
        if ((input & (1 << (i - 1))) != 0) { output[0] += 1; }

        // reset upper bits
        for (auto j = 0; j < 10; j++) {
            output[j] &= 0b00001111;
        }
    }

    return output;
}

long long time_encoder(int n) {
    uint32_t binary = rand();

    auto start = std::chrono::high_resolution_clock::now();
    for (auto i = 0; i < n; i++) {
         BCD_Encoder(binary);
    }
    auto elapsed = std::chrono::high_resolution_clock::now() - start;
    
    return chrono::duration_cast<std::chrono::microseconds>(elapsed).count();
}

void test_encoder() {
    uint32_t binaryInput = 123456789;
    printf("Binary: 0x%x (dec: %d)\n", binaryInput, binaryInput);
    vector<char> bcdResult = BCD_Encoder(binaryInput);
    cout << "\nBCD: ";
    for (auto i = 0; i < 10; i++) {
        cout << (int)bcdResult[9 - i];
    }
    cout << endl;
}

int main(void) {

    for (auto i = 0; i < 10; i++) {
        cout << time_encoder(1e5)/1e5 << endl;
    }

   for (auto i = 1; i <= 100; i++) {
        cout << time_encoder(i) << endl;
    }

    return 0;
}