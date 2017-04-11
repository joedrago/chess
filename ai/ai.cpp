#include <windows.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    if(argc < 2)
        return 0;

    fprintf(stderr, "Incoming FEN: %s\n", argv[1]);
    fprintf(stderr, "Thinking really hard for 5 seconds...\n");
    fflush(stderr);
    Sleep(5000);

    fprintf(stdout, "e5\n");
    fflush(stdout);
    return 0;
}