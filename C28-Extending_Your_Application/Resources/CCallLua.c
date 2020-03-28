#include <stdio.h>

void readFile(const char * fileName)
{
    FILE *f = fopen(fileName, "rb");
    char buff[2048];
    fgets(buff, 2048, f);
    printf("2:%s\n", buff);
}

int main(int argc, char *argv[])
{
    if(argc < 2)
    {
        printf("缺少文件名\n");
        return 0;
    }
    readFile(argv[2]);
    return 0;
}