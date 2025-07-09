#include <iostream>
#include <string>
#include <cstdlib>  


using std::string;
using std::cout;
using std::cerr;
using std::endl;


bool is_ghostty_floating() {
    cout << "retornando true em is_ghostty_floating()" << endl;
    return true;

}

int main() {
    if (!is_ghostty_floating()) {
        int result = system("ghostty");
        if (result == 0) {
            cout << "comando executado com sucesso" << endl;
        }
        else {
            cerr << "erro ao executar comando" << endl;
        }
        //execute
        cout << "ghostty nao estava snedo executado deu !is_ghostty_floating()";
    }
    else {
        cout << "ghostty ja esta sendo executado" << endl;
    }
}
