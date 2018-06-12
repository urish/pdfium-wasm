#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include "fpdfview.h"
#include "fpdf_dataavail.h"

FPDF_BOOL Is_Data_Avail(FX_FILEAVAIL *avail, size_t offset, size_t size)
{
    return true;
}

int GetBlock(void *param, unsigned long position, unsigned char *pBuf, unsigned long size)
{
    int fd = *(int *)param;
    lseek(fd, position, SEEK_SET);
    return read(fd, pBuf, size);
}

int main()
{
    const char *fname = "src/web-assembly.pdf";
    int fd = open(fname, O_RDONLY);
    int len = 0;

    printf("open(%s): %d\n", fname, fd);
    len = lseek(fd, 0, SEEK_END);
    printf("size: %d bytes\n", len);
    FPDF_InitLibrary();

    FPDF_FILEACCESS file_access;
    memset(&file_access, '\0', sizeof(file_access));
    file_access.m_FileLen = len;
    file_access.m_GetBlock = GetBlock;
    file_access.m_Param = &fd;

    FX_FILEAVAIL file_avail;
    memset(&file_avail, '\0', sizeof(file_avail));
    file_avail.version = 1;
    file_avail.IsDataAvail = Is_Data_Avail;

    FPDF_AVAIL pdf_avail = FPDFAvail_Create(&file_avail, &file_access);
    FPDF_DOCUMENT doc = FPDFAvail_GetDocument(pdf_avail, NULL);
    printf("pages: %d\n", FPDF_GetPageCount(doc));

    FPDF_CloseDocument(doc);
    FPDFAvail_Destroy(pdf_avail);

    FPDF_DestroyLibrary();
    close(fd);
    printf("closed.\n");
}
