// Minimal syscall stubs for newlib on bare-metal

#include <sys/stat.h>
#include <sys/types.h>
#include <errno.h>

extern "C" {

// Heap management
extern char _bss_end;  // Defined by linker script
static char* heap_end = &_bss_end;

void* _sbrk(int incr) {
    char* prev_heap_end = heap_end;
    heap_end += incr;
    return prev_heap_end;
}

// File operations (stub - not used)
int _close(int file) {
    return -1;
}

int _read(int file, char* ptr, int len) {
    return 0;
}

int _write(int file, char* ptr, int len) {
    return len;  // Pretend we wrote everything
}

int _lseek(int file, int ptr, int dir) {
    return 0;
}

int _fstat(int file, struct stat* st) {
    st->st_mode = S_IFCHR;
    return 0;
}

int _isatty(int file) {
    return 1;
}

// Process control (stub)
void _exit(int status) {
    while (1) {
        __asm__ volatile("wfi");
    }
}

int _kill(int pid, int sig) {
    errno = EINVAL;
    return -1;
}

int _getpid(void) {
    return 1;
}

}  // extern "C"
