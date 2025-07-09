#include <cstdlib>  
#include <iostream>
#include <string>
// do chat:
#include <cstdio>
#include <sstream>
#include <cstdio>
#include <cstring>

using std::cout;
using std::cerr;
using std::string;
using std::endl;

void show_floorp_from_scratchpad() {
    system("swaymsg \"[app_id=\\\"one.ablaze.floorp\\\"] scratchpad show\"");
}

void move_floating_floorp_to_scratchpad() {
    FILE* pipe = popen(
        "swaymsg -t get_tree | jq -r "
        "'.. | objects? | select(.app_id? == \"one.ablaze.floorp\" and .floating == \"user_on\") | .id'",
        "r"
    );

    if (!pipe) return;

    char line[64];
    while (fgets(line, sizeof(line), pipe)) {
        size_t len = strlen(line);
        if (len > 0 && line[len - 1] == '\n') line[len - 1] = '\0';

        char cmd[128];
        snprintf(cmd, sizeof(cmd), "swaymsg \"[con_id=%s] move scratchpad\"", line);
        system(cmd);
    }

    pclose(pipe);
}

bool is_floorp_floating() {
    const char* cmd = 
        "swaymsg -t get_tree | jq '.. | objects | select(.type? == \"floating_con\" and .app_id? == \"one.ablaze.floorp\")' | rg one.ablaze.floorp";

    FILE* pipe = popen(cmd, "r");
    if (!pipe) {
        cerr << "Erro ao executar comando de verificação" << endl;
        return false;
    } 

    char buffer[256];
    bool found = false;

    if (fgets(buffer, sizeof(buffer), pipe) != nullptr) {
        found = true;
    }

    pclose(pipe);
    return found;
}

class executor {
private:
    string browser, engine;
public:
    executor() : browser("firefox"), engine("flatpak") {}

    string getBrowser() {
        cout << "Browser Selecionado: " << browser << endl;
        return browser;
    }
    string getEngine() {
        cout << "Engine Selecionada: " << engine << endl;
        return engine;
    }
    void setBrowser(const string& nome) {
        if (nome == "chrome") browser = "chrome";
        else if (nome == "firefox") browser = "firefox";
        else if (nome == "brave") browser = "brave";
        else {
            browser = "unknown";
            cerr << "browser invalido" << endl;
        } 
    }
    void setEngine(const string& name) {
        if (name == "flatpak") engine = "flatpak";
        else if (name == "linux") engine = "linux";
        else {
            engine = "unknown";
            cerr << "Engine Invalida" << endl;
        }
    }
    void launchBrowser() {
        string clisequentialcall = " && ";
        string clisleepcall = "sleep 0.5";
        string clifloatingcall = "swaymsg floating enable";
        string cliresizecall = "swaymsg resize set width 950px height 1000px";
        string climovecall = "swaymsg move position center";
        string clienginecall = "";
        string clibrowsercall = "";

        if (browser == "firefox") {
            if (engine == "flatpak") {
                clienginecall = "flatpak run";
                clibrowsercall = " one.ablaze.floorp";
            }
            // TODO: add new engines
        }
        // TODO: add new browsers
        if (browser == "unknown" || engine == "unknown") {
            cerr << "não é possível executar com browser ou engine desconhecido" << endl;
            return;
        }

        string cmd = clienginecall + clibrowsercall +
             clisequentialcall + clisleepcall +
             clisequentialcall + clifloatingcall +
             clisequentialcall + climovecall +
             clisequentialcall + cliresizecall;

        cout << "Comando a ser executado: " << cmd << endl;

        int result = system(cmd.c_str());
        if (result == 0) {
            cout << "comando executado com sucesso" << endl; 
        }
        else { 
            cerr << "erro ao executar comando" << endl;
        }
    }

};


bool scratchpad_has_windows() {
    FILE* pipe = popen("swaymsg -t get_tree | jq -e '.. | objects | select(.scratchpad_state == \"changed\")' > /dev/null", "r");
    if (!pipe) return false;
    int status = pclose(pipe);
    return status == 0;
}

void ToggleScratchpad() {
    if (scratchpad_has_windows()) {
        int result = system("swaymsg scratchpad show");
        if (result == 0) {
            cout << "comando executado com sucesso" << endl; 
        }
        else { 
            cerr << "erro ao executar comando" << endl;
        }
    }

    else {
        int result = system("swaymsg move scratchpad");
        if (result == 0) {
            cout << "comando executado com sucesso" << endl; 
        }
        else { 
            cerr << "erro ao executar comando" << endl;
        }
    }
}


/*int main() {*/
/*    executor floatFloorp;*/
/**/
/*    if (!is_floorp_floating()) {*/
/*        floatFloorp.launchBrowser();*/
/*    } */
/*    else {*/
/*        cout << "O navegador já está flutuando. Toggle scratchpad..." << endl;*/
/*        move_floating_floorp_to_scratchpad();*/
/*    }*/
/**/
/**/
/*    return 0;*/
/*}*/


int main() {
    executor floatFloorp;

    if (!is_floorp_floating()) {
        floatFloorp.launchBrowser();
    } 
    else {
        cout << "O navegador já está flutuando. Toggle scratchpad..." << endl;

        // Tenta trazer de volta do scratchpad se já estiver lá
        int result = system("swaymsg \"[app_id=\\\"one.ablaze.floorp\\\"] scratchpad show\"");
        if (result != 0) {
            cerr << "erro ao tentar mostrar do scratchpad, movendo para lá..." << endl;
            move_floating_floorp_to_scratchpad();
        }
    }

    return 0;
}
