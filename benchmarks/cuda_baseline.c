#include <stdio.h>
#include <stdlib.h>
#include <windows.h>

typedef int CUresult;
typedef void* CUdeviceptr;
typedef void* CUcontext;
typedef void* CUmodule;
typedef void* CUfunction;
typedef void* CUstream;
typedef void* CUevent;

typedef CUresult (__stdcall *PFN_cuInit)(unsigned int);
typedef CUresult (__stdcall *PFN_cuDeviceGet)(int*, int);
typedef CUresult (__stdcall *PFN_cuCtxCreate)(CUcontext*, unsigned int, int);
typedef CUresult (__stdcall *PFN_cuCtxDestroy)(CUcontext);
typedef CUresult (__stdcall *PFN_cuMemAlloc)(CUdeviceptr*, size_t);
typedef CUresult (__stdcall *PFN_cuMemFree)(CUdeviceptr);
typedef CUresult (__stdcall *PFN_cuMemcpyHtoD)(CUdeviceptr, const void*, size_t);
typedef CUresult (__stdcall *PFN_cuMemcpyDtoH)(void*, CUdeviceptr, size_t);
typedef CUresult (__stdcall *PFN_cuModuleLoadData)(CUmodule*, const void*);
typedef CUresult (__stdcall *PFN_cuModuleGetFunction)(CUfunction*, CUmodule, const char*);
typedef CUresult (__stdcall *PFN_cuLaunchKernel)(CUfunction, unsigned int, unsigned int, unsigned int,
                                                  unsigned int, unsigned int, unsigned int,
                                                  unsigned int, CUstream, void**, void**);
typedef CUresult (__stdcall *PFN_cuCtxSynchronize)(void);

static const char* ptx_src =
".version 7.1\n.target sm_86\n.address_size 64\n"
".visible .entry k_vec_add(.param .u64 d_a, .param .u64 d_b, .param .u64 d_c, .param .u32 n) {\n"
".reg .pred %p;\n.reg .b32 %r<5>;\n.reg .b64 %rd<8>;\n.reg .f32 %f<4>;\n"
"mov.u32 %r0, %ctaid.x;\nmov.u32 %r1, %ntid.x;\nmov.u32 %r2, %tid.x;\n"
"mad.lo.u32 %r3, %r0, %r1, %r2;\nld.param.u32 %r4, [n];\nsetp.ge.u32 %p, %r3, %r4;\n@%p bra DONE;\n"
"mul.wide.u32 %rd1, %r3, 4;\nld.param.u64 %rd2, [d_a];\nadd.u64 %rd3, %rd2, %rd1;\n"
"ld.global.f32 %f1, [%rd3];\nld.param.u64 %rd4, [d_b];\nadd.u64 %rd5, %rd4, %rd1;\n"
"ld.global.f32 %f2, [%rd5];\nadd.f32 %f3, %f1, %f2;\nld.param.u64 %rd6, [d_c];\n"
"add.u64 %rd7, %rd6, %rd1;\nst.global.f32 [%rd7], %f3;\nDONE:\nret;\n}\n"
".visible .entry k_gemm(.param .u64 d_a, .param .u64 d_b, .param .u64 d_c, .param .u32 M, .param .u32 N, .param .u32 K) {\n"
".reg .pred %p<3>;\n.reg .b32 %r<10>;\n.reg .b64 %rd<12>;\n.reg .f32 %f<5>;\n"
"mov.u32 %r0, %ctaid.y;\nmov.u32 %r1, %ntid.y;\nmov.u32 %r2, %tid.y;\nmad.lo.u32 %r3, %r0, %r1, %r2;\n"
"mov.u32 %r4, %ctaid.x;\nmov.u32 %r5, %ntid.x;\nmov.u32 %r6, %tid.x;\nmad.lo.u32 %r7, %r4, %r5, %r6;\n"
"ld.param.u32 %r8, [M];\nld.param.u32 %r9, [N];\nsetp.ge.u32 %p0, %r3, %r8;\nsetp.ge.u32 %p1, %r7, %r9;\n"
"or.pred %p2, %p0, %p1;\n@%p2 bra DONE_G;\nmov.f32 %f0, 0f00000000;\nmov.u32 %r0, 0;\nld.param.u32 %r1, [K];\n"
"LOOP_K:\nsetp.ge.u32 %p0, %r0, %r1;\n@%p0 bra WRITE_G;\nmad.lo.u32 %r2, %r3, %r1, %r0;\nmul.wide.u32 %rd1, %r2, 4;\n"
"ld.param.u64 %rd2, [d_a];\nadd.u64 %rd3, %rd2, %rd1;\nld.global.f32 %f1, [%rd3];\n"
"mad.lo.u32 %r2, %r0, %r9, %r7;\nmul.wide.u32 %rd4, %r2, 4;\nld.param.u64 %rd5, [d_b];\nadd.u64 %rd6, %rd5, %rd4;\n"
"ld.global.f32 %f2, [%rd6];\nfma.rn.f32 %f0, %f1, %f2, %f0;\nadd.u32 %r0, %r0, 1;\nbra LOOP_K;\n"
"WRITE_G:\nmad.lo.u32 %r2, %r3, %r9, %r7;\nmul.wide.u32 %rd7, %r2, 4;\nld.param.u64 %rd8, [d_c];\n"
"add.u64 %rd9, %rd8, %rd7;\nst.global.f32 [%rd9], %f0;\nDONE_G:\nret;\n}\n";

