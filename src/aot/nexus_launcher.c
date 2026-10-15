// ==============================================================================
// Nexus Baremetal - Standalone AOT Executable Launcher
// ==============================================================================
// Embeds the Nexus baremetal runtime (VM, compiler assembly, standard library)
// and user application payload into a zero-dependency portable executable.
// ==============================================================================

#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define RES_ID_VM_CORE     101
#define RES_ID_COMPILER    102
#define RES_ID_PAYLOAD     103
#define RES_ID_STDLIB      104

static int write_resource_to_file(int res_id, const char *filepath, int check_size) {
    HRSRC hRes = FindResourceA(NULL, MAKEINTRESOURCEA(res_id), (LPCSTR)RT_RCDATA);
    if (!hRes) return 0;
    DWORD size = SizeofResource(NULL, hRes);
    HGLOBAL hData = LoadResource(NULL, hRes);
    if (!hData) return 0;
    const void *ptr = LockResource(hData);
    if (!ptr) return 0;

    if (check_size) {
        HANDLE hExisting = CreateFileA(filepath, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
        if (hExisting != INVALID_HANDLE_VALUE) {
            DWORD existing_size = GetFileSize(hExisting, NULL);
            CloseHandle(hExisting);
            if (existing_size == size) {
                return 1; // already exists with matching size
            }
        }
    }

    HANDLE hFile = CreateFileA(filepath, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hFile == INVALID_HANDLE_VALUE) return 0;
    DWORD written = 0;
    BOOL ok = WriteFile(hFile, ptr, size, &written, NULL);
    CloseHandle(hFile);
    return ok && (written == size);
}

int main(int argc, char **argv) {
    char temp_dir[MAX_PATH];
    DWORD len = GetTempPathA(MAX_PATH, temp_dir);
    if (len == 0 || len >= MAX_PATH) {
        strcpy(temp_dir, ".");
    }

    char rt_dir[MAX_PATH];
    snprintf(rt_dir, sizeof(rt_dir), "%snexus_baremetal_rt", temp_dir);
    CreateDirectoryA(rt_dir, NULL);

    char rt_lib_dir[MAX_PATH];
    snprintf(rt_lib_dir, sizeof(rt_lib_dir), "%s\\lib", rt_dir);
    CreateDirectoryA(rt_lib_dir, NULL);

    char vm_exe[MAX_PATH];
    snprintf(vm_exe, sizeof(vm_exe), "%s\\nexus_core.exe", rt_dir);

    char compiler_nxasm[MAX_PATH];
    snprintf(compiler_nxasm, sizeof(compiler_nxasm), "%s\\compiler_full.nxasm", rt_dir);

    char stdlib_nx[MAX_PATH];
    snprintf(stdlib_nx, sizeof(stdlib_nx), "%s\\stdlib.nx", rt_lib_dir);

    // Extract runtime components if needed (cached by size check)
    if (!write_resource_to_file(RES_ID_VM_CORE, vm_exe, 1)) {
        fprintf(stderr, "[Nexus AOT] Error: Failed to extract VM runtime to %s\n", vm_exe);
        return 1;
    }
    if (!write_resource_to_file(RES_ID_COMPILER, compiler_nxasm, 1)) {
        fprintf(stderr, "[Nexus AOT] Error: Failed to extract compiler to %s\n", compiler_nxasm);
        return 1;
    }
    write_resource_to_file(RES_ID_STDLIB, stdlib_nx, 1);

    // Extract payload script (unique per process)
    char script_file[MAX_PATH];
    DWORD pid = GetCurrentProcessId();
    DWORD tick = GetTickCount();
    snprintf(script_file, sizeof(script_file), "%s\\payload_%lu_%lu.nx", rt_dir, pid, tick);

    if (!write_resource_to_file(RES_ID_PAYLOAD, script_file, 0)) {
        fprintf(stderr, "[Nexus AOT] Error: Failed to extract payload script\n");
        return 1;
    }

    // Build command line: "vm_exe" "compiler_nxasm" "script_file" [forwarded arguments]
    size_t cmd_len = strlen(vm_exe) + strlen(compiler_nxasm) + strlen(script_file) + 64;
    for (int i = 1; i < argc; i++) {
        cmd_len += strlen(argv[i]) + 4;
    }

    char *cmdline = (char *)malloc(cmd_len);
    if (!cmdline) {
        DeleteFileA(script_file);
        return 1;
    }

    snprintf(cmdline, cmd_len, "\"%s\" \"%s\" \"%s\"", vm_exe, compiler_nxasm, script_file);
    for (int i = 1; i < argc; i++) {
        strcat(cmdline, " \"");
        strcat(cmdline, argv[i]);
        strcat(cmdline, "\"");
    }

    STARTUPINFOA si;
    PROCESS_INFORMATION pi;
    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    ZeroMemory(&pi, sizeof(pi));

    BOOL success = CreateProcessA(
        NULL,
        cmdline,
        NULL,
        NULL,
        TRUE, // inherit standard handles (stdout/stderr/stdin)
        0,
        NULL,
        NULL, // preserve user's current working directory
        &si,
        &pi
    );

    free(cmdline);

    if (!success) {
        fprintf(stderr, "[Nexus AOT] Error: Failed to launch Nexus runtime (Error %lu)\n", GetLastError());
        DeleteFileA(script_file);
        return 1;
    }

    WaitForSingleObject(pi.hProcess, INFINITE);

    DWORD exit_code = 0;
    GetExitCodeProcess(pi.hProcess, &exit_code);

    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);

    DeleteFileA(script_file);

    return (int)exit_code;
}
