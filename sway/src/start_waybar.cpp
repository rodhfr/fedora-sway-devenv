#include <iostream>
#include <cstdlib>
#include <unistd.h>

bool is_waybar_running() {
    return system("pgrep -x nwg-panel > /dev/null") == 0;
}

void kill_waybar() {
    std::cout << "Nwg-panel já está rodando. Reiniciando..." << std::endl;
    system("pkill -x nwg-panel");
    sleep(1);
}

int main() {
    if (is_waybar_running()) {
        kill_waybar();
    }

    std::cout << "Iniciando nwg-panel..." << std::endl;
    system("nwg-panel > ~/.local/share/nwg-panel.log 2>&1 &");

    return 0;
}