int main() {
    HMODULE hCuda = LoadLibraryA("nvcuda.dll");
    if (!hCuda) {
        printf("CUDA driver not found\n");
        return 1;
    }
    PFN_cuInit cuInit = (PFN_cuInit)GetProcAddress(hCuda, "cuInit");
    PFN_cuDeviceGet cuDeviceGet = (PFN_cuDeviceGet)GetProcAddress(hCuda, "cuDeviceGet");
    PFN_cuCtxCreate cuCtxCreate = (PFN_cuCtxCreate)GetProcAddress(hCuda, "cuCtxCreate_v2");
    if (!cuCtxCreate) cuCtxCreate = (PFN_cuCtxCreate)GetProcAddress(hCuda, "cuCtxCreate");
    PFN_cuMemAlloc cuMemAlloc = (PFN_cuMemAlloc)GetProcAddress(hCuda, "cuMemAlloc_v2");
    if (!cuMemAlloc) cuMemAlloc = (PFN_cuMemAlloc)GetProcAddress(hCuda, "cuMemAlloc");
    PFN_cuMemFree cuMemFree = (PFN_cuMemFree)GetProcAddress(hCuda, "cuMemFree_v2");
    if (!cuMemFree) cuMemFree = (PFN_cuMemFree)GetProcAddress(hCuda, "cuMemFree");
    PFN_cuMemcpyHtoD cuMemcpyHtoD = (PFN_cuMemcpyHtoD)GetProcAddress(hCuda, "cuMemcpyHtoD_v2");
    if (!cuMemcpyHtoD) cuMemcpyHtoD = (PFN_cuMemcpyHtoD)GetProcAddress(hCuda, "cuMemcpyHtoD");
    PFN_cuMemcpyDtoH cuMemcpyDtoH = (PFN_cuMemcpyDtoH)GetProcAddress(hCuda, "cuMemcpyDtoH_v2");
    if (!cuMemcpyDtoH) cuMemcpyDtoH = (PFN_cuMemcpyDtoH)GetProcAddress(hCuda, "cuMemcpyDtoH");
    PFN_cuModuleLoadData cuModuleLoadData = (PFN_cuModuleLoadData)GetProcAddress(hCuda, "cuModuleLoadData");
    PFN_cuModuleGetFunction cuModuleGetFunction = (PFN_cuModuleGetFunction)GetProcAddress(hCuda, "cuModuleGetFunction");
    PFN_cuLaunchKernel cuLaunchKernel = (PFN_cuLaunchKernel)GetProcAddress(hCuda, "cuLaunchKernel");
    PFN_cuCtxSynchronize cuCtxSynchronize = (PFN_cuCtxSynchronize)GetProcAddress(hCuda, "cuCtxSynchronize");

    cuInit(0);
    int dev = 0;
    cuDeviceGet(&dev, 0);
    CUcontext ctx;
    cuCtxCreate(&ctx, 0, dev);

    CUmodule mod;
    cuModuleLoadData(&mod, ptx_src);
    CUfunction fn_add, fn_gemm;
    cuModuleGetFunction(&fn_add, mod, "k_vec_add");
    cuModuleGetFunction(&fn_gemm, mod, "k_gemm");

    LARGE_INTEGER freq, t0, t1;
    QueryPerformanceFrequency(&freq);

    // Benchmark 1: Vector Add (1,000,000 floats x 50 iterations)
    int n = 1000000;
    size_t sz = n * sizeof(float);
    CUdeviceptr da, db, dc;
    cuMemAlloc(&da, sz);
    cuMemAlloc(&db, sz);
    cuMemAlloc(&dc, sz);

    void* args_add[] = { &da, &db, &dc, &n };
    int block_x = 256;
    int grid_x = (n + 255) / 256;

    // Warmup
    cuLaunchKernel(fn_add, grid_x, 1, 1, block_x, 1, 1, 0, NULL, args_add, NULL);
    cuCtxSynchronize();

    QueryPerformanceCounter(&t0);
    for (int i = 0; i < 50; i++) {
        cuLaunchKernel(fn_add, grid_x, 1, 1, block_x, 1, 1, 0, NULL, args_add, NULL);
    }
    cuCtxSynchronize();
    QueryPerformanceCounter(&t1);
    double ms_vec_add = ((double)(t1.QuadPart - t0.QuadPart) * 1000.0) / (double)freq.QuadPart;
    printf("CUDA_VEC_ADD_50_ITERS_MS=%.4f\n", ms_vec_add);

    // Benchmark 2: GEMM 256x256 (50 iterations)
    int M = 256, N = 256, K = 256;
    size_t sz_m = M * N * sizeof(float);
    CUdeviceptr ga, gb, gc;
    cuMemAlloc(&ga, sz_m);
    cuMemAlloc(&gb, sz_m);
    cuMemAlloc(&gc, sz_m);
    void* args_gemm[] = { &ga, &gb, &gc, &M, &N, &K };
    int gemm_bx = 16, gemm_by = 16;
    int gemm_gx = (N + 15) / 16, gemm_gy = (M + 15) / 16;

    // Warmup
    cuLaunchKernel(fn_gemm, gemm_gx, gemm_gy, 1, gemm_bx, gemm_by, 1, 0, NULL, args_gemm, NULL);
    cuCtxSynchronize();

    QueryPerformanceCounter(&t0);
    for (int i = 0; i < 50; i++) {
        cuLaunchKernel(fn_gemm, gemm_gx, gemm_gy, 1, gemm_bx, gemm_by, 1, 0, NULL, args_gemm, NULL);
    }
    cuCtxSynchronize();
    QueryPerformanceCounter(&t1);
    double ms_gemm = ((double)(t1.QuadPart - t0.QuadPart) * 1000.0) / (double)freq.QuadPart;
    printf("CUDA_GEMM_256_50_ITERS_MS=%.4f\n", ms_gemm);

    cuMemFree(da); cuMemFree(db); cuMemFree(dc);
    cuMemFree(ga); cuMemFree(gb); cuMemFree(gc);
    return 0;
}
