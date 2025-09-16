#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void print_status(const char *status) {
    char icon[16] = "";
    char tooltip[64] = "";
    char css_class[64] = "";

    if (strcmp(status, "Playing") == 0) {
        strcpy(icon, " ⏭ ");
        strcpy(tooltip, "Next");
        strcpy(css_class, "next_button");
    } else if (strcmp(status, "Paused") == 0) {
        strcpy(icon, " ⏭ ");
        strcpy(tooltip, "Next");
        strcpy(css_class, "next_button");
    } else {
        // stopped or unknown
        strcpy(icon, "");
        strcpy(tooltip, "");
        strcpy(css_class, "");
    }

    printf("{\"text\":\"%s\",\"tooltip\":\"%s\",\"class\":\"%s\"}\n",
           icon, tooltip, css_class);
    fflush(stdout);
}

int main(void) {
    char buffer[128];

    // --- initial status ---
    FILE *fp = popen("playerctl status 2>/dev/null", "r");
    if (fp) {
        if (fgets(buffer, sizeof(buffer), fp)) {
            buffer[strcspn(buffer, "\n")] = '\0'; // strip newline
            print_status(buffer);
        } else {
            print_status("Stopped");
        }
        pclose(fp);
    } else {
        print_status("Stopped");
    }

    // --- follow events ---
    fp = popen("playerctl --follow status 2>/dev/null", "r");
    if (!fp) {
        perror("popen");
        return 1;
    }

    while (fgets(buffer, sizeof(buffer), fp)) {
        buffer[strcspn(buffer, "\n")] = '\0';
        print_status(buffer);
    }

    pclose(fp);
    return 0;
}

