//
// Defines the entry point for the program
//

int main(int, char **) {
  int * const values = new int[10];
  for(auto i = 0; i < 10; ++i) {
    values[i] = i;
  }
  delete[] values;
  return 0;
}
