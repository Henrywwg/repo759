#include <iostream>
using namespace std;

// Read in cmdline value

int main(int argc, char* argv[]) {
    int n = 0;
    if (argc > 1) 
        n = atoi(argv[1]);
    else 
        return 1;

    for (int i = 0; i <= n; i++) 
        printf("%d ", i);
    printf("\n");

    for (int i = n; i >= 0; i--) 
        cout << i << " ";
    cout << endl;
    
    return 0;
}