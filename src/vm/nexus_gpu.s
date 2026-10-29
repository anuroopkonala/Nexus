# ==============================================================================
# Nexus Baremetal - Pure x86-64 Assembly GPU Acceleration Subsystem
# File: src/vm/nexus_gpu.s
# 100% Hand-Written Assembly - Zero external languages, zero third-party dependencies.
# Direct Hardware Driver Interface for NVIDIA GPUs (RTX 3050 & beyond)
# ==============================================================================

.intel_syntax noprefix

.data
.align 16

# --- DLL and Function Name Strings for Dynamic Driver Binding ---
gpu_str_nvcuda:           .asciz "nvcuda.dll"
gpu_str_cuInit:           .asciz "cuInit"
gpu_str_cuDeviceGetCount: .asciz "cuDeviceGetCount"
gpu_str_cuDeviceGet:      .asciz "cuDeviceGet"
gpu_str_cuDeviceGetName:  .asciz "cuDeviceGetName"
gpu_str_cuDeviceTotalMem: .asciz "cuDeviceTotalMem_v2"
gpu_str_cuDeviceTotalMem_old: .asciz "cuDeviceTotalMem"
gpu_str_cuCtxCreate:      .asciz "cuCtxCreate_v2"
gpu_str_cuCtxCreate_old:  .asciz "cuCtxCreate"
gpu_str_cuCtxDestroy:     .asciz "cuCtxDestroy_v2"
gpu_str_cuCtxDestroy_old: .asciz "cuCtxDestroy"
gpu_str_cuCtxSynchronize: .asciz "cuCtxSynchronize"
gpu_str_cuMemAlloc:       .asciz "cuMemAlloc_v2"
gpu_str_cuMemAlloc_old:   .asciz "cuMemAlloc"
gpu_str_cuMemFree:        .asciz "cuMemFree_v2"
gpu_str_cuMemFree_old:    .asciz "cuMemFree"
gpu_str_cuMemcpyHtoD:     .asciz "cuMemcpyHtoD_v2"
gpu_str_cuMemcpyHtoD_old: .asciz "cuMemcpyHtoD"
gpu_str_cuMemcpyDtoH:     .asciz "cuMemcpyDtoH_v2"
gpu_str_cuMemcpyDtoH_old: .asciz "cuMemcpyDtoH"
gpu_str_cuMemcpyDtoD:     .asciz "cuMemcpyDtoD_v2"
gpu_str_cuMemcpyDtoD_old: .asciz "cuMemcpyDtoD"
gpu_str_cuModuleLoadData: .asciz "cuModuleLoadData"
gpu_str_cuModuleGetFunction: .asciz "cuModuleGetFunction"
gpu_str_cuLaunchKernel:   .asciz "cuLaunchKernel"
gpu_str_cuStreamCreate:   .asciz "cuStreamCreate"
gpu_str_cuStreamDestroy:  .asciz "cuStreamDestroy_v2"
gpu_str_cuStreamDestroy_old: .asciz "cuStreamDestroy"
gpu_str_cuStreamSynchronize: .asciz "cuStreamSynchronize"
gpu_str_cuEventCreate:        .asciz "cuEventCreate"
gpu_str_cuEventRecord:        .asciz "cuEventRecord"
gpu_str_cuEventSynchronize:   .asciz "cuEventSynchronize"
gpu_str_cuEventElapsedTime:   .asciz "cuEventElapsedTime"
gpu_str_cuEventDestroy:       .asciz "cuEventDestroy_v2"
gpu_str_cuEventDestroy_old:   .asciz "cuEventDestroy"
gpu_str_cuMemAllocManaged:     .asciz "cuMemAllocManaged"
gpu_str_cuMemAllocHost:        .asciz "cuMemAllocHost_v2"
gpu_str_cuMemAllocHost_old:    .asciz "cuMemAllocHost"
gpu_str_cuMemFreeHost:         .asciz "cuMemFreeHost"
gpu_str_cuMemGetInfo:          .asciz "cuMemGetInfo_v2"
gpu_str_cuMemGetInfo_old:      .asciz "cuMemGetInfo"
gpu_str_cuMemcpyHtoDAsync:     .asciz "cuMemcpyHtoDAsync_v2"
gpu_str_cuMemcpyHtoDAsync_old: .asciz "cuMemcpyHtoDAsync"
gpu_str_cuMemcpyDtoHAsync:     .asciz "cuMemcpyDtoHAsync_v2"
gpu_str_cuMemcpyDtoHAsync_old: .asciz "cuMemcpyDtoHAsync"
gpu_str_cuMemcpyDtoDAsync:     .asciz "cuMemcpyDtoDAsync_v2"
gpu_str_cuMemcpyDtoDAsync_old: .asciz "cuMemcpyDtoDAsync"
gpu_str_cuMemPrefetchAsync:    .asciz "cuMemPrefetchAsync"
gpu_str_cuStreamWaitEvent:     .asciz "cuStreamWaitEvent"
gpu_str_cuStreamQuery:         .asciz "cuStreamQuery"
gpu_str_cuEventQuery:          .asciz "cuEventQuery"

# Kernel Names
gpu_kname_vec_add:     .asciz "k_vec_add"
gpu_kname_vec_sub:     .asciz "k_vec_sub"
gpu_kname_vec_mul:     .asciz "k_vec_mul"
gpu_kname_vec_div:     .asciz "k_vec_div"
gpu_kname_vec_scale:   .asciz "k_vec_scale"
gpu_kname_relu:        .asciz "k_relu"
gpu_kname_sigmoid:     .asciz "k_sigmoid"
gpu_kname_fill:        .asciz "k_fill"
gpu_kname_tiled_gemm:  .asciz "k_tiled_gemm"
gpu_kname_rgb_to_gray: .asciz "k_rgb_to_gray"
gpu_kname_transpose:   .asciz "k_transpose"
gpu_kname_gelu:        .asciz "k_gelu"
gpu_kname_silu:        .asciz "k_silu"
gpu_kname_softmax:     .asciz "k_softmax"
gpu_kname_layernorm:   .asciz "k_layernorm"
gpu_kname_rmsnorm:     .asciz "k_rmsnorm"
gpu_kname_conv2d:      .asciz "k_conv2d"
gpu_kname_maxpool2d:   .asciz "k_maxpool2d"
gpu_kname_blur:        .asciz "k_gaussian_blur"
gpu_kname_sobel:       .asciz "k_sobel"
gpu_kname_resize:      .asciz "k_resize_bilinear"

gpu_fallback_name:     .asciz "Nexus Baremetal SIMD AVX2 Engine"

# --- Driver Function Pointers ---
.align 8
gpu_hmodule:             .quad 0
gpu_p_cuInit:            .quad 0
gpu_p_cuDeviceGetCount:  .quad 0
gpu_p_cuDeviceGet:       .quad 0
gpu_p_cuDeviceGetName:   .quad 0
gpu_p_cuDeviceTotalMem:  .quad 0
gpu_p_cuCtxCreate:       .quad 0
gpu_p_cuCtxDestroy:      .quad 0
gpu_p_cuCtxSynchronize:  .quad 0
gpu_p_cuMemAlloc:        .quad 0
gpu_p_cuMemFree:         .quad 0
gpu_p_cuMemcpyHtoD:      .quad 0
gpu_p_cuMemcpyDtoH:      .quad 0
gpu_p_cuMemcpyDtoD:      .quad 0
gpu_p_cuModuleLoadData:  .quad 0
gpu_p_cuModuleGetFunction: .quad 0
gpu_p_cuLaunchKernel:    .quad 0
gpu_p_cuStreamCreate:    .quad 0
gpu_p_cuStreamDestroy:   .quad 0
gpu_p_cuStreamSynchronize: .quad 0
gpu_p_cuEventCreate:          .quad 0
gpu_p_cuEventRecord:          .quad 0
gpu_p_cuEventSynchronize:     .quad 0
gpu_p_cuEventElapsedTime:     .quad 0
gpu_p_cuEventDestroy:         .quad 0
gpu_p_cuMemAllocManaged:     .quad 0
gpu_p_cuMemAllocHost:        .quad 0
gpu_p_cuMemFreeHost:         .quad 0
gpu_p_cuMemGetInfo:          .quad 0
gpu_p_cuMemcpyHtoDAsync:     .quad 0
gpu_p_cuMemcpyDtoHAsync:     .quad 0
gpu_p_cuMemcpyDtoDAsync:     .quad 0
gpu_p_cuMemPrefetchAsync:    .quad 0
gpu_p_cuStreamWaitEvent:     .quad 0
gpu_p_cuStreamQuery:         .quad 0
gpu_p_cuEventQuery:          .quad 0

# Kernel Function Handles
gpu_fn_vec_add:     .quad 0
gpu_fn_vec_sub:     .quad 0
gpu_fn_vec_mul:     .quad 0
gpu_fn_vec_div:     .quad 0
gpu_fn_vec_scale:   .quad 0
gpu_fn_relu:        .quad 0
gpu_fn_sigmoid:     .quad 0
gpu_fn_fill:        .quad 0
gpu_fn_tiled_gemm:  .quad 0
gpu_fn_rgb_to_gray: .quad 0
gpu_fn_transpose:   .quad 0
gpu_fn_gelu:        .quad 0
gpu_fn_silu:        .quad 0
gpu_fn_softmax:     .quad 0
gpu_fn_layernorm:   .quad 0
gpu_fn_rmsnorm:     .quad 0
gpu_fn_conv2d:      .quad 0
gpu_fn_maxpool2d:   .quad 0
gpu_fn_blur:        .quad 0
gpu_fn_sobel:       .quad 0
gpu_fn_resize:      .quad 0

# Engine State
gpu_is_inited:      .long 0
gpu_has_cuda:       .long 0
gpu_dev_count:      .long 0
gpu_dev_id:         .long 0
gpu_ctx:            .quad 0
gpu_module:         .quad 0
gpu_total_vram:     .quad 0
gpu_device_name:    .space 256

# Handle Table for Memory Safety (up to 16384 handles, 48 bytes each)
# [0]: handle_id (quad)
# [8]: type (quad: 1=buffer, 2=tensor, 3=kernel)
# [16]: d_ptr (quad: GPU VRAM pointer or host heap pointer)
# [24]: size_bytes (quad)
# [32]: is_device (quad: 1=CUDA, 0=Host)
# [40]: dim0 (long), dim1 (long)
.align 16
gpu_next_handle_id: .quad 1
gpu_handle_table:   .space 786432   # 16384 * 48 bytes

# --- Pure Assembly Fast VRAM Slab Allocator Cache (512 slots) ---
.align 16
gpu_vram_pool_count:  .quad 0
# Each slot: [0..7]: d_ptr (64-bit), [8..15]: capacity_bytes (64-bit)
gpu_vram_pool:        .space 8192  # 512 slots * 16 bytes

# --- Embedded PTX Assembly Compute Kernels ---
.align 16
gpu_ptx_code:
.ascii ".version 7.1\n.target sm_86\n.address_size 64\n"
.ascii ".visible .entry k_vec_add(.param .u64 d_a, .param .u64 d_b, .param .u64 d_c, .param .u32 n) {\n.reg .pred %p<4>;\n.reg .b32 %r<8>;\n.reg .b64 %rd<8>;\n.reg .f32 %f<12>;\nmov.u32 %r0, %ctaid.x;\nmov.u32 %r1, %ntid.x;\nmov.u32 %r2, %tid.x;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nld.param.u32 %r4, [n];\nshr.u32 %r5, %r4, 2;\nsetp.ge.u32 %p0, %r3, %r5;\n@%p0 bra TAIL_ADD;\nshl.b32 %r6, %r3, 4;\nmul.wide.u32 %rd1, %r6, 1;\nld.param.u64 %rd2, [d_a];\nadd.u64 %rd3, %rd2, %rd1;\nld.global.v4.f32 {%f0, %f1, %f2, %f3}, [%rd3];\nld.param.u64 %rd4, [d_b];\nadd.u64 %rd5, %rd4, %rd1;\nld.global.v4.f32 {%f4, %f5, %f6, %f7}, [%rd5];\nadd.f32 %f8, %f0, %f4;\nadd.f32 %f9, %f1, %f5;\nadd.f32 %f10, %f2, %f6;\nadd.f32 %f11, %f3, %f7;\nld.param.u64 %rd6, [d_c];\nadd.u64 %rd7, %rd6, %rd1;\nst.global.v4.f32 [%rd7], {%f8, %f9, %f10, %f11};\nret;\nTAIL_ADD:\nand.b32 %r7, %r4, 3;\nsetp.eq.u32 %p1, %r7, 0;\n@%p1 bra DONE_ADD;\nsetp.ne.u32 %p2, %r3, %r5;\n@%p2 bra DONE_ADD;\nshl.b32 %r6, %r5, 2;\nmul.wide.u32 %rd1, %r6, 4;\nld.param.u64 %rd2, [d_a];\nadd.u64 %rd3, %rd2, %rd1;\nld.param.u64 %rd4, [d_b];\nadd.u64 %rd5, %rd4, %rd1;\nld.param.u64 %rd6, [d_c];\nadd.u64 %rd7, %rd6, %rd1;\nADD_TL_LP:\nsetp.ge.u32 %p3, %r6, %r4;\n@%p3 bra DONE_ADD;\nld.global.f32 %f0, [%rd3];\nld.global.f32 %f4, [%rd5];\nadd.f32 %f8, %f0, %f4;\nst.global.f32 [%rd7], %f8;\nadd.u64 %rd3, %rd3, 4;\nadd.u64 %rd5, %rd5, 4;\nadd.u64 %rd7, %rd7, 4;\nadd.u32 %r6, %r6, 1;\nbra ADD_TL_LP;\nDONE_ADD:\nret;\n}\n"
.ascii ".visible .entry k_vec_sub(.param .u64 d_a, .param .u64 d_b, .param .u64 d_c, .param .u32 n) {\n.reg .pred %p<4>;\n.reg .b32 %r<8>;\n.reg .b64 %rd<8>;\n.reg .f32 %f<12>;\nmov.u32 %r0, %ctaid.x;\nmov.u32 %r1, %ntid.x;\nmov.u32 %r2, %tid.x;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nld.param.u32 %r4, [n];\nshr.u32 %r5, %r4, 2;\nsetp.ge.u32 %p0, %r3, %r5;\n@%p0 bra TAIL_SUB;\nshl.b32 %r6, %r3, 4;\nmul.wide.u32 %rd1, %r6, 1;\nld.param.u64 %rd2, [d_a];\nadd.u64 %rd3, %rd2, %rd1;\nld.global.v4.f32 {%f0, %f1, %f2, %f3}, [%rd3];\nld.param.u64 %rd4, [d_b];\nadd.u64 %rd5, %rd4, %rd1;\nld.global.v4.f32 {%f4, %f5, %f6, %f7}, [%rd5];\nsub.f32 %f8, %f0, %f4;\nsub.f32 %f9, %f1, %f5;\nsub.f32 %f10, %f2, %f6;\nsub.f32 %f11, %f3, %f7;\nld.param.u64 %rd6, [d_c];\nadd.u64 %rd7, %rd6, %rd1;\nst.global.v4.f32 [%rd7], {%f8, %f9, %f10, %f11};\nret;\nTAIL_SUB:\nand.b32 %r7, %r4, 3;\nsetp.eq.u32 %p1, %r7, 0;\n@%p1 bra DONE_SUB;\nsetp.ne.u32 %p2, %r3, %r5;\n@%p2 bra DONE_SUB;\nshl.b32 %r6, %r5, 2;\nmul.wide.u32 %rd1, %r6, 4;\nld.param.u64 %rd2, [d_a];\nadd.u64 %rd3, %rd2, %rd1;\nld.param.u64 %rd4, [d_b];\nadd.u64 %rd5, %rd4, %rd1;\nld.param.u64 %rd6, [d_c];\nadd.u64 %rd7, %rd6, %rd1;\nSUB_TL_LP:\nsetp.ge.u32 %p3, %r6, %r4;\n@%p3 bra DONE_SUB;\nld.global.f32 %f0, [%rd3];\nld.global.f32 %f4, [%rd5];\nsub.f32 %f8, %f0, %f4;\nst.global.f32 [%rd7], %f8;\nadd.u64 %rd3, %rd3, 4;\nadd.u64 %rd5, %rd5, 4;\nadd.u64 %rd7, %rd7, 4;\nadd.u32 %r6, %r6, 1;\nbra SUB_TL_LP;\nDONE_SUB:\nret;\n}\n"
.ascii ".visible .entry k_vec_mul(.param .u64 d_a, .param .u64 d_b, .param .u64 d_c, .param .u32 n) {\n.reg .pred %p<4>;\n.reg .b32 %r<8>;\n.reg .b64 %rd<8>;\n.reg .f32 %f<12>;\nmov.u32 %r0, %ctaid.x;\nmov.u32 %r1, %ntid.x;\nmov.u32 %r2, %tid.x;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nld.param.u32 %r4, [n];\nshr.u32 %r5, %r4, 2;\nsetp.ge.u32 %p0, %r3, %r5;\n@%p0 bra TAIL_MUL;\nshl.b32 %r6, %r3, 4;\nmul.wide.u32 %rd1, %r6, 1;\nld.param.u64 %rd2, [d_a];\nadd.u64 %rd3, %rd2, %rd1;\nld.global.v4.f32 {%f0, %f1, %f2, %f3}, [%rd3];\nld.param.u64 %rd4, [d_b];\nadd.u64 %rd5, %rd4, %rd1;\nld.global.v4.f32 {%f4, %f5, %f6, %f7}, [%rd5];\nmul.f32 %f8, %f0, %f4;\nmul.f32 %f9, %f1, %f5;\nmul.f32 %f10, %f2, %f6;\nmul.f32 %f11, %f3, %f7;\nld.param.u64 %rd6, [d_c];\nadd.u64 %rd7, %rd6, %rd1;\nst.global.v4.f32 [%rd7], {%f8, %f9, %f10, %f11};\nret;\nTAIL_MUL:\nand.b32 %r7, %r4, 3;\nsetp.eq.u32 %p1, %r7, 0;\n@%p1 bra DONE_MUL;\nsetp.ne.u32 %p2, %r3, %r5;\n@%p2 bra DONE_MUL;\nshl.b32 %r6, %r5, 2;\nmul.wide.u32 %rd1, %r6, 4;\nld.param.u64 %rd2, [d_a];\nadd.u64 %rd3, %rd2, %rd1;\nld.param.u64 %rd4, [d_b];\nadd.u64 %rd5, %rd4, %rd1;\nld.param.u64 %rd6, [d_c];\nadd.u64 %rd7, %rd6, %rd1;\nMUL_TL_LP:\nsetp.ge.u32 %p3, %r6, %r4;\n@%p3 bra DONE_MUL;\nld.global.f32 %f0, [%rd3];\nld.global.f32 %f4, [%rd5];\nmul.f32 %f8, %f0, %f4;\nst.global.f32 [%rd7], %f8;\nadd.u64 %rd3, %rd3, 4;\nadd.u64 %rd5, %rd5, 4;\nadd.u64 %rd7, %rd7, 4;\nadd.u32 %r6, %r6, 1;\nbra MUL_TL_LP;\nDONE_MUL:\nret;\n}\n"
.ascii ".visible .entry k_vec_div(.param .u64 d_a, .param .u64 d_b, .param .u64 d_c, .param .u32 n) {\n.reg .pred %p<4>;\n.reg .b32 %r<8>;\n.reg .b64 %rd<8>;\n.reg .f32 %f<12>;\nmov.u32 %r0, %ctaid.x;\nmov.u32 %r1, %ntid.x;\nmov.u32 %r2, %tid.x;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nld.param.u32 %r4, [n];\nshr.u32 %r5, %r4, 2;\nsetp.ge.u32 %p0, %r3, %r5;\n@%p0 bra TAIL_DIV;\nshl.b32 %r6, %r3, 4;\nmul.wide.u32 %rd1, %r6, 1;\nld.param.u64 %rd2, [d_a];\nadd.u64 %rd3, %rd2, %rd1;\nld.global.v4.f32 {%f0, %f1, %f2, %f3}, [%rd3];\nld.param.u64 %rd4, [d_b];\nadd.u64 %rd5, %rd4, %rd1;\nld.global.v4.f32 {%f4, %f5, %f6, %f7}, [%rd5];\ndiv.approx.f32 %f8, %f0, %f4;\ndiv.approx.f32 %f9, %f1, %f5;\ndiv.approx.f32 %f10, %f2, %f6;\ndiv.approx.f32 %f11, %f3, %f7;\nld.param.u64 %rd6, [d_c];\nadd.u64 %rd7, %rd6, %rd1;\nst.global.v4.f32 [%rd7], {%f8, %f9, %f10, %f11};\nret;\nTAIL_DIV:\nand.b32 %r7, %r4, 3;\nsetp.eq.u32 %p1, %r7, 0;\n@%p1 bra DONE_DIV;\nsetp.ne.u32 %p2, %r3, %r5;\n@%p2 bra DONE_DIV;\nshl.b32 %r6, %r5, 2;\nmul.wide.u32 %rd1, %r6, 4;\nld.param.u64 %rd2, [d_a];\nadd.u64 %rd3, %rd2, %rd1;\nld.param.u64 %rd4, [d_b];\nadd.u64 %rd5, %rd4, %rd1;\nld.param.u64 %rd6, [d_c];\nadd.u64 %rd7, %rd6, %rd1;\nDIV_TL_LP:\nsetp.ge.u32 %p3, %r6, %r4;\n@%p3 bra DONE_DIV;\nld.global.f32 %f0, [%rd3];\nld.global.f32 %f4, [%rd5];\ndiv.approx.f32 %f8, %f0, %f4;\nst.global.f32 [%rd7], %f8;\nadd.u64 %rd3, %rd3, 4;\nadd.u64 %rd5, %rd5, 4;\nadd.u64 %rd7, %rd7, 4;\nadd.u32 %r6, %r6, 1;\nbra DIV_TL_LP;\nDONE_DIV:\nret;\n}\n"
.ascii ".visible .entry k_vec_scale(.param .u64 d_a, .param .f32 s, .param .u64 d_c, .param .u32 n) {\n.reg .pred %p<4>;\n.reg .b32 %r<8>;\n.reg .b64 %rd<8>;\n.reg .f32 %f<9>;\nmov.u32 %r0, %ctaid.x;\nmov.u32 %r1, %ntid.x;\nmov.u32 %r2, %tid.x;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nld.param.u32 %r4, [n];\nld.param.f32 %f4, [s];\nshr.u32 %r5, %r4, 2;\nsetp.ge.u32 %p0, %r3, %r5;\n@%p0 bra TAIL_SCALE;\nshl.b32 %r6, %r3, 4;\nmul.wide.u32 %rd1, %r6, 1;\nld.param.u64 %rd2, [d_a];\nadd.u64 %rd3, %rd2, %rd1;\nld.global.v4.f32 {%f0, %f1, %f2, %f3}, [%rd3];\nmul.f32 %f5, %f0, %f4;\nmul.f32 %f6, %f1, %f4;\nmul.f32 %f7, %f2, %f4;\nmul.f32 %f8, %f3, %f4;\nld.param.u64 %rd6, [d_c];\nadd.u64 %rd7, %rd6, %rd1;\nst.global.v4.f32 [%rd7], {%f5, %f6, %f7, %f8};\nret;\nTAIL_SCALE:\nand.b32 %r7, %r4, 3;\nsetp.eq.u32 %p1, %r7, 0;\n@%p1 bra DONE_SCALE;\nsetp.ne.u32 %p2, %r3, %r5;\n@%p2 bra DONE_SCALE;\nshl.b32 %r6, %r5, 2;\nmul.wide.u32 %rd1, %r6, 4;\nld.param.u64 %rd2, [d_a];\nadd.u64 %rd3, %rd2, %rd1;\nld.param.u64 %rd6, [d_c];\nadd.u64 %rd7, %rd6, %rd1;\nSCALE_TL_LP:\nsetp.ge.u32 %p3, %r6, %r4;\n@%p3 bra DONE_SCALE;\nld.global.f32 %f0, [%rd3];\nmul.f32 %f5, %f0, %f4;\nst.global.f32 [%rd7], %f5;\nadd.u64 %rd3, %rd3, 4;\nadd.u64 %rd7, %rd7, 4;\nadd.u32 %r6, %r6, 1;\nbra SCALE_TL_LP;\nDONE_SCALE:\nret;\n}\n"
.ascii ".visible .entry k_relu(.param .u64 d_a, .param .u64 d_c, .param .u32 n) {\n.reg .pred %p<4>;\n.reg .b32 %r<8>;\n.reg .b64 %rd<8>;\n.reg .f32 %f<9>;\nmov.u32 %r0, %ctaid.x;\nmov.u32 %r1, %ntid.x;\nmov.u32 %r2, %tid.x;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nld.param.u32 %r4, [n];\nshr.u32 %r5, %r4, 2;\nsetp.ge.u32 %p0, %r3, %r5;\n@%p0 bra TAIL_RELU;\nshl.b32 %r6, %r3, 4;\nmul.wide.u32 %rd1, %r6, 1;\nld.param.u64 %rd2, [d_a];\nadd.u64 %rd3, %rd2, %rd1;\nld.global.v4.f32 {%f0, %f1, %f2, %f3}, [%rd3];\nmax.f32 %f5, %f0, 0f00000000;\nmax.f32 %f6, %f1, 0f00000000;\nmax.f32 %f7, %f2, 0f00000000;\nmax.f32 %f8, %f3, 0f00000000;\nld.param.u64 %rd6, [d_c];\nadd.u64 %rd7, %rd6, %rd1;\nst.global.v4.f32 [%rd7], {%f5, %f6, %f7, %f8};\nret;\nTAIL_RELU:\nand.b32 %r7, %r4, 3;\nsetp.eq.u32 %p1, %r7, 0;\n@%p1 bra DONE_RELU;\nsetp.ne.u32 %p2, %r3, %r5;\n@%p2 bra DONE_RELU;\nshl.b32 %r6, %r5, 2;\nmul.wide.u32 %rd1, %r6, 4;\nld.param.u64 %rd2, [d_a];\nadd.u64 %rd3, %rd2, %rd1;\nld.param.u64 %rd6, [d_c];\nadd.u64 %rd7, %rd6, %rd1;\nRELU_TL_LP:\nsetp.ge.u32 %p3, %r6, %r4;\n@%p3 bra DONE_RELU;\nld.global.f32 %f0, [%rd3];\nmax.f32 %f5, %f0, 0f00000000;\nst.global.f32 [%rd7], %f5;\nadd.u64 %rd3, %rd3, 4;\nadd.u64 %rd7, %rd7, 4;\nadd.u32 %r6, %r6, 1;\nbra RELU_TL_LP;\nDONE_RELU:\nret;\n}\n"
.ascii ".visible .entry k_sigmoid(.param .u64 d_a, .param .u64 d_c, .param .u32 n) {\n.reg .pred %p;\n.reg .b32 %r<5>;\n.reg .b64 %rd<6>;\n.reg .f32 %f<5>;\nmov.u32 %r0, %ctaid.x;\nmov.u32 %r1, %ntid.x;\nmov.u32 %r2, %tid.x;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nld.param.u32 %r4, [n];\nsetp.ge.u32 %p, %r3, %r4;\n@%p bra DONE_SIG;\nmul.wide.u32 %rd1, %r3, 4;\nld.param.u64 %rd2, [d_a];\nadd.u64 %rd3, %rd2, %rd1;\nld.global.f32 %f1, [%rd3];\nneg.f32 %f2, %f1;\nmul.f32 %f2, %f2, 0f3FB8AA3B;\nex2.approx.f32 %f3, %f2;\nadd.f32 %f3, %f3, 0f3F800000;\nrcp.approx.f32 %f4, %f3;\nld.param.u64 %rd4, [d_c];\nadd.u64 %rd5, %rd4, %rd1;\nst.global.f32 [%rd5], %f4;\nDONE_SIG:\nret;\n}\n"
.ascii ".visible .entry k_fill(.param .u64 d_c, .param .f32 val, .param .u32 n) {\n.reg .pred %p<4>;\n.reg .b32 %r<8>;\n.reg .b64 %rd<8>;\n.reg .f32 %f1;\nmov.u32 %r0, %ctaid.x;\nmov.u32 %r1, %ntid.x;\nmov.u32 %r2, %tid.x;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nld.param.u32 %r4, [n];\nld.param.f32 %f1, [val];\nshr.u32 %r5, %r4, 2;\nsetp.ge.u32 %p0, %r3, %r5;\n@%p0 bra TAIL_FILL;\nshl.b32 %r6, %r3, 4;\nmul.wide.u32 %rd1, %r6, 1;\nld.param.u64 %rd2, [d_c];\nadd.u64 %rd3, %rd2, %rd1;\nst.global.v4.f32 [%rd3], {%f1, %f1, %f1, %f1};\nret;\nTAIL_FILL:\nand.b32 %r7, %r4, 3;\nsetp.eq.u32 %p1, %r7, 0;\n@%p1 bra DONE_FILL;\nsetp.ne.u32 %p2, %r3, %r5;\n@%p2 bra DONE_FILL;\nshl.b32 %r6, %r5, 2;\nmul.wide.u32 %rd1, %r6, 4;\nld.param.u64 %rd2, [d_c];\nadd.u64 %rd3, %rd2, %rd1;\nFILL_TL_LP:\nsetp.ge.u32 %p3, %r6, %r4;\n@%p3 bra DONE_FILL;\nst.global.f32 [%rd3], %f1;\nadd.u64 %rd3, %rd3, 4;\nadd.u32 %r6, %r6, 1;\nbra FILL_TL_LP;\nDONE_FILL:\nret;\n}\n"
.ascii ".visible .entry k_tiled_gemm(.param .u64 d_a, .param .u64 d_b, .param .u64 d_c, .param .u32 M, .param .u32 N, .param .u32 K) {\n.reg .pred %p<6>;\n.reg .b32 %r<16>;\n.reg .b64 %rd<16>;\n.reg .f32 %f<16>;\nmov.u32 %r0, %ctaid.y;\nmov.u32 %r1, %ntid.y;\nmov.u32 %r2, %tid.y;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nmov.u32 %r4, %ctaid.x;\nmov.u32 %r5, %ntid.x;\nmov.u32 %r6, %tid.x;\nmad.lo.u32 %r7, %r4, %r5, %r6;\nld.param.u32 %r8, [M];\nld.param.u32 %r9, [N];\nsetp.ge.u32 %p0, %r3, %r8;\nsetp.ge.u32 %p1, %r7, %r9;\nor.pred %p2, %p0, %p1;\n@%p2 bra DONE_GEMM;\nld.param.u32 %r10, [K];\nmov.f32 %f0, 0f00000000;\nmad.lo.u32 %r11, %r3, %r10, 0;\nmul.wide.u32 %rd1, %r11, 4;\nld.param.u64 %rd2, [d_a];\nadd.u64 %rd3, %rd2, %rd1;\nmul.wide.u32 %rd4, %r7, 4;\nld.param.u64 %rd5, [d_b];\nadd.u64 %rd6, %rd5, %rd4;\nmul.wide.u32 %rd7, %r9, 4;\nshr.u32 %r12, %r10, 2;\nmov.u32 %r13, 0;\nGEMM_UNROLL_LP:\nsetp.ge.u32 %p3, %r13, %r12;\n@%p3 bra GEMM_TAIL;\nld.global.f32 %f1, [%rd3];\nld.global.f32 %f2, [%rd3+4];\nld.global.f32 %f3, [%rd3+8];\nld.global.f32 %f4, [%rd3+12];\nld.global.f32 %f5, [%rd6];\nadd.u64 %rd8, %rd6, %rd7;\nld.global.f32 %f6, [%rd8];\nadd.u64 %rd9, %rd8, %rd7;\nld.global.f32 %f7, [%rd9];\nadd.u64 %rd10, %rd9, %rd7;\nld.global.f32 %f8, [%rd10];\nfma.rn.f32 %f0, %f1, %f5, %f0;\nfma.rn.f32 %f0, %f2, %f6, %f0;\nfma.rn.f32 %f0, %f3, %f7, %f0;\nfma.rn.f32 %f0, %f4, %f8, %f0;\nadd.u64 %rd3, %rd3, 16;\nadd.u64 %rd6, %rd10, %rd7;\nadd.u32 %r13, %r13, 1;\nbra GEMM_UNROLL_LP;\nGEMM_TAIL:\nshl.b32 %r14, %r12, 2;\nGEMM_TAIL_LP:\nsetp.ge.u32 %p4, %r14, %r10;\n@%p4 bra WRITE_GEMM;\nld.global.f32 %f1, [%rd3];\nld.global.f32 %f5, [%rd6];\nfma.rn.f32 %f0, %f1, %f5, %f0;\nadd.u64 %rd3, %rd3, 4;\nadd.u64 %rd6, %rd6, %rd7;\nadd.u32 %r14, %r14, 1;\nbra GEMM_TAIL_LP;\nWRITE_GEMM:\nmad.lo.u32 %r15, %r3, %r9, %r7;\nmul.wide.u32 %rd11, %r15, 4;\nld.param.u64 %rd12, [d_c];\nadd.u64 %rd13, %rd12, %rd11;\nst.global.f32 [%rd13], %f0;\nDONE_GEMM:\nret;\n}\n"
.ascii ".visible .entry k_rgb_to_gray(.param .u64 d_rgb, .param .u64 d_gray, .param .u32 n_pixels) {\n.reg .pred %p;\n.reg .b32 %r<5>;\n.reg .b64 %rd<8>;\n.reg .f32 %f<6>;\nmov.u32 %r0, %ctaid.x;\nmov.u32 %r1, %ntid.x;\nmov.u32 %r2, %tid.x;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nld.param.u32 %r4, [n_pixels];\nsetp.ge.u32 %p, %r3, %r4;\n@%p bra DONE_GRAY;\nmul.wide.u32 %rd1, %r3, 12;\nld.param.u64 %rd2, [d_rgb];\nadd.u64 %rd3, %rd2, %rd1;\nld.global.f32 %f1, [%rd3];\nld.global.f32 %f2, [%rd3+4];\nld.global.f32 %f3, [%rd3+8];\nmul.f32 %f4, %f1, 0f3E991687;\nfma.rn.f32 %f4, %f2, 0f3F1645A2, %f4;\nfma.rn.f32 %f4, %f3, 0f3DE978D5, %f4;\nmul.wide.u32 %rd4, %r3, 4;\nld.param.u64 %rd5, [d_gray];\nadd.u64 %rd6, %rd5, %rd4;\nst.global.f32 [%rd6], %f4;\nDONE_GRAY:\nret;\n}\n"
.ascii ".visible .entry k_transpose(.param .u64 d_in, .param .u64 d_out, .param .u32 rows, .param .u32 cols) {\n.reg .pred %p<3>;\n.reg .b32 %r<10>;\n.reg .b64 %rd<8>;\n.reg .f32 %f1;\nmov.u32 %r0, %ctaid.y;\nmov.u32 %r1, %ntid.y;\nmov.u32 %r2, %tid.y;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nmov.u32 %r4, %ctaid.x;\nmov.u32 %r5, %ntid.x;\nmov.u32 %r6, %tid.x;\nmad.lo.u32 %r7, %r4, %r5, %r6;\nld.param.u32 %r8, [rows];\nld.param.u32 %r9, [cols];\nsetp.ge.u32 %p0, %r3, %r8;\nsetp.ge.u32 %p1, %r7, %r9;\nor.pred %p2, %p0, %p1;\n@%p2 bra DONE_TR;\nmad.lo.u32 %r1, %r3, %r9, %r7;\nmul.wide.u32 %rd1, %r1, 4;\nld.param.u64 %rd2, [d_in];\nadd.u64 %rd3, %rd2, %rd1;\nld.global.f32 %f1, [%rd3];\nmad.lo.u32 %r2, %r7, %r8, %r3;\nmul.wide.u32 %rd4, %r2, 4;\nld.param.u64 %rd5, [d_out];\nadd.u64 %rd6, %rd5, %rd4;\nst.global.f32 [%rd6], %f1;\nDONE_TR:\nret;\n}\n"
.ascii ".visible .entry k_gelu(.param .u64 d_in, .param .u64 d_out, .param .u32 n) {\n.reg .pred %p;\n.reg .b32 %r<5>;\n.reg .b64 %rd<6>;\n.reg .f32 %f<8>;\nmov.u32 %r0, %ctaid.x;\nmov.u32 %r1, %ntid.x;\nmov.u32 %r2, %tid.x;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nld.param.u32 %r4, [n];\nsetp.ge.u32 %p, %r3, %r4;\n@%p bra DONE_GELU;\nmul.wide.u32 %rd1, %r3, 4;\nld.param.u64 %rd2, [d_in];\nadd.u64 %rd3, %rd2, %rd1;\nld.global.f32 %f1, [%rd3];\nmul.f32 %f2, %f1, %f1;\nmul.f32 %f3, %f2, %f1;\nmul.f32 %f4, %f1, 0f3FCC3160;\nfma.rn.f32 %f4, %f3, 0f3D9222BF, %f4;\nmul.f32 %f5, %f4, 0fBFB8AA3B;\nex2.approx.f32 %f6, %f5;\nadd.f32 %f6, %f6, 0f3F800000;\nrcp.approx.f32 %f7, %f6;\nmul.f32 %f1, %f1, %f7;\nld.param.u64 %rd4, [d_out];\nadd.u64 %rd5, %rd4, %rd1;\nst.global.f32 [%rd5], %f1;\nDONE_GELU:\nret;\n}\n"
.ascii ".visible .entry k_silu(.param .u64 d_in, .param .u64 d_out, .param .u32 n) {\n.reg .pred %p;\n.reg .b32 %r<5>;\n.reg .b64 %rd<6>;\n.reg .f32 %f<6>;\nmov.u32 %r0, %ctaid.x;\nmov.u32 %r1, %ntid.x;\nmov.u32 %r2, %tid.x;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nld.param.u32 %r4, [n];\nsetp.ge.u32 %p, %r3, %r4;\n@%p bra DONE_SILU;\nmul.wide.u32 %rd1, %r3, 4;\nld.param.u64 %rd2, [d_in];\nadd.u64 %rd3, %rd2, %rd1;\nld.global.f32 %f1, [%rd3];\nmul.f32 %f2, %f1, 0fBFB8AA3B;\nex2.approx.f32 %f3, %f2;\nadd.f32 %f3, %f3, 0f3F800000;\nrcp.approx.f32 %f4, %f3;\nmul.f32 %f5, %f1, %f4;\nld.param.u64 %rd4, [d_out];\nadd.u64 %rd5, %rd4, %rd1;\nst.global.f32 [%rd5], %f5;\nDONE_SILU:\nret;\n}\n"
.ascii ".visible .entry k_softmax(.param .u64 d_in, .param .u64 d_out, .param .u32 rows, .param .u32 cols) {\n.reg .pred %p<3>;\n.reg .b32 %r<10>;\n.reg .b64 %rd<8>;\n.reg .f32 %f<8>;\nmov.u32 %r0, %ctaid.x;\nmov.u32 %r1, %ntid.x;\nmov.u32 %r2, %tid.x;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nld.param.u32 %r4, [rows];\nsetp.ge.u32 %p0, %r3, %r4;\n@%p0 bra DONE_SM;\nld.param.u32 %r5, [cols];\nsetp.eq.u32 %p0, %r5, 0;\n@%p0 bra DONE_SM;\nmad.lo.u32 %r6, %r3, %r5, 0;\nmul.wide.u32 %rd1, %r6, 4;\nld.param.u64 %rd2, [d_in];\nadd.u64 %rd3, %rd2, %rd1;\nld.param.u64 %rd4, [d_out];\nadd.u64 %rd5, %rd4, %rd1;\nld.global.f32 %f0, [%rd3];\nmov.u32 %r7, 1;\nSM_MAX_LP:\nsetp.ge.u32 %p1, %r7, %r5;\n@%p1 bra SM_SUM_INIT;\nmul.wide.u32 %rd6, %r7, 4;\nadd.u64 %rd7, %rd3, %rd6;\nld.global.f32 %f1, [%rd7];\nmax.f32 %f0, %f0, %f1;\nadd.u32 %r7, %r7, 1;\nbra SM_MAX_LP;\nSM_SUM_INIT:\nmov.f32 %f2, 0f00000000;\nmov.u32 %r7, 0;\nSM_SUM_LP:\nsetp.ge.u32 %p1, %r7, %r5;\n@%p1 bra SM_NORM_INIT;\nmul.wide.u32 %rd6, %r7, 4;\nadd.u64 %rd7, %rd3, %rd6;\nld.global.f32 %f1, [%rd7];\nsub.f32 %f3, %f1, %f0;\nmul.f32 %f3, %f3, 0f3FB8AA3B;\nex2.approx.f32 %f4, %f3;\nadd.f32 %f2, %f2, %f4;\nadd.u32 %r7, %r7, 1;\nbra SM_SUM_LP;\nSM_NORM_INIT:\nrcp.approx.f32 %f5, %f2;\nmov.u32 %r7, 0;\nSM_NORM_LP:\nsetp.ge.u32 %p1, %r7, %r5;\n@%p1 bra DONE_SM;\nmul.wide.u32 %rd6, %r7, 4;\nadd.u64 %rd7, %rd3, %rd6;\nld.global.f32 %f1, [%rd7];\nsub.f32 %f3, %f1, %f0;\nmul.f32 %f3, %f3, 0f3FB8AA3B;\nex2.approx.f32 %f4, %f3;\nmul.f32 %f6, %f4, %f5;\nadd.u64 %rd7, %rd5, %rd6;\nst.global.f32 [%rd7], %f6;\nadd.u32 %r7, %r7, 1;\nbra SM_NORM_LP;\nDONE_SM:\nret;\n}\n"
.ascii ".visible .entry k_layernorm(.param .u64 d_in, .param .u64 d_out, .param .u64 d_gamma, .param .u64 d_beta, .param .f32 eps, .param .u32 rows, .param .u32 cols) {\n.reg .pred %p<4>;\n.reg .b32 %r<10>;\n.reg .b64 %rd<14>;\n.reg .f32 %f<10>;\nmov.u32 %r0, %ctaid.x;\nmov.u32 %r1, %ntid.x;\nmov.u32 %r2, %tid.x;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nld.param.u32 %r4, [rows];\nsetp.ge.u32 %p0, %r3, %r4;\n@%p0 bra DONE_LN;\nld.param.u32 %r5, [cols];\nsetp.eq.u32 %p0, %r5, 0;\n@%p0 bra DONE_LN;\nmad.lo.u32 %r6, %r3, %r5, 0;\nmul.wide.u32 %rd1, %r6, 4;\nld.param.u64 %rd2, [d_in];\nadd.u64 %rd3, %rd2, %rd1;\nld.param.u64 %rd4, [d_out];\nadd.u64 %rd5, %rd4, %rd1;\nmov.f32 %f0, 0f00000000;\nmov.u32 %r7, 0;\nLN_MEAN_LP:\nsetp.ge.u32 %p1, %r7, %r5;\n@%p1 bra LN_VAR_INIT;\nmul.wide.u32 %rd6, %r7, 4;\nadd.u64 %rd7, %rd3, %rd6;\nld.global.f32 %f1, [%rd7];\nadd.f32 %f0, %f0, %f1;\nadd.u32 %r7, %r7, 1;\nbra LN_MEAN_LP;\nLN_VAR_INIT:\ncvt.rn.f32.u32 %f2, %r5;\ndiv.approx.f32 %f3, %f0, %f2;\nmov.f32 %f4, 0f00000000;\nmov.u32 %r7, 0;\nLN_VAR_LP:\nsetp.ge.u32 %p1, %r7, %r5;\n@%p1 bra LN_NORM_INIT;\nmul.wide.u32 %rd6, %r7, 4;\nadd.u64 %rd7, %rd3, %rd6;\nld.global.f32 %f1, [%rd7];\nsub.f32 %f5, %f1, %f3;\nfma.rn.f32 %f4, %f5, %f5, %f4;\nadd.u32 %r7, %r7, 1;\nbra LN_VAR_LP;\nLN_NORM_INIT:\ndiv.approx.f32 %f6, %f4, %f2;\nld.param.f32 %f7, [eps];\nadd.f32 %f6, %f6, %f7;\nrsqrt.approx.f32 %f8, %f6;\nld.param.u64 %rd8, [d_gamma];\nld.param.u64 %rd9, [d_beta];\nsetp.ne.u64 %p2, %rd8, 0;\nsetp.ne.u64 %p3, %rd9, 0;\nmov.u32 %r7, 0;\nLN_NORM_LP:\nsetp.ge.u32 %p1, %r7, %r5;\n@%p1 bra DONE_LN;\nmul.wide.u32 %rd6, %r7, 4;\nadd.u64 %rd7, %rd3, %rd6;\nld.global.f32 %f1, [%rd7];\nsub.f32 %f5, %f1, %f3;\nmul.f32 %f9, %f5, %f8;\n@%p2 add.u64 %rd10, %rd8, %rd6;\n@%p2 ld.global.f32 %f5, [%rd10];\n@%p2 mul.f32 %f9, %f9, %f5;\n@%p3 add.u64 %rd11, %rd9, %rd6;\n@%p3 ld.global.f32 %f5, [%rd11];\n@%p3 add.f32 %f9, %f9, %f5;\nadd.u64 %rd12, %rd5, %rd6;\nst.global.f32 [%rd12], %f9;\nadd.u32 %r7, %r7, 1;\nbra LN_NORM_LP;\nDONE_LN:\nret;\n}\n"
.ascii ".visible .entry k_rmsnorm(.param .u64 d_in, .param .u64 d_out, .param .u64 d_gamma, .param .f32 eps, .param .u32 rows, .param .u32 cols) {\n.reg .pred %p<3>;\n.reg .b32 %r<10>;\n.reg .b64 %rd<12>;\n.reg .f32 %f<8>;\nmov.u32 %r0, %ctaid.x;\nmov.u32 %r1, %ntid.x;\nmov.u32 %r2, %tid.x;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nld.param.u32 %r4, [rows];\nsetp.ge.u32 %p0, %r3, %r4;\n@%p0 bra DONE_RMS;\nld.param.u32 %r5, [cols];\nsetp.eq.u32 %p0, %r5, 0;\n@%p0 bra DONE_RMS;\nmad.lo.u32 %r6, %r3, %r5, 0;\nmul.wide.u32 %rd1, %r6, 4;\nld.param.u64 %rd2, [d_in];\nadd.u64 %rd3, %rd2, %rd1;\nld.param.u64 %rd4, [d_out];\nadd.u64 %rd5, %rd4, %rd1;\nmov.f32 %f0, 0f00000000;\nmov.u32 %r7, 0;\nRMS_LP1:\nsetp.ge.u32 %p1, %r7, %r5;\n@%p1 bra RMS_NORM_INIT;\nmul.wide.u32 %rd6, %r7, 4;\nadd.u64 %rd7, %rd3, %rd6;\nld.global.f32 %f1, [%rd7];\nfma.rn.f32 %f0, %f1, %f1, %f0;\nadd.u32 %r7, %r7, 1;\nbra RMS_LP1;\nRMS_NORM_INIT:\ncvt.rn.f32.u32 %f2, %r5;\ndiv.approx.f32 %f3, %f0, %f2;\nld.param.f32 %f4, [eps];\nadd.f32 %f3, %f3, %f4;\nrsqrt.approx.f32 %f5, %f3;\nld.param.u64 %rd8, [d_gamma];\nsetp.ne.u64 %p2, %rd8, 0;\nmov.u32 %r7, 0;\nRMS_LP2:\nsetp.ge.u32 %p1, %r7, %r5;\n@%p1 bra DONE_RMS;\nmul.wide.u32 %rd6, %r7, 4;\nadd.u64 %rd7, %rd3, %rd6;\nld.global.f32 %f1, [%rd7];\nmul.f32 %f6, %f1, %f5;\n@%p2 add.u64 %rd9, %rd8, %rd6;\n@%p2 ld.global.f32 %f7, [%rd9];\n@%p2 mul.f32 %f6, %f6, %f7;\nadd.u64 %rd10, %rd5, %rd6;\nst.global.f32 [%rd10], %f6;\nadd.u32 %r7, %r7, 1;\nbra RMS_LP2;\nDONE_RMS:\nret;\n}\n"
.ascii ".visible .entry k_conv2d(.param .u64 d_in, .param .u64 d_kernel, .param .u64 d_out, .param .u32 H, .param .u32 W, .param .u32 kH, .param .u32 kW, .param .u32 outH, .param .u32 outW, .param .u32 stride, .param .u32 pad) {\n.reg .pred %p<6>;\n.reg .b32 %r<24>;\n.reg .b64 %rd<14>;\n.reg .f32 %f<5>;\nmov.u32 %r0, %ctaid.y;\nmov.u32 %r1, %ntid.y;\nmov.u32 %r2, %tid.y;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nmov.u32 %r4, %ctaid.x;\nmov.u32 %r5, %ntid.x;\nmov.u32 %r6, %tid.x;\nmad.lo.u32 %r7, %r4, %r5, %r6;\nld.param.u32 %r8, [outH];\nld.param.u32 %r9, [outW];\nsetp.ge.u32 %p0, %r3, %r8;\nsetp.ge.u32 %p1, %r7, %r9;\nor.pred %p2, %p0, %p1;\n@%p2 bra DONE_CONV;\nmov.f32 %f0, 0f00000000;\nld.param.u32 %r10, [H];\nld.param.u32 %r11, [W];\nld.param.u32 %r12, [kH];\nld.param.u32 %r13, [kW];\nld.param.u32 %r14, [stride];\nld.param.u32 %r15, [pad];\nld.param.u64 %rd2, [d_in];\nld.param.u64 %rd5, [d_kernel];\nmov.u32 %r16, 0;\nCONV_KH_LP:\nsetp.ge.u32 %p0, %r16, %r12;\n@%p0 bra CONV_STORE;\nmad.lo.u32 %r17, %r3, %r14, %r16;\nsub.s32 %r17, %r17, %r15;\nsetp.lt.s32 %p0, %r17, 0;\nsetp.ge.s32 %p1, %r17, %r10;\nor.pred %p3, %p0, %p1;\nmov.u32 %r18, 0;\nCONV_KW_LP:\nsetp.ge.u32 %p0, %r18, %r13;\n@%p0 bra CONV_KH_NXT;\n@%p3 bra CONV_KW_NXT;\nmad.lo.u32 %r19, %r7, %r14, %r18;\nsub.s32 %r19, %r19, %r15;\nsetp.lt.s32 %p0, %r19, 0;\nsetp.ge.s32 %p1, %r19, %r11;\nor.pred %p4, %p0, %p1;\n@%p4 bra CONV_KW_NXT;\nmad.lo.u32 %r20, %r17, %r11, %r19;\nmul.wide.u32 %rd1, %r20, 4;\nadd.u64 %rd3, %rd2, %rd1;\nld.global.f32 %f1, [%rd3];\nmad.lo.u32 %r21, %r16, %r13, %r18;\nmul.wide.u32 %rd4, %r21, 4;\nadd.u64 %rd6, %rd5, %rd4;\nld.global.f32 %f2, [%rd6];\nfma.rn.f32 %f0, %f1, %f2, %f0;\nCONV_KW_NXT:\nadd.u32 %r18, %r18, 1;\nbra CONV_KW_LP;\nCONV_KH_NXT:\nadd.u32 %r16, %r16, 1;\nbra CONV_KH_LP;\nCONV_STORE:\nmad.lo.u32 %r22, %r3, %r9, %r7;\nmul.wide.u32 %rd7, %r22, 4;\nld.param.u64 %rd8, [d_out];\nadd.u64 %rd9, %rd8, %rd7;\nst.global.f32 [%rd9], %f0;\nDONE_CONV:\nret;\n}\n"
.ascii ".visible .entry k_maxpool2d(.param .u64 d_in, .param .u64 d_out, .param .u32 H, .param .u32 W, .param .u32 pool_size, .param .u32 stride, .param .u32 outH, .param .u32 outW) {\n.reg .pred %p<6>;\n.reg .b32 %r<20>;\n.reg .b64 %rd<8>;\n.reg .f32 %f<3>;\nmov.u32 %r0, %ctaid.y;\nmov.u32 %r1, %ntid.y;\nmov.u32 %r2, %tid.y;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nmov.u32 %r4, %ctaid.x;\nmov.u32 %r5, %ntid.x;\nmov.u32 %r6, %tid.x;\nmad.lo.u32 %r7, %r4, %r5, %r6;\nld.param.u32 %r8, [outH];\nld.param.u32 %r9, [outW];\nsetp.ge.u32 %p0, %r3, %r8;\nsetp.ge.u32 %p1, %r7, %r9;\nor.pred %p2, %p0, %p1;\n@%p2 bra DONE_POOL;\nmov.f32 %f0, 0fFF7FFFFF;\nld.param.u32 %r10, [H];\nld.param.u32 %r11, [W];\nld.param.u32 %r12, [pool_size];\nld.param.u32 %r13, [stride];\nld.param.u64 %rd2, [d_in];\nmov.u32 %r14, 0;\nPOOL_PH_LP:\nsetp.ge.u32 %p0, %r14, %r12;\n@%p0 bra POOL_STORE;\nmad.lo.u32 %r15, %r3, %r13, %r14;\nsetp.ge.u32 %p3, %r15, %r10;\nmov.u32 %r16, 0;\nPOOL_PW_LP:\nsetp.ge.u32 %p0, %r16, %r12;\n@%p0 bra POOL_PH_NXT;\n@%p3 bra POOL_PW_NXT;\nmad.lo.u32 %r17, %r7, %r13, %r16;\nsetp.ge.u32 %p4, %r17, %r11;\n@%p4 bra POOL_PW_NXT;\nmad.lo.u32 %r18, %r15, %r11, %r17;\nmul.wide.u32 %rd1, %r18, 4;\nadd.u64 %rd3, %rd2, %rd1;\nld.global.f32 %f1, [%rd3];\nmax.f32 %f0, %f0, %f1;\nPOOL_PW_NXT:\nadd.u32 %r16, %r16, 1;\nbra POOL_PW_LP;\nPOOL_PH_NXT:\nadd.u32 %r14, %r14, 1;\nbra POOL_PH_LP;\nPOOL_STORE:\nmad.lo.u32 %r19, %r3, %r9, %r7;\nmul.wide.u32 %rd4, %r19, 4;\nld.param.u64 %rd5, [d_out];\nadd.u64 %rd6, %rd5, %rd4;\nst.global.f32 [%rd6], %f0;\nDONE_POOL:\nret;\n}\n"
.ascii ".visible .entry k_gaussian_blur(.param .u64 d_in, .param .u64 d_out, .param .u32 H, .param .u32 W) {\n.reg .pred %p<3>;\n.reg .b32 %r<16>;\n.reg .b64 %rd<8>;\n.reg .f32 %f<12>;\nmov.u32 %r0, %ctaid.y;\nmov.u32 %r1, %ntid.y;\nmov.u32 %r2, %tid.y;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nmov.u32 %r4, %ctaid.x;\nmov.u32 %r5, %ntid.x;\nmov.u32 %r6, %tid.x;\nmad.lo.u32 %r7, %r4, %r5, %r6;\nld.param.u32 %r8, [H];\nld.param.u32 %r9, [W];\nsetp.ge.u32 %p0, %r3, %r8;\nsetp.ge.u32 %p1, %r7, %r9;\nor.pred %p2, %p0, %p1;\n@%p2 bra DONE_BLUR;\nsub.s32 %r10, %r3, 1;\nmax.s32 %r10, %r10, 0;\nadd.u32 %r11, %r3, 1;\nsub.u32 %r12, %r8, 1;\nmin.u32 %r11, %r11, %r12;\nsub.s32 %r13, %r7, 1;\nmax.s32 %r13, %r13, 0;\nadd.u32 %r14, %r7, 1;\nsub.u32 %r15, %r9, 1;\nmin.u32 %r14, %r14, %r15;\nld.param.u64 %rd1, [d_in];\nmad.lo.u32 %r0, %r10, %r9, %r13;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f1, [%rd3];\nmad.lo.u32 %r0, %r10, %r9, %r7;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f2, [%rd3];\nmad.lo.u32 %r0, %r10, %r9, %r14;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f3, [%rd3];\nmad.lo.u32 %r0, %r3, %r9, %r13;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f4, [%rd3];\nmad.lo.u32 %r0, %r3, %r9, %r7;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f5, [%rd3];\nmad.lo.u32 %r0, %r3, %r9, %r14;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f6, [%rd3];\nmad.lo.u32 %r0, %r11, %r9, %r13;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f7, [%rd3];\nmad.lo.u32 %r0, %r11, %r9, %r7;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f8, [%rd3];\nmad.lo.u32 %r0, %r11, %r9, %r14;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f9, [%rd3];\nadd.f32 %f0, %f1, %f3;\nadd.f32 %f0, %f0, %f7;\nadd.f32 %f0, %f0, %f9;\nadd.f32 %f10, %f2, %f4;\nadd.f32 %f10, %f10, %f6;\nadd.f32 %f10, %f10, %f8;\nfma.rn.f32 %f0, %f10, 0f40000000, %f0;\nfma.rn.f32 %f0, %f5, 0f40800000, %f0;\nmul.f32 %f0, %f0, 0f3D800000;\nmad.lo.u32 %r0, %r3, %r9, %r7;\nmul.wide.u32 %rd4, %r0, 4;\nld.param.u64 %rd5, [d_out];\nadd.u64 %rd6, %rd5, %rd4;\nst.global.f32 [%rd6], %f0;\nDONE_BLUR:\nret;\n}\n"
.ascii ".visible .entry k_sobel(.param .u64 d_in, .param .u64 d_out, .param .u32 H, .param .u32 W) {\n.reg .pred %p<3>;\n.reg .b32 %r<16>;\n.reg .b64 %rd<8>;\n.reg .f32 %f<14>;\nmov.u32 %r0, %ctaid.y;\nmov.u32 %r1, %ntid.y;\nmov.u32 %r2, %tid.y;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nmov.u32 %r4, %ctaid.x;\nmov.u32 %r5, %ntid.x;\nmov.u32 %r6, %tid.x;\nmad.lo.u32 %r7, %r4, %r5, %r6;\nld.param.u32 %r8, [H];\nld.param.u32 %r9, [W];\nsetp.ge.u32 %p0, %r3, %r8;\nsetp.ge.u32 %p1, %r7, %r9;\nor.pred %p2, %p0, %p1;\n@%p2 bra DONE_SOBEL;\nsub.s32 %r10, %r3, 1;\nmax.s32 %r10, %r10, 0;\nadd.u32 %r11, %r3, 1;\nsub.u32 %r12, %r8, 1;\nmin.u32 %r11, %r11, %r12;\nsub.s32 %r13, %r7, 1;\nmax.s32 %r13, %r13, 0;\nadd.u32 %r14, %r7, 1;\nsub.u32 %r15, %r9, 1;\nmin.u32 %r14, %r14, %r15;\nld.param.u64 %rd1, [d_in];\nmad.lo.u32 %r0, %r10, %r9, %r13;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f1, [%rd3];\nmad.lo.u32 %r0, %r10, %r9, %r7;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f2, [%rd3];\nmad.lo.u32 %r0, %r10, %r9, %r14;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f3, [%rd3];\nmad.lo.u32 %r0, %r3, %r9, %r13;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f4, [%rd3];\nmad.lo.u32 %r0, %r3, %r9, %r14;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f6, [%rd3];\nmad.lo.u32 %r0, %r11, %r9, %r13;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f7, [%rd3];\nmad.lo.u32 %r0, %r11, %r9, %r7;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f8, [%rd3];\nmad.lo.u32 %r0, %r11, %r9, %r14;\nmul.wide.u32 %rd2, %r0, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f9, [%rd3];\nsub.f32 %f10, %f3, %f1;\nsub.f32 %f11, %f6, %f4;\nfma.rn.f32 %f10, %f11, 0f40000000, %f10;\nsub.f32 %f12, %f9, %f7;\nadd.f32 %f10, %f10, %f12;\nsub.f32 %f13, %f7, %f1;\nsub.f32 %f11, %f8, %f2;\nfma.rn.f32 %f13, %f11, 0f40000000, %f13;\nsub.f32 %f12, %f9, %f3;\nadd.f32 %f13, %f13, %f12;\nmul.f32 %f0, %f10, %f10;\nfma.rn.f32 %f0, %f13, %f13, %f0;\nsqrt.approx.f32 %f0, %f0;\nmad.lo.u32 %r0, %r3, %r9, %r7;\nmul.wide.u32 %rd4, %r0, 4;\nld.param.u64 %rd5, [d_out];\nadd.u64 %rd6, %rd5, %rd4;\nst.global.f32 [%rd6], %f0;\nDONE_SOBEL:\nret;\n}\n"
.asciz ".visible .entry k_resize_bilinear(.param .u64 d_in, .param .u64 d_out, .param .u32 inH, .param .u32 inW, .param .u32 outH, .param .u32 outW) {\n.reg .pred %p<3>;\n.reg .b32 %r<16>;\n.reg .b64 %rd<8>;\n.reg .f32 %f<18>;\nmov.u32 %r0, %ctaid.y;\nmov.u32 %r1, %ntid.y;\nmov.u32 %r2, %tid.y;\nmad.lo.u32 %r3, %r0, %r1, %r2;\nmov.u32 %r4, %ctaid.x;\nmov.u32 %r5, %ntid.x;\nmov.u32 %r6, %tid.x;\nmad.lo.u32 %r7, %r4, %r5, %r6;\nld.param.u32 %r8, [outH];\nld.param.u32 %r9, [outW];\nsetp.ge.u32 %p0, %r3, %r8;\nsetp.ge.u32 %p1, %r7, %r9;\nor.pred %p2, %p0, %p1;\n@%p2 bra DONE_RESIZE;\nld.param.u32 %r10, [inH];\nld.param.u32 %r11, [inW];\ncvt.rn.f32.u32 %f1, %r10;\ncvt.rn.f32.u32 %f2, %r8;\ndiv.approx.f32 %f3, %f1, %f2;\ncvt.rn.f32.u32 %f4, %r11;\ncvt.rn.f32.u32 %f5, %r9;\ndiv.approx.f32 %f6, %f4, %f5;\ncvt.rn.f32.u32 %f7, %r3;\nadd.f32 %f7, %f7, 0f3F000000;\nmul.f32 %f7, %f7, %f3;\nsub.f32 %f7, %f7, 0f3F000000;\nmax.f32 %f7, %f7, 0f00000000;\nsub.u32 %r12, %r10, 1;\ncvt.rn.f32.u32 %f8, %r12;\nmin.f32 %f7, %f7, %f8;\ncvt.rn.f32.u32 %f9, %r7;\nadd.f32 %f9, %f9, 0f3F000000;\nmul.f32 %f9, %f9, %f6;\nsub.f32 %f9, %f9, 0f3F000000;\nmax.f32 %f9, %f9, 0f00000000;\nsub.u32 %r13, %r11, 1;\ncvt.rn.f32.u32 %f10, %r13;\nmin.f32 %f9, %f9, %f10;\ncvt.rzi.u32.f32 %r14, %f7;\ncvt.rn.f32.u32 %f11, %r14;\nsub.f32 %f12, %f7, %f11;\nadd.u32 %r15, %r14, 1;\nmin.u32 %r15, %r15, %r12;\ncvt.rzi.u32.f32 %r0, %f9;\ncvt.rn.f32.u32 %f13, %r0;\nsub.f32 %f14, %f9, %f13;\nadd.u32 %r1, %r0, 1;\nmin.u32 %r1, %r1, %r13;\nld.param.u64 %rd1, [d_in];\nmad.lo.u32 %r2, %r14, %r11, %r0;\nmul.wide.u32 %rd2, %r2, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f15, [%rd3];\nmad.lo.u32 %r2, %r14, %r11, %r1;\nmul.wide.u32 %rd2, %r2, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f16, [%rd3];\nmad.lo.u32 %r2, %r15, %r11, %r0;\nmul.wide.u32 %rd2, %r2, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f17, [%rd3];\nmad.lo.u32 %r2, %r15, %r11, %r1;\nmul.wide.u32 %rd2, %r2, 4;\nadd.u64 %rd3, %rd1, %rd2;\nld.global.f32 %f8, [%rd3];\nsub.f32 %f10, 0f3F800000, %f14;\nmul.f32 %f0, %f10, %f15;\nfma.rn.f32 %f0, %f14, %f16, %f0;\nmul.f32 %f2, %f10, %f17;\nfma.rn.f32 %f2, %f14, %f8, %f2;\nsub.f32 %f4, 0f3F800000, %f12;\nmul.f32 %f5, %f4, %f0;\nfma.rn.f32 %f5, %f12, %f2, %f5;\nmad.lo.u32 %r2, %r3, %r9, %r7;\nmul.wide.u32 %rd4, %r2, 4;\nld.param.u64 %rd5, [d_out];\nadd.u64 %rd6, %rd5, %rd4;\nst.global.f32 [%rd6], %f5;\nDONE_RESIZE:\nret;\n}\n"

.text

# ==============================================================================
# Internal Helper: Resolve Driver API Functions in Assembly
# ==============================================================================
.globl asm_gpu_init
asm_gpu_init:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 88

    cmp dword ptr [rip + gpu_is_inited], 1
    je .init_already_done

    mov dword ptr [rip + gpu_is_inited], 1
    mov dword ptr [rip + gpu_has_cuda], 0

    # LoadLibraryA("nvcuda.dll")
    lea rcx, [rip + gpu_str_nvcuda]
    call LoadLibraryA
    test rax, rax
    jz .init_fail
    mov [rip + gpu_hmodule], rax
    mov rbx, rax    # rbx = nvcuda module handle

    # Macro/Helper to get proc address
    # 1. cuInit
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuInit]
    call GetProcAddress
    mov [rip + gpu_p_cuInit], rax
    test rax, rax
    jz .init_fail

    # Call cuInit(0)
    xor ecx, ecx
    call [rip + gpu_p_cuInit]
    test eax, eax
    jnz .init_fail

    # 2. cuDeviceGetCount
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuDeviceGetCount]
    call GetProcAddress
    mov [rip + gpu_p_cuDeviceGetCount], rax
    lea rcx, [rip + gpu_dev_count]
    call rax
    cmp dword ptr [rip + gpu_dev_count], 0
    jle .init_fail

    # 3. cuDeviceGet
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuDeviceGet]
    call GetProcAddress
    mov [rip + gpu_p_cuDeviceGet], rax
    lea rcx, [rip + gpu_dev_id]
    xor edx, edx
    call rax

    # 4. cuDeviceGetName
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuDeviceGetName]
    call GetProcAddress
    mov [rip + gpu_p_cuDeviceGetName], rax
    lea rcx, [rip + gpu_device_name]
    mov edx, 256
    mov r8d, [rip + gpu_dev_id]
    call rax

    # 5. cuDeviceTotalMem
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuDeviceTotalMem]
    call GetProcAddress
    test rax, rax
    jnz 1f
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuDeviceTotalMem_old]
    call GetProcAddress
1:
    mov [rip + gpu_p_cuDeviceTotalMem], rax
    lea rcx, [rip + gpu_total_vram]
    mov edx, [rip + gpu_dev_id]
    call rax

    # 6. cuCtxCreate
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuCtxCreate]
    call GetProcAddress
    test rax, rax
    jnz 2f
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuCtxCreate_old]
    call GetProcAddress
2:
    mov [rip + gpu_p_cuCtxCreate], rax
    lea rcx, [rip + gpu_ctx]
    xor edx, edx
    mov r8d, [rip + gpu_dev_id]
    call rax
    test eax, eax
    jnz .init_fail

    # Resolve memory & kernel execution functions
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuCtxSynchronize]
    call GetProcAddress
    mov [rip + gpu_p_cuCtxSynchronize], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemAlloc]
    call GetProcAddress
    test rax, rax
    jnz 3f
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemAlloc_old]
    call GetProcAddress
3:
    mov [rip + gpu_p_cuMemAlloc], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemFree]
    call GetProcAddress
    test rax, rax
    jnz 4f
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemFree_old]
    call GetProcAddress
4:
    mov [rip + gpu_p_cuMemFree], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemcpyHtoD]
    call GetProcAddress
    test rax, rax
    jnz 5f
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemcpyHtoD_old]
    call GetProcAddress
5:
    mov [rip + gpu_p_cuMemcpyHtoD], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemcpyDtoH]
    call GetProcAddress
    test rax, rax
    jnz 6f
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemcpyDtoH_old]
    call GetProcAddress
6:
    mov [rip + gpu_p_cuMemcpyDtoH], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuModuleLoadData]
    call GetProcAddress
    mov [rip + gpu_p_cuModuleLoadData], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuModuleGetFunction]
    call GetProcAddress
    mov [rip + gpu_p_cuModuleGetFunction], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuLaunchKernel]
    call GetProcAddress
    mov [rip + gpu_p_cuLaunchKernel], rax

    # cuMemcpyDtoD
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemcpyDtoD]
    call GetProcAddress
    test rax, rax
    jnz 7f
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemcpyDtoD_old]
    call GetProcAddress
7:
    mov [rip + gpu_p_cuMemcpyDtoD], rax

    # Stream APIs
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuStreamCreate]
    call GetProcAddress
    mov [rip + gpu_p_cuStreamCreate], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuStreamDestroy]
    call GetProcAddress
    test rax, rax
    jnz 8f
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuStreamDestroy_old]
    call GetProcAddress
8:
    mov [rip + gpu_p_cuStreamDestroy], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuStreamSynchronize]
    call GetProcAddress
    mov [rip + gpu_p_cuStreamSynchronize], rax

    # Event APIs
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuEventCreate]
    call GetProcAddress
    mov [rip + gpu_p_cuEventCreate], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuEventRecord]
    call GetProcAddress
    mov [rip + gpu_p_cuEventRecord], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuEventSynchronize]
    call GetProcAddress
    mov [rip + gpu_p_cuEventSynchronize], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuEventElapsedTime]
    call GetProcAddress
    mov [rip + gpu_p_cuEventElapsedTime], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuEventDestroy]
    call GetProcAddress
    test rax, rax
    jnz 9f
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuEventDestroy_old]
    call GetProcAddress
9:
    mov [rip + gpu_p_cuEventDestroy], rax

    # Resolve Advanced Driver APIs
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemAllocManaged]
    call GetProcAddress
    mov [rip + gpu_p_cuMemAllocManaged], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemAllocHost]
    call GetProcAddress
    test rax, rax
    jnz .res_host_done
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemAllocHost_old]
    call GetProcAddress
.res_host_done:
    mov [rip + gpu_p_cuMemAllocHost], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemFreeHost]
    call GetProcAddress
    mov [rip + gpu_p_cuMemFreeHost], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemGetInfo]
    call GetProcAddress
    test rax, rax
    jnz .res_info_done
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemGetInfo_old]
    call GetProcAddress
.res_info_done:
    mov [rip + gpu_p_cuMemGetInfo], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemcpyHtoDAsync]
    call GetProcAddress
    test rax, rax
    jnz .res_htod_async_done
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemcpyHtoDAsync_old]
    call GetProcAddress
.res_htod_async_done:
    mov [rip + gpu_p_cuMemcpyHtoDAsync], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemcpyDtoHAsync]
    call GetProcAddress
    test rax, rax
    jnz .res_dtoh_async_done
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemcpyDtoHAsync_old]
    call GetProcAddress
.res_dtoh_async_done:
    mov [rip + gpu_p_cuMemcpyDtoHAsync], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemcpyDtoDAsync]
    call GetProcAddress
    test rax, rax
    jnz .res_dtod_async_done
    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemcpyDtoDAsync_old]
    call GetProcAddress
.res_dtod_async_done:
    mov [rip + gpu_p_cuMemcpyDtoDAsync], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuMemPrefetchAsync]
    call GetProcAddress
    mov [rip + gpu_p_cuMemPrefetchAsync], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuStreamWaitEvent]
    call GetProcAddress
    mov [rip + gpu_p_cuStreamWaitEvent], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuStreamQuery]
    call GetProcAddress
    mov [rip + gpu_p_cuStreamQuery], rax

    mov rcx, rbx
    lea rdx, [rip + gpu_str_cuEventQuery]
    call GetProcAddress
    mov [rip + gpu_p_cuEventQuery], rax

    # Load Embedded PTX Module
    lea rcx, [rip + gpu_module]
    lea rdx, [rip + gpu_ptx_code]
    call [rip + gpu_p_cuModuleLoadData]
    test eax, eax
    jnz .init_ptx_done

    # Resolve all compute kernels
    mov r12, [rip + gpu_module]

    lea rcx, [rip + gpu_fn_vec_add]
    mov rdx, r12
    lea r8, [rip + gpu_kname_vec_add]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_vec_sub]
    mov rdx, r12
    lea r8, [rip + gpu_kname_vec_sub]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_vec_mul]
    mov rdx, r12
    lea r8, [rip + gpu_kname_vec_mul]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_vec_div]
    mov rdx, r12
    lea r8, [rip + gpu_kname_vec_div]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_vec_scale]
    mov rdx, r12
    lea r8, [rip + gpu_kname_vec_scale]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_relu]
    mov rdx, r12
    lea r8, [rip + gpu_kname_relu]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_sigmoid]
    mov rdx, r12
    lea r8, [rip + gpu_kname_sigmoid]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_fill]
    mov rdx, r12
    lea r8, [rip + gpu_kname_fill]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_tiled_gemm]
    mov rdx, r12
    lea r8, [rip + gpu_kname_tiled_gemm]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_rgb_to_gray]
    mov rdx, r12
    lea r8, [rip + gpu_kname_rgb_to_gray]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_transpose]
    mov rdx, r12
    lea r8, [rip + gpu_kname_transpose]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_gelu]
    mov rdx, r12
    lea r8, [rip + gpu_kname_gelu]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_silu]
    mov rdx, r12
    lea r8, [rip + gpu_kname_silu]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_softmax]
    mov rdx, r12
    lea r8, [rip + gpu_kname_softmax]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_layernorm]
    mov rdx, r12
    lea r8, [rip + gpu_kname_layernorm]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_rmsnorm]
    mov rdx, r12
    lea r8, [rip + gpu_kname_rmsnorm]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_conv2d]
    mov rdx, r12
    lea r8, [rip + gpu_kname_conv2d]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_maxpool2d]
    mov rdx, r12
    lea r8, [rip + gpu_kname_maxpool2d]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_blur]
    mov rdx, r12
    lea r8, [rip + gpu_kname_blur]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_sobel]
    mov rdx, r12
    lea r8, [rip + gpu_kname_sobel]
    call [rip + gpu_p_cuModuleGetFunction]

    lea rcx, [rip + gpu_fn_resize]
    mov rdx, r12
    lea r8, [rip + gpu_kname_resize]
    call [rip + gpu_p_cuModuleGetFunction]

.init_ptx_done:
    mov dword ptr [rip + gpu_has_cuda], 1
    mov eax, 1
    jmp .init_exit

.init_fail:
    mov dword ptr [rip + gpu_has_cuda], 0
    mov eax, 0
    jmp .init_exit

.init_already_done:
    mov eax, [rip + gpu_has_cuda]

.init_exit:
    add rsp, 88
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

# ==============================================================================
# Pure Assembly VRAM Slab Allocator (Zero-Overhead VRAM Pooling)
# ==============================================================================
# asm_gpu_alloc_vram(CUdeviceptr* out_ptr, size_t bytes)
# rcx = out_ptr
# rdx = bytes
# returns: eax = 0 (CUDA_SUCCESS), non-zero on error
.globl asm_gpu_alloc_vram
asm_gpu_alloc_vram:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    sub rsp, 56

    mov r12, rcx            # r12 = out_ptr
    mov r13, rdx            # r13 = requested bytes

    # Align size to 256 bytes: (bytes + 255) & ~255
    add rdx, 255
    and rdx, -256
    mov rbx, rdx            # rbx = aligned bytes

    # Check slab pool count
    mov rsi, [rip + gpu_vram_pool_count]
    test rsi, rsi
    jz .slab_alloc_fresh

    # Search slab pool for best fit
    lea rdi, [rip + gpu_vram_pool]
    xor ecx, ecx            # i = 0
.slab_search_lp:
    cmp rcx, rsi
    jge .slab_alloc_fresh
    mov r8, [rdi + 8]       # slot capacity
    cmp r8, rbx
    jb .slab_search_next
    # Allow capacity up to 2x rbx
    mov r9, rbx
    shl r9, 1
    cmp r8, r9
    ja .slab_search_next

    # Match found in current slot rdi!
    mov rax, [rdi]          # cached d_ptr
    mov [r12], rax          # *out_ptr = d_ptr

    # Remove slot rcx: replace with last slot [rsi - 1]
    dec rsi
    mov [rip + gpu_vram_pool_count], rsi
    cmp rcx, rsi
    je .slab_search_hit
    mov r10, rsi
    shl r10, 4
    lea rdx, [rip + gpu_vram_pool]
    add rdx, r10            # rdx = &gpu_vram_pool[rsi]
    mov r10, [rdx]
    mov r11, [rdx + 8]
    mov [rdi], r10
    mov [rdi + 8], r11
.slab_search_hit:
    xor eax, eax                   # CUDA_SUCCESS = 0
    jmp .slab_alloc_done

.slab_search_next:
    add rdi, 16
    inc rcx
    jmp .slab_search_lp

.slab_alloc_fresh:
    # Delegate to driver cuMemAlloc
    mov rcx, r12
    mov rdx, rbx
    call [rip + gpu_p_cuMemAlloc]

.slab_alloc_done:
    add rsp, 56
    pop r13
    pop r12
    pop rdi
    pop rsi
    pop rbx
    pop rbp
    ret

# asm_gpu_free_vram(CUdeviceptr d_ptr, size_t bytes)
# rcx = d_ptr
# rdx = bytes
# returns: eax = 0 (success)
.globl asm_gpu_free_vram
asm_gpu_free_vram:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    sub rsp, 32

    test rcx, rcx
    jz .slab_free_done

    mov rbx, rcx            # rbx = d_ptr
    mov rsi, rdx            # rsi = bytes

    # Align size
    add rsi, 255
    and rsi, -256

    # If count < 512 and size > 0, store in slab pool
    mov rax, [rip + gpu_vram_pool_count]
    cmp rax, 512
    jge .slab_free_driver
    test rsi, rsi
    jz .slab_free_driver

    lea rdx, [rip + gpu_vram_pool]
    shl rax, 4
    add rdx, rax
    mov [rdx], rbx          # d_ptr
    mov [rdx + 8], rsi      # capacity
    inc qword ptr [rip + gpu_vram_pool_count]
    xor eax, eax
    jmp .slab_free_done

.slab_free_driver:
    mov rcx, rbx
    call [rip + gpu_p_cuMemFree]

.slab_free_done:
    xor eax, eax
    add rsp, 32
    pop rsi
    pop rbx
    pop rbp
    ret

# ==============================================================================
# Handle Table Management in Assembly
# ==============================================================================
# Register a handle:
# rcx = type (1=buf, 2=tensor, 3=kernel)
# rdx = d_ptr
# r8  = size_bytes
# r9  = is_device
# [rsp+40] = dim0, [rsp+48] = dim1
# returns: rax = handle_id
asm_gpu_register_handle:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi

    # Find free slot in gpu_handle_table (16384 entries x 48 bytes)
    lea rdi, [rip + gpu_handle_table]
    mov eax, 16384
.find_slot:
    cmp qword ptr [rdi], 0
    je .found_slot
    add rdi, 48
    dec eax
    jnz .find_slot
    # Table full
    xor eax, eax
    jmp .reg_done

.found_slot:
    mov rax, [rip + gpu_next_handle_id]
    inc qword ptr [rip + gpu_next_handle_id]
    mov [rdi], rax          # handle_id
    mov [rdi + 8], rcx      # type
    mov [rdi + 16], rdx     # d_ptr
    mov [rdi + 24], r8      # size_bytes
    mov [rdi + 32], r9      # is_device
    mov r10d, [rbp + 48]
    mov [rdi + 40], r10d    # dim0
    mov r11d, [rbp + 56]
    mov [rdi + 44], r11d    # dim1

.reg_done:
    pop rdi
    pop rsi
    pop rbx
    pop rbp
    ret

# Lookup handle: rcx = handle_id -> returns rax = entry pointer (or 0)
asm_gpu_lookup_handle:
    test rcx, rcx
    jz .lookup_null
    # Fast path: O(1) direct index check
    cmp rcx, 16384
    ja .lookup_full_scan
    lea rdx, [rcx - 1]
    imul rdx, 48
    lea rax, [rip + gpu_handle_table]
    add rax, rdx
    cmp [rax], rcx
    je .lookup_found
.lookup_full_scan:
    lea rax, [rip + gpu_handle_table]
    mov edx, 16384
.lookup_loop:
    cmp [rax], rcx
    je .lookup_found
    add rax, 48
    dec edx
    jnz .lookup_loop
.lookup_null:
    xor eax, eax
    ret
.lookup_found:
    ret

# Free handle: rcx = handle_id -> returns rax = 1 (freed) or 0
asm_gpu_free_handle:
    push rbp
    mov rbp, rsp
    push rbx
    sub rsp, 40
    call asm_gpu_lookup_handle
    test rax, rax
    jz .free_fail

    mov rbx, rax
    mov rcx, [rbx + 16]      # d_ptr
    mov rdx, [rbx + 24]      # size_bytes
    mov r8,  [rbx + 32]      # is_device
    mov r9,  [rbx + 8]       # type

    cmp r9, 6                # type 6 = pinned
    je .free_pinned
    cmp r9, 5                # type 5 = managed
    je .free_managed
    cmp r9, 3                # type 3 = stream
    je .free_stream
    cmp r9, 4                # type 4 = event
    je .free_event

    test r8, r8
    jz .free_host
    # Device free via slab allocator
    call asm_gpu_free_vram
    jmp .free_clear

.free_pinned:
    call [rip + gpu_p_cuMemFreeHost]
    jmp .free_clear

.free_managed:
    call [rip + gpu_p_cuMemFree]
    jmp .free_clear

.free_stream:
    call [rip + gpu_p_cuStreamDestroy]
    jmp .free_clear

.free_event:
    call [rip + gpu_p_cuEventDestroy]
    jmp .free_clear

.free_host:
    call free

.free_clear:
    # Clear entry
    mov qword ptr [rbx], 0
    mov qword ptr [rbx + 8], 0
    mov qword ptr [rbx + 16], 0
    mov qword ptr [rbx + 24], 0
    mov qword ptr [rbx + 32], 0
    mov qword ptr [rbx + 40], 0
    mov eax, 1
    add rsp, 40
    pop rbx
    pop rbp
    ret
.free_fail:
    xor eax, eax
    add rsp, 40
    pop rbx
    pop rbp
    ret

# ==============================================================================
# Nexus GC String & Array Allocator Wrappers in Assembly
# ==============================================================================
asm_create_nexus_string:
    push rbp
    mov rbp, rsp
    push rsi
    push rdi
    push rbx
    sub rsp, 48

    mov rsi, rcx    # rsi = source string
    test rsi, rsi
    jnz 1f
    lea rsi, [rip + gpu_fallback_name]
1:
    # strlen
    xor eax, eax
.str_len_lp:
    cmp byte ptr [rsi + rax], 0
    je .str_len_dn
    inc rax
    jmp .str_len_lp
.str_len_dn:
    mov rbx, rax    # rbx = len
    inc rax         # +1 for null
    mov rcx, rax
    xor edx, edx
    call gc_malloc
    test rax, rax
    jz .str_alloc_fail

    # memcpy chars
    mov rdi, rax
    mov rcx, rbx
.str_cp_lp:
    test rcx, rcx
    jz .str_cp_dn
    mov dl, [rsi]
    mov [rdi], dl
    inc rsi
    inc rdi
    dec rcx
    jmp .str_cp_lp
.str_cp_dn:
    mov byte ptr [rdi], 0

.str_alloc_fail:
    add rsp, 48
    pop rbx
    pop rdi
    pop rsi
    pop rbp
    ret

# Create Nexus array from float buffer:
# rcx = float* buffer, rdx = count
# returns rax = Nexus array pointer
asm_create_nexus_array_from_floats:
    push rbp
    mov rbp, rsp
    push rsi
    push rdi
    push rbx
    push r12
    push r13
    sub rsp, 48

    mov rsi, rcx    # rsi = float buffer
    mov r12, rdx    # r12 = count

    # Allocation size = count * 8 bytes
    mov rax, r12
    shl rax, 3
    cmp rax, 8
    jae 1f
    mov rax, 8
1:
    mov rcx, rax
    mov rdx, 0x4152524159   # "ARRAY"
    call gc_malloc
    test rax, rax
    jz .arr_alloc_fail

    # Setup array headers:
    # [rax - 32] = "ARRAY"
    # [rax - 24] = capacity in bytes
    # [rax - 16] = length as double
    mov r10, 0x4152524159
    mov [rax - 32], r10
    mov r11, r12
    shl r11, 3
    mov [rax - 24], r11
    cvtsi2sd xmm0, r12
    movsd [rax - 16], xmm0
    mov [rax - 8], r12

    # Convert floats to doubles:
    mov rdi, rax
    xor ecx, ecx
.arr_conv_lp:
    cmp rcx, r12
    jae .arr_conv_dn
    cvtss2sd xmm1, [rsi + rcx * 4]
    movsd [rdi + rcx * 8], xmm1
    inc rcx
    jmp .arr_conv_lp
.arr_conv_dn:

.arr_alloc_fail:
    add rsp, 48
    pop r13
    pop r12
    pop rbx
    pop rdi
    pop rsi
    pop rbp
    ret

# Extract floats from Nexus array:
# rcx = array pointer, rdx = out_count (pointer to uint64_t)
# returns rax = float* buffer
asm_extract_floats_from_nexus_array:
    push rbp
    mov rbp, rsp
    push rsi
    push rdi
    push rbx
    push r12
    sub rsp, 48

    push rdx
    call asm_gpu_is_nexus_array
    pop rdx
    jne .ext_fail

    movsd xmm0, [rcx - 16]
    cvttsd2si r12, xmm0     # r12 = count
    test rdx, rdx
    jz 1f
    mov [rdx], r12
1:
    test r12, r12
    jle .ext_fail

    # Allocate temp float buffer: count * 4
    mov rsi, rcx
    mov rcx, r12
    shl rcx, 2
    call malloc
    test rax, rax
    jz .ext_fail

    mov rdi, rax
    xor ecx, ecx
.ext_lp:
    cmp rcx, r12
    jae .ext_dn
    movsd xmm1, [rsi + rcx * 8]
    cvtsd2ss xmm2, xmm1
    movss [rdi + rcx * 4], xmm2
    inc rcx
    jmp .ext_lp
.ext_dn:
    add rsp, 48
    pop r12
    pop rbx
    pop rdi
    pop rsi
    pop rbp
    ret

.ext_fail:
    xor eax, eax
    add rsp, 48
    pop r12
    pop rbx
    pop rdi
    pop rsi
    pop rbp
    ret

# Helper: Check if rcx is a valid Nexus heap array pointer
# Returns ZF=1 (je) if valid array, ZF=0 (jne) if not. Clobbers rax.
asm_gpu_is_nexus_array:
    test rcx, rcx
    jz .not_array
    mov rax, 0x00007FFFFFFFFFFF
    cmp rcx, rax
    ja .not_array
    cmp rcx, 0x10000
    jb .not_array
    mov rax, 0x4152524159       # "ARRAY"
    cmp [rcx - 32], rax
    ret
.not_array:
    xor eax, eax
    inc eax                     # clear ZF (ZF = 0, so jne branches)
    ret

# ==============================================================================
# Main GPU Dispatcher in Pure Assembly
# Called by op_gpu_dispatch in nexus_core.s
# rcx = dest_reg, rdx = op_reg, r8 = args_reg, r9 = vm_regs (rdi/rbx)
# ==============================================================================
.globl asm_gpu_dispatch
asm_gpu_dispatch:
    push rbp
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    mov rbp, rsp
    sub rsp, 408

    # Preserve all incoming arguments immediately on stack
    mov [rbp - 8],  rcx    # dest_reg
    mov [rbp - 16], rdx    # op_reg
    mov [rbp - 24], r8     # args_reg
    mov [rbp - 32], r9     # vm_regs

    mov r12, rcx           # r12 = dest_reg
    mov r13, r9            # r13 = vm_regs

    # Auto-initialize driver if not already done
    call asm_gpu_init

    # Reload volatile argument registers because asm_gpu_init invoked Windows APIs
    mov rdx, [rbp - 16]    # op_reg
    mov r8,  [rbp - 24]    # args_reg
    mov r13, [rbp - 32]    # vm_regs
    mov r12, [rbp - 8]     # dest_reg

    # Read op_id from vm_regs[op_reg]
    movsd xmm0, [r13 + rdx * 8]
    cvttsd2si r14, xmm0    # r14 = op_id

    # Read args pointer from vm_regs[args_reg]
    mov r15, [r13 + r8 * 8] # r15 = args (array pointer or scalar)

    # --------------------------------------------------------------------------
    # OP 0: GPU_INIT
    # --------------------------------------------------------------------------
    cmp r14, 0
    jne .check_op_1
    mov eax, [rip + gpu_has_cuda]
    cvtsi2sd xmm0, rax
    movsd [r13 + r12 * 8], xmm0
    jmp .dispatch_done

.check_op_1:
    # --------------------------------------------------------------------------
    # OP 1: GPU_DEVICE_COUNT
    # --------------------------------------------------------------------------
    cmp r14, 1
    jne .check_op_2
    mov eax, [rip + gpu_dev_count]
    cvtsi2sd xmm0, rax
    movsd [r13 + r12 * 8], xmm0
    jmp .dispatch_done

.check_op_2:
    # --------------------------------------------------------------------------
    # OP 2: GPU_DEVICE_NAME
    # --------------------------------------------------------------------------
    cmp r14, 2
    jne .check_op_3
    cmp dword ptr [rip + gpu_has_cuda], 1
    je 1f
    lea rcx, [rip + gpu_fallback_name]
    jmp 2f
1:
    lea rcx, [rip + gpu_device_name]
2:
    call asm_create_nexus_string
    mov [r13 + r12 * 8], rax
    jmp .dispatch_done

.check_op_3:
    # --------------------------------------------------------------------------
    # OP 3: GPU_TOTAL_MEM (in MB)
    # --------------------------------------------------------------------------
    cmp r14, 3
    jne .check_op_4
    mov rax, [rip + gpu_total_vram]
    shr rax, 20     # bytes -> MB
    cvtsi2sd xmm0, rax
    movsd [r13 + r12 * 8], xmm0
    jmp .dispatch_done

.check_op_4:
    # --------------------------------------------------------------------------
    # OP 4: GPU_FREE_MEM (in MB)
    # --------------------------------------------------------------------------
    cmp r14, 4
    jne .check_op_5
    mov rax, [rip + gpu_p_cuMemGetInfo]
    test rax, rax
    jz .op4_static
    lea rcx, [rbp - 48]
    lea rdx, [rbp - 56]
    call rax
    test eax, eax
    jnz .op4_static
    mov rax, [rbp - 48]
    shr rax, 20
    cvtsi2sd xmm0, rax
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done
.op4_static:
    mov rax, [rip + gpu_total_vram]
    shr rax, 20
    cvtsi2sd xmm0, rax
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_5:
    # --------------------------------------------------------------------------
    # OP 5: GPU_IS_AVAILABLE
    # --------------------------------------------------------------------------
    cmp r14, 5
    jne .check_op_6
    mov eax, [rip + gpu_has_cuda]
    cvtsi2sd xmm0, rax
    movsd [r13 + r12 * 8], xmm0
    jmp .dispatch_done

.check_op_6:
    # --------------------------------------------------------------------------
    # OP 6: GPU_SYNC
    # --------------------------------------------------------------------------
    cmp r14, 6
    jne .check_op_7
    cmp dword ptr [rip + gpu_has_cuda], 1
    jne 1f
    call [rip + gpu_p_cuCtxSynchronize]
1:
    mov rax, 1
    cvtsi2sd xmm0, rax
    movsd [r13 + r12 * 8], xmm0
    jmp .dispatch_done

.check_op_7:
    # --------------------------------------------------------------------------
    # OP 7: GPU_ALLOC (args[0] = size_bytes)
    # --------------------------------------------------------------------------
    cmp r14, 7
    jne .check_op_8
    # Read size from args array or scalar
    mov rbx, 1024
    test r15, r15
    jz .do_alloc
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .alloc_from_scalar
    movsd xmm0, [r15]
    cvttsd2si rbx, xmm0
    jmp .do_alloc
.alloc_from_scalar:
    mov rdx, [rbp - 24]     # args_reg
    movsd xmm0, [r13 + rdx * 8]
    cvttsd2si rbx, xmm0

.do_alloc:
    xor r14d, r14d         # is_device = 0
    lea rdi, [rbp - 48]    # temp buffer for d_ptr
    cmp dword ptr [rip + gpu_has_cuda], 1
    jne .alloc_host

    # Try asm_gpu_alloc_vram(&d_ptr, size)
    mov rcx, rdi
    mov rdx, rbx
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .alloc_host
    mov r14d, 1            # is_device = 1
    mov rdx, [rdi]
    jmp .register_alloc

.alloc_host:
    mov rcx, rbx
    call malloc
    mov rdx, rax
    xor r14d, r14d

.register_alloc:
    mov rcx, 1             # type = buffer
    mov r8, rbx            # size_bytes
    mov r9, r14            # is_device
    mov qword ptr [rsp + 32], 0
    mov qword ptr [rsp + 40], 0
    call asm_gpu_register_handle
    cvtsi2sd xmm0, rax
    movsd [r13 + r12 * 8], xmm0
    jmp .dispatch_done

.check_op_8:
    # --------------------------------------------------------------------------
    # OP 8: GPU_FREE (args[0] = handle_id)
    # --------------------------------------------------------------------------
    cmp r14, 8
    jne .check_op_9
    test r15, r15
    jz .free_zero
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .free_from_scalar
    movsd xmm0, [r15]
    jmp .do_free
.free_from_scalar:
    mov rdx, [rbp - 24]     # args_reg
    movsd xmm0, [r13 + rdx * 8]
.do_free:
    cvttsd2si rcx, xmm0
    call asm_gpu_free_handle
    cvtsi2sd xmm0, rax
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done
.free_zero:
    xorpd xmm0, xmm0
    movsd [r13 + r12 * 8], xmm0
    jmp .dispatch_done

.check_op_9:
    # --------------------------------------------------------------------------
    # OP 9: GPU_MEMCPY_H2D (args[0] = handle, args[1] = host_array)
    # --------------------------------------------------------------------------
    cmp r14, 9
    jne .check_op_10
    test r15, r15
    jz .h2d_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .h2d_from_regs
    movsd xmm0, [r15]
    mov rsi, [r15 + 8]
    jmp .h2d_have_args
.h2d_from_regs:
    mov rdx, [rbp - 24]     # args_reg
    movsd xmm0, [r13 + rdx * 8]
    inc rdx
    mov rsi, [r13 + rdx * 8]
.h2d_have_args:
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .h2d_fail
    mov rbx, rax            # rbx = handle entry
    lea rdx, [rbp - 40]
    mov rcx, rsi
    call asm_extract_floats_from_nexus_array
    test rax, rax
    jz .h2d_fail
    mov rdi, rax            # rdi = float buffer

    mov r8, [rbp - 40]      # count
    shl r8, 2               # bytes
    cmp r8, [rbx + 24]
    jbe 1f
    mov r8, [rbx + 24]
1:
    mov rdx, [rbx + 32]     # is_device
    test rdx, rdx
    jz .h2d_host

    mov rcx, [rbx + 16]     # d_ptr
    mov rdx, rdi            # src
    # r8 = bytes
    call [rip + gpu_p_cuMemcpyHtoD]
    jmp .h2d_cleanup

.h2d_host:
    mov rcx, [rbx + 16]
    mov rdx, rdi
    call memcpy

.h2d_cleanup:
    mov rcx, rdi
    call free
    mov rax, 1
    cvtsi2sd xmm0, rax
    movsd [r13 + r12 * 8], xmm0
    jmp .dispatch_done

.h2d_fail:
    xorpd xmm0, xmm0
    movsd [r13 + r12 * 8], xmm0
    jmp .dispatch_done

.check_op_10:
    # --------------------------------------------------------------------------
    # OP 10: GPU_MEMCPY_D2H / TENSOR_TO_ARRAY (args[0] = handle)
    # --------------------------------------------------------------------------
    cmp r14, 10
    je .do_d2h
    cmp r14, 15             # OP 15: TENSOR_TO_ARRAY
    jne .check_op_11
.do_d2h:
    test r15, r15
    jz .d2h_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .d2h_from_scalar
    movsd xmm0, [r15]
    jmp .do_d2h_lookup
.d2h_from_scalar:
    mov rdx, [rbp - 24]     # args_reg
    movsd xmm0, [r13 + rdx * 8]
.do_d2h_lookup:
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .d2h_fail
    mov rbx, rax            # handle entry

    mov r14, [rbx + 24]     # bytes
    mov r15, r14
    shr r15, 2              # count = bytes / 4
    test r15, r15
    jle .d2h_fail

    # Allocate temp buffer
    mov rcx, r14
    call malloc
    test rax, rax
    jz .d2h_fail
    mov [rbp - 40], rax     # temp buffer stored in [rbp - 40]

    mov rdx, [rbx + 32]     # is_device
    test rdx, rdx
    jz .d2h_host

    mov rcx, [rbp - 40]     # dst
    mov rdx, [rbx + 16]     # d_ptr
    mov r8, r14             # bytes
    call [rip + gpu_p_cuMemcpyDtoH]
    jmp .d2h_convert

.d2h_host:
    mov rcx, [rbp - 40]     # dst
    mov rdx, [rbx + 16]     # src
    mov r8, r14             # bytes
    call memcpy

.d2h_convert:
    mov rcx, [rbp - 40]
    mov rdx, r15
    call asm_create_nexus_array_from_floats
    push rax
    mov rcx, [rbp - 40]
    call free
    pop rax
    # Write back result to vm_regs[dest_reg]
    mov rdx, [rbp - 8]
    mov [r13 + rdx * 8], rax
    jmp .dispatch_done

.d2h_fail:
    mov rdx, [rbp - 8]
    mov qword ptr [r13 + rdx * 8], 0
    jmp .dispatch_done

.check_op_11:
    # --------------------------------------------------------------------------
    # OP 11: GPU_MEMCPY_D2D (args[0] = dst_handle, args[1] = src_handle, args[2] = bytes)
    # --------------------------------------------------------------------------
    cmp r14, 11
    jne .check_op_12
    test r15, r15
    jz .d2d_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .d2d_from_regs
    movsd xmm0, [r15]       # dst_handle
    movsd xmm1, [r15 + 8]   # src_handle
    jmp .d2d_lookup
.d2d_from_regs:
    mov rdx, [rbp - 24]     # args_reg
    movsd xmm0, [r13 + rdx * 8]
    inc rdx
    movsd xmm1, [r13 + rdx * 8]
.d2d_lookup:
    movsd [rbp - 152], xmm1 # save src_handle
    cvttsd2si rcx, xmm0     # lookup dst_handle
    call asm_gpu_lookup_handle
    test rax, rax
    jz .d2d_fail
    mov rsi, rax            # rsi = dst entry

    movsd xmm1, [rbp - 152]
    cvttsd2si rcx, xmm1     # lookup src_handle
    call asm_gpu_lookup_handle
    test rax, rax
    jz .d2d_fail
    mov rbx, rax            # rbx = src entry

    # Bytes to copy: min(dst.size, src.size)
    mov r8, [rbx + 24]      # src size
    cmp r8, [rsi + 24]
    jbe 1f
    mov r8, [rsi + 24]      # dst size
1:
    # Check if device to device
    mov eax, [rsi + 32]
    and eax, [rbx + 32]
    and eax, [rip + gpu_has_cuda]
    cmp eax, 1
    jne .d2d_host

    # cuMemcpyDtoD(dst, src, bytes)
    mov rcx, [rsi + 16]     # d_dst
    mov rdx, [rbx + 16]     # d_src
    # r8 = bytes
    call [rip + gpu_p_cuMemcpyDtoD]
    test eax, eax
    jnz .d2d_fail
    jmp .d2d_ok

.d2d_host:
    mov rcx, [rsi + 16]     # dst ptr
    mov rdx, [rbx + 16]     # src ptr
    call memcpy
.d2d_ok:
    mov rax, 1
    cvtsi2sd xmm0, rax
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.d2d_fail:
    xorpd xmm0, xmm0
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_12:
    # --------------------------------------------------------------------------
    # OP 12: GPU_TENSOR_NEW (args[0] = shape, args[1] = init_val / array)
    # --------------------------------------------------------------------------
    cmp r14, 12
    jne .check_op_13

    test r15, r15
    jz .t_alloc_host
    # Check if r15 is a wrapper array [shape, init_val]
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .t_from_regs
    mov rsi, [r15]
    mov rcx, rsi
    call asm_gpu_is_nexus_array
    jne .t_from_regs
    # It is [shape_array, init_val]
    movsd xmm0, [r15 + 8]
    cvtsd2ss xmm1, xmm0
    movss [rbp - 92], xmm1
    jmp .t_parse_shape

.t_from_regs:
    mov rsi, r15            # shape is r15
    mov rdx, [rbp - 24]     # args_reg
    inc rdx
    movsd xmm0, [r13 + rdx * 8]
    cvtsd2ss xmm1, xmm0
    movss [rbp - 92], xmm1  # init_val

.t_parse_shape:
    mov rbx, 1              # total elements
    mov r10d, 1             # dim0
    mov r11d, 1             # dim1
    mov rcx, rsi
    call asm_gpu_is_nexus_array
    jne .tensor_scalar_dim
    # From array
    movsd xmm0, [rsi - 16]
    cvttsd2si rcx, xmm0     # ndim
    movsd xmm1, [rsi]
    cvttsd2si r10, xmm1
    mov rbx, r10
    cmp rcx, 1
    jle .tensor_alloc
    movsd xmm2, [rsi + 8]
    cvttsd2si r11, xmm2
    imul rbx, r11
    jmp .tensor_alloc

.tensor_scalar_dim:
    movsd xmm0, [rsi]
    cvttsd2si r10, xmm0
    mov rbx, r10

.tensor_alloc:
    mov [rbp - 56], r10d    # dim0
    mov [rbp - 60], r11d    # dim1
    mov [rbp - 68], rbx     # total_elements

    mov r8, rbx
    shl r8, 2               # bytes
    mov [rbp - 76], r8

    xor r14d, r14d          # is_device
    lea rdi, [rbp - 48]
    cmp dword ptr [rip + gpu_has_cuda], 1
    jne .t_alloc_host

    mov rcx, rdi
    mov rdx, r8
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .t_alloc_host
    mov r14d, 1
    mov rdx, [rdi]
    jmp .t_init_val

.t_alloc_host:
    mov rcx, r8
    call malloc
    mov rdx, rax
    xor r14d, r14d

.t_init_val:
    mov [rbp - 88], rdx     # d_ptr

    # Check if host or GPU fill
    test r14d, r14d
    jz .t_fill_host

    # GPU fill kernel launch
    cmp qword ptr [rip + gpu_fn_fill], 0
    jz .t_reg

    mov rbx, [rbp - 68]     # total
    mov edx, ebx            # n_u32
    mov [rbp - 96], edx

    # setup kargs array: [&d_ptr, &val, &n]
    lea rax, [rbp - 88]
    mov [rbp - 120], rax    # kargs[0] = &d_ptr
    lea rax, [rbp - 92]
    mov [rbp - 112], rax    # kargs[1] = &val
    lea rax, [rbp - 96]
    mov [rbp - 104], rax    # kargs[2] = &n

    # grid = (n + 1023) / 1024 for float4 vectorization
    mov eax, ebx
    add eax, 1023
    shr eax, 10
    test eax, eax
    jnz 1f
    mov eax, 1
1:
    mov rcx, [rip + gpu_fn_fill]
    mov edx, eax            # grid_x
    mov r8d, 1              # grid_y
    mov r9d, 1              # grid_z
    mov dword ptr [rsp + 32], 256 # block_x
    mov dword ptr [rsp + 40], 1   # block_y
    mov dword ptr [rsp + 48], 1   # block_z
    mov dword ptr [rsp + 56], 0   # smem
    mov qword ptr [rsp + 64], 0   # stream
    lea rax, [rbp - 120]
    mov [rsp + 72], rax           # kernelParams
    mov qword ptr [rsp + 80], 0   # extra
    call [rip + gpu_p_cuLaunchKernel]
    jmp .t_reg

.t_fill_host:
    mov rdi, [rbp - 88]
    mov rcx, [rbp - 68]
    movss xmm1, [rbp - 92]
.fill_lp:
    test rcx, rcx
    jz .t_reg
    movss [rdi], xmm1
    add rdi, 4
    dec rcx
    jmp .fill_lp

.t_reg:
    mov rcx, 2              # type = tensor
    mov rdx, [rbp - 88]     # d_ptr
    mov r8,  [rbp - 76]     # size_bytes
    mov r9,  r14            # is_device
    mov r10d, [rbp - 56]
    mov [rsp + 32], r10d
    mov r11d, [rbp - 60]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle

    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_13:
    # --------------------------------------------------------------------------
    # OP 13: GPU_TENSOR_SHAPE (args[0] = Tensor)
    # Returns [dim0, dim1]
    # --------------------------------------------------------------------------
    cmp r14, 13
    jne .check_op_14
    test r15, r15
    jz .shape_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .shape_from_scalar
    movsd xmm0, [r15]
    jmp .shape_lookup
.shape_from_scalar:
    mov rdx, [rbp - 24]     # args_reg
    movsd xmm0, [r13 + rdx * 8]
.shape_lookup:
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .shape_fail
    mov rbx, rax            # rbx = handle entry

    # Allocate 2-element Nexus array: dim0, dim1
    mov rcx, 16             # 2 elements * 8 bytes
    mov rdx, 0x4152524159   # "ARRAY"
    call gc_malloc
    test rax, rax
    jz .shape_fail

    mov r10, 0x4152524159
    mov [rax - 32], r10
    mov qword ptr [rax - 24], 16
    mov r10, 2
    cvtsi2sd xmm0, r10
    movsd [rax - 16], xmm0
    mov qword ptr [rax - 8], 2

    # Write dim0 and dim1 as doubles
    mov edx, [rbx + 40]     # dim0
    cvtsi2sd xmm0, rdx
    movsd [rax], xmm0
    mov edx, [rbx + 44]     # dim1
    cvtsi2sd xmm1, rdx
    movsd [rax + 8], xmm1

    mov rdx, [rbp - 8]
    mov [r13 + rdx * 8], rax
    jmp .dispatch_done

.shape_fail:
    mov rdx, [rbp - 8]
    mov qword ptr [r13 + rdx * 8], 0
    jmp .dispatch_done

.check_op_14:
    # --------------------------------------------------------------------------
    # OP 14: GPU_TENSOR_RESHAPE (args[0] = Tensor, args[1] = new_shape [dim0, dim1])
    # --------------------------------------------------------------------------
    cmp r14, 14
    jne .check_op_16
    test r15, r15
    jz .reshape_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .reshape_from_regs
    movsd xmm0, [r15]
    mov rsi, [r15 + 8]
    jmp .reshape_have_args
.reshape_from_regs:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
    inc rdx
    mov rsi, [r13 + rdx * 8]
.reshape_have_args:
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .reshape_fail
    mov rbx, rax

    # Read new dimensions from rsi
    mov rcx, rsi
    call asm_gpu_is_nexus_array
    jne .reshape_fail

    movsd xmm0, [rsi]
    cvttsd2si r10, xmm0     # new_dim0
    mov r11, 1              # new_dim1
    movsd xmm1, [rsi - 16]
    cvttsd2si rcx, xmm1
    cmp rcx, 1
    jle 1f
    movsd xmm2, [rsi + 8]
    cvttsd2si r11, xmm2
1:
    # Check that new_dim0 * new_dim1 * 4 <= size_bytes [rbx + 24]
    mov rax, r10
    imul rax, r11
    shl rax, 2
    cmp rax, [rbx + 24]
    ja .reshape_fail

    mov [rbx + 40], r10d
    mov [rbx + 44], r11d

    mov rax, [rbx]          # handle_id
    cvtsi2sd xmm0, rax
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.reshape_fail:
    xorpd xmm0, xmm0
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_16:
    # --------------------------------------------------------------------------
    # OP 16: GPU_TENSOR_GET_ITEM (args = [tensor, row, col])
    # Memory-Safe Scalar Element Access with Hardware Bounds Checking
    # --------------------------------------------------------------------------
    cmp r14, 16
    jne .check_op_17
    test r15, r15
    jz .get_item_fail

    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .get_item_fail
    mov rsi, rax            # rsi = handle entry

    # Default row=0, col=0
    xor r10d, r10d          # row
    xor r11d, r11d          # col
    movsd xmm0, [r15 - 16]
    cvttsd2si rcx, xmm0
    cmp rcx, 1
    jle 1f
    movsd xmm0, [r15 + 8]
    cvttsd2si r10d, xmm0    # row
1:
    cmp rcx, 2
    jle 2f
    movsd xmm0, [r15 + 16]
    cvttsd2si r11d, xmm0    # col
2:
    # Memory Safety Bounds Check:
    # 0 <= row < dim0 [rsi + 40]
    # 0 <= col < dim1 [rsi + 44]
    test r10d, r10d
    jl .get_item_fail
    cmp r10d, [rsi + 40]
    jge .get_item_fail
    test r11d, r11d
    jl .get_item_fail
    cmp r11d, [rsi + 44]
    jge .get_item_fail

    # Linear index = row * dim1 + col
    mov eax, r10d
    imul eax, [rsi + 44]
    add eax, r11d
    shl rax, 2              # offset in bytes

    # Check offset < size_bytes
    cmp rax, [rsi + 24]
    jae .get_item_fail

    mov rbx, [rsi + 16]     # ptr (device or host)
    add rbx, rax

    cmp dword ptr [rsi + 32], 1
    jne .get_item_host

    # Read float from CUDA VRAM
    lea rcx, [rbp - 48]
    mov rdx, rbx
    mov r8d, 4
    call [rip + gpu_p_cuMemcpyDtoH]
    test eax, eax
    jnz .get_item_fail
    cvtss2sd xmm0, dword ptr [rbp - 48]
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.get_item_host:
    cvtss2sd xmm0, dword ptr [rbx]
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.get_item_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_17:
    # --------------------------------------------------------------------------
    # OP 17: GPU_MATMUL (args[0] = Tensor A, args[1] = Tensor B)
    # Ultra-Fast Tiled GEMM on GPU Cores (or AVX2 SIMD fallback)
    # --------------------------------------------------------------------------
    cmp r14, 17
    jne .check_op_18

    test r15, r15
    jz .gemm_fail
    mov qword ptr [rbp - 160], 0   # 0 = allocate new handle
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .gemm_from_regs
    movsd xmm0, [r15]
    movsd xmm1, [r15 + 8]
    # Check if 3 arguments passed: [r15 - 16] is length
    mov r8, [r15 - 16]
    cmp r8, 3
    jl .gemm_have_ab
    movsd xmm2, [r15 + 16]
    cvttsd2si r12, xmm2
    mov [rbp - 160], r12           # user dest handle
    jmp .gemm_have_ab
.gemm_from_regs:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
    inc rdx
    movsd xmm1, [r13 + rdx * 8]
.gemm_have_ab:
    movsd [rbp - 152], xmm1
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .gemm_fail
    mov rsi, rax            # rsi = handle A

    movsd xmm1, [rbp - 152]
    cvttsd2si rcx, xmm1
    call asm_gpu_lookup_handle
    test rax, rax
    jz .gemm_fail
    mov rbx, rax            # rbx = handle B

    # M = A.dim0, K = A.dim1
    mov r10d, [rsi + 40]    # M
    mov r11d, [rsi + 44]    # K
    # K2 = B.dim0, N = B.dim1
    mov r14d, [rbx + 40]    # K2
    mov r15d, [rbx + 44]    # N
    cmp r11d, r14d
    jne .gemm_fail

    mov [rbp - 56], r10d    # M
    mov [rbp - 60], r15d    # N
    mov [rbp - 64], r11d    # K

    # Output size = M * N * 4
    mov eax, r10d
    imul eax, r15d
    mov [rbp - 68], eax     # total_out
    shl eax, 2
    mov [rbp - 76], eax     # bytes_out

    # Check if GPU execution
    mov edx, [rsi + 32]
    and edx, [rbx + 32]
    and edx, [rip + gpu_has_cuda]
    cmp edx, 1
    jne .gemm_host

    # Check if user provided destination handle C
    mov rcx, [rbp - 160]
    test rcx, rcx
    jz .gemm_alloc_c
    call asm_gpu_lookup_handle
    test rax, rax
    jz .gemm_alloc_c
    # Reuse provided destination handle C
    mov rdi, [rax + 16]
    mov [rbp - 88], rdi
    jmp .gemm_setup_kargs

.gemm_alloc_c:
    # Allocate GPU memory for C using VRAM Slab Allocator
    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov edx, [rbp - 76]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .gemm_host
    mov rdi, [rbp - 48]     # d_C
    mov [rbp - 88], rdi
    mov qword ptr [rbp - 160], 0

.gemm_setup_kargs:
    # Setup kernel args: [&d_A, &d_B, &d_C, &M, &N, &K]
    lea rax, [rsi + 16]
    mov [rbp - 144], rax    # &d_A
    lea rax, [rbx + 16]
    mov [rbp - 136], rax    # &d_B
    lea rax, [rbp - 88]
    mov [rbp - 128], rax    # &d_C
    lea rax, [rbp - 56]
    mov [rbp - 120], rax    # &M
    lea rax, [rbp - 60]
    mov [rbp - 112], rax    # &N
    lea rax, [rbp - 64]
    mov [rbp - 104], rax    # &K

    # grid_x = (N + 15) / 16, grid_y = (M + 15) / 16
    mov eax, [rbp - 60]     # N
    add eax, 15
    shr eax, 4
    test eax, eax
    jnz 1f
    mov eax, 1
1:
    mov edx, eax            # grid_x

    mov eax, [rbp - 56]     # M
    add eax, 15
    shr eax, 4
    test eax, eax
    jnz 2f
    mov eax, 1
2:
    mov r8d, eax            # grid_y

    mov rcx, [rip + gpu_fn_tiled_gemm]
    mov r9d, 1              # grid_z
    mov dword ptr [rsp + 32], 16  # block_x
    mov dword ptr [rsp + 40], 16  # block_y
    mov dword ptr [rsp + 48], 1   # block_z
    mov dword ptr [rsp + 56], 0   # smem
    mov qword ptr [rsp + 64], 0   # stream
    lea rax, [rbp - 144]
    mov [rsp + 72], rax           # kernelParams
    mov qword ptr [rsp + 80], 0   # extra
    call [rip + gpu_p_cuLaunchKernel]

    # Check if we need to register handle
    cmp qword ptr [rbp - 160], 0
    jne .gemm_skip_reg
    # Register output tensor handle
    mov rcx, 2              # type = tensor
    mov rdx, [rbp - 88]     # d_ptr
    mov r8d, [rbp - 76]     # bytes
    mov r9, 1               # is_device = 1
    mov r10d, [rbp - 56]
    mov [rsp + 32], r10d
    mov r11d, [rbp - 60]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov [rbp - 160], rax
.gemm_skip_reg:
    mov rdx, [rbp - 8]
    mov rax, [rbp - 160]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.gemm_host:
    # CPU Fallback with AVX2/FMA
    mov ecx, [rbp - 76]
    call malloc
    mov [rbp - 88], rax     # host C ptr

    # Simple CPU GEMM:
    mov r8, [rsi + 16]      # ptr A
    mov r9, [rbx + 16]      # ptr B
    mov rdi, [rbp - 88]     # ptr C

    mov r10d, [rbp - 56]    # M
    mov r11d, [rbp - 60]    # N
    mov r12d, [rbp - 64]    # K

    xor ecx, ecx            # i = 0
.gemm_i:
    cmp ecx, r10d
    jge .gemm_cpu_dn
    xor edx, edx            # j = 0
.gemm_j:
    cmp edx, r11d
    jge .gemm_i_nxt
    xorps xmm0, xmm0        # sum = 0.0
    xor eax, eax            # k = 0
.gemm_k:
    cmp eax, r12d
    jge .gemm_k_dn
    # a_idx = i * K + k
    mov r14d, ecx
    imul r14d, r12d
    add r14d, eax
    movss xmm1, [r8 + r14 * 4]
    # b_idx = k * N + j
    mov r15d, eax
    imul r15d, r11d
    add r15d, edx
    movss xmm2, [r9 + r15 * 4]
    mulss xmm1, xmm2
    addss xmm0, xmm1
    inc eax
    jmp .gemm_k
.gemm_k_dn:
    # c_idx = i * N + j
    mov r14d, ecx
    imul r14d, r11d
    add r14d, edx
    movss [rdi + r14 * 4], xmm0
    inc edx
    jmp .gemm_j
.gemm_i_nxt:
    inc ecx
    jmp .gemm_i

.gemm_cpu_dn:
    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8d, [rbp - 76]
    xor r9, r9             # is_device = 0
    mov r10d, [rbp - 56]
    mov [rsp + 32], r10d
    mov r11d, [rbp - 60]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.gemm_fail:
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_18:
    # --------------------------------------------------------------------------
    # OP 18: GPU_TRANSPOSE (args[0] = Tensor)
    # --------------------------------------------------------------------------
    cmp r14, 18
    jne .check_op_19
    test r15, r15
    jz .tr_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .tr_from_scalar
    movsd xmm0, [r15]
    jmp .tr_do_lookup
.tr_from_scalar:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
.tr_do_lookup:
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .tr_fail
    mov rsi, rax            # rsi = src handle

    mov r10d, [rsi + 40]    # old_dim0 (rows)
    mov r11d, [rsi + 44]    # old_dim1 (cols)
    mov [rbp - 56], r11d    # new_dim0 = cols
    mov [rbp - 60], r10d    # new_dim1 = rows

    mov r8, [rsi + 24]      # bytes
    mov [rbp - 76], r8

    # Allocate output
    mov edx, [rsi + 32]
    and edx, [rip + gpu_has_cuda]
    cmp edx, 1
    jne .tr_host

    # GPU execution
    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov rdx, [rbp - 76]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .tr_host
    mov rdi, [rbp - 48]
    mov [rbp - 88], rdi     # d_out

    # Setup kernel args: [&d_in, &d_out, &rows, &cols]
    mov edx, [rsi + 40]
    mov [rbp - 96], edx     # rows
    mov edx, [rsi + 44]
    mov [rbp - 100], edx    # cols

    lea rax, [rsi + 16]
    mov [rbp - 128], rax    # &d_in
    lea rax, [rbp - 88]
    mov [rbp - 120], rax    # &d_out
    lea rax, [rbp - 96]
    mov [rbp - 112], rax    # &rows
    lea rax, [rbp - 100]
    mov [rbp - 104], rax    # &cols

    # grid = ((cols + 15)/16, (rows + 15)/16, 1)
    mov eax, [rbp - 100]    # cols
    add eax, 15
    shr eax, 4
    test eax, eax
    jnz 1f
    mov eax, 1
1:
    mov edx, eax            # grid_x

    mov eax, [rbp - 96]     # rows
    add eax, 15
    shr eax, 4
    test eax, eax
    jnz 2f
    mov eax, 1
2:
    mov r8d, eax            # grid_y

    mov rcx, [rip + gpu_fn_transpose]
    mov r9d, 1              # grid_z
    mov dword ptr [rsp + 32], 16 # block_x
    mov dword ptr [rsp + 40], 16 # block_y
    mov dword ptr [rsp + 48], 1  # block_z
    mov dword ptr [rsp + 56], 0  # smem
    mov qword ptr [rsp + 64], 0  # stream
    lea rax, [rbp - 128]
    mov [rsp + 72], rax          # kernelParams
    mov qword ptr [rsp + 80], 0  # extra
    call [rip + gpu_p_cuLaunchKernel]

    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8,  [rbp - 76]
    mov r9,  1
    mov r10d, [rbp - 56]
    mov [rsp + 32], r10d
    mov r11d, [rbp - 60]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.tr_host:
    mov rcx, [rbp - 76]
    call malloc
    mov [rbp - 88], rax
    mov r8, [rsi + 16]      # in ptr
    mov rdi, [rbp - 88]     # out ptr
    mov r10d, [rsi + 40]    # rows
    mov r11d, [rsi + 44]    # cols

    xor ecx, ecx            # r = 0
.tr_r_lp:
    cmp ecx, r10d
    jge .tr_h_dn
    xor edx, edx            # c = 0
.tr_c_lp:
    cmp edx, r11d
    jge .tr_r_nxt
    # in_idx = r * cols + c
    mov eax, ecx
    imul eax, r11d
    add eax, edx
    movss xmm0, [r8 + rax * 4]
    # out_idx = c * rows + r
    mov eax, edx
    imul eax, r10d
    add eax, ecx
    movss [rdi + rax * 4], xmm0
    inc edx
    jmp .tr_c_lp
.tr_r_nxt:
    inc ecx
    jmp .tr_r_lp

.tr_h_dn:
    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8,  [rbp - 76]
    xor r9,  r9
    mov r10d, [rbp - 56]
    mov [rsp + 32], r10d
    mov r11d, [rbp - 60]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.tr_fail:
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_19:
    # --------------------------------------------------------------------------
    # OP 19..22: VECTOR ARITHMETIC (ADD, SUB, MUL, DIV)
    # --------------------------------------------------------------------------
    cmp r14, 19
    jb .check_op_23
    cmp r14, 22
    ja .check_op_23

    test r15, r15
    jz .vec_fail
    mov qword ptr [rbp - 160], 0   # 0 = allocate new handle
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .vec_from_regs
    movsd xmm0, [r15]
    movsd xmm1, [r15 + 8]
    # Check if 3 arguments passed: [r15 - 16] is array length
    mov r8, [r15 - 16]
    cmp r8, 3
    jl .vec_have_ab
    movsd xmm2, [r15 + 16]
    cvttsd2si r12, xmm2
    mov [rbp - 160], r12           # user dest handle
    jmp .vec_have_ab
.vec_from_regs:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
    inc rdx
    movsd xmm1, [r13 + rdx * 8]
.vec_have_ab:
    movsd [rbp - 152], xmm1
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .vec_fail
    mov rsi, rax

    movsd xmm1, [rbp - 152]
    cvttsd2si rcx, xmm1
    call asm_gpu_lookup_handle
    test rax, rax
    jz .vec_fail
    mov rbx, rax

    mov r8, [rsi + 24]      # bytes
    mov [rbp - 76], r8
    mov r10, r8
    shr r10, 2              # total elements
    mov [rbp - 68], r10

    # Output allocation
    mov edx, [rsi + 32]
    and edx, [rbx + 32]
    and edx, [rip + gpu_has_cuda]
    cmp edx, 1
    jne .vec_host

    # Check if user provided destination handle
    mov rcx, [rbp - 160]
    test rcx, rcx
    jz .vec_alloc_c
    call asm_gpu_lookup_handle
    test rax, rax
    jz .vec_alloc_c
    # Reuse provided destination handle
    mov rdi, [rax + 16]
    mov [rbp - 88], rdi
    jmp .vec_setup_kargs

.vec_alloc_c:
    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov rdx, [rbp - 76]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .vec_host
    mov rdi, [rbp - 48]
    mov [rbp - 88], rdi
    mov qword ptr [rbp - 160], 0

.vec_setup_kargs:
    # Select kernel function pointer
    lea rax, [rip + gpu_fn_vec_add]
    cmp r14, 19
    je 1f
    lea rax, [rip + gpu_fn_vec_sub]
    cmp r14, 20
    je 1f
    lea rax, [rip + gpu_fn_vec_mul]
    cmp r14, 21
    je 1f
    lea rax, [rip + gpu_fn_vec_div]
1:
    mov r11, [rax]

    # Setup kernel arguments: [&d_A, &d_B, &d_C, &N]
    mov edx, [rbp - 68]
    mov [rbp - 96], edx

    lea rax, [rsi + 16]
    mov [rbp - 128], rax
    lea rax, [rbx + 16]
    mov [rbp - 120], rax
    lea rax, [rbp - 88]
    mov [rbp - 112], rax
    lea rax, [rbp - 96]
    mov [rbp - 104], rax

    # grid = (N + 1023) / 1024 for 128-bit float4 vectorization
    mov eax, [rbp - 68]
    add eax, 1023
    shr eax, 10
    test eax, eax
    jnz 2f
    mov eax, 1
2:
    mov rcx, r11            # kernel func
    mov edx, eax            # grid_x
    mov r8d, 1
    mov r9d, 1
    mov dword ptr [rsp + 32], 256
    mov dword ptr [rsp + 40], 1
    mov dword ptr [rsp + 48], 1
    mov dword ptr [rsp + 56], 0
    mov qword ptr [rsp + 64], 0
    lea rax, [rbp - 128]
    mov [rsp + 72], rax
    mov qword ptr [rsp + 80], 0
    call [rip + gpu_p_cuLaunchKernel]

    # Check if we need to register handle
    cmp qword ptr [rbp - 160], 0
    jne .vec_skip_reg
    # Register tensor
    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8,  [rbp - 76]
    mov r9,  1
    mov r10d, [rsi + 40]
    mov [rsp + 32], r10d
    mov r11d, [rsi + 44]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov [rbp - 160], rax
.vec_skip_reg:
    mov rdx, [rbp - 8]
    mov rax, [rbp - 160]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.vec_host:
    mov rcx, [rbp - 76]
    call malloc
    mov [rbp - 88], rax

    mov r8, [rsi + 16]
    mov r9, [rbx + 16]
    mov rdi, [rbp - 88]
    mov rcx, [rbp - 68]

    # AVX2 Vector Loop
    xor edx, edx
.vec_host_lp:
    cmp rdx, rcx
    jae .vec_host_dn
    movss xmm0, [r8 + rdx * 4]
    movss xmm1, [r9 + rdx * 4]
    cmp r14, 19
    jne 1f
    addss xmm0, xmm1
    jmp 4f
1:
    cmp r14, 20
    jne 2f
    subss xmm0, xmm1
    jmp 4f
2:
    cmp r14, 21
    jne 3f
    mulss xmm0, xmm1
    jmp 4f
3:
    divss xmm0, xmm1
4:
    movss [rdi + rdx * 4], xmm0
    inc rdx
    jmp .vec_host_lp

.vec_host_dn:
    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8,  [rbp - 76]
    xor r9,  r9
    mov r10d, [rsi + 40]
    mov [rsp + 32], r10d
    mov r11d, [rsi + 44]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.vec_fail:
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_23:
    # --------------------------------------------------------------------------
    # OP 23: GPU_SCALE (args[0] = Tensor, args[1] = scalar)
    # --------------------------------------------------------------------------
    cmp r14, 23
    jne .check_op_act
    test r15, r15
    jz .scale_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .scale_from_regs
    movsd xmm0, [r15]       # handle
    movsd xmm1, [r15 + 8]   # scalar
    jmp .scale_have_args
.scale_from_regs:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
    inc rdx
    movsd xmm1, [r13 + rdx * 8]
.scale_have_args:
    cvtsd2ss xmm2, xmm1
    movss [rbp - 92], xmm2  # s float
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .scale_fail
    mov rsi, rax

    mov r8, [rsi + 24]
    mov [rbp - 76], r8
    mov r10, r8
    shr r10, 2
    mov [rbp - 68], r10     # total

    mov edx, [rsi + 32]
    and edx, [rip + gpu_has_cuda]
    cmp edx, 1
    jne .scale_host

    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov rdx, [rbp - 76]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .scale_host
    mov rdi, [rbp - 48]
    mov [rbp - 88], rdi

    mov edx, [rbp - 68]
    mov [rbp - 96], edx

    lea rax, [rsi + 16]
    mov [rbp - 128], rax
    lea rax, [rbp - 92]
    mov [rbp - 120], rax
    lea rax, [rbp - 88]
    mov [rbp - 112], rax
    lea rax, [rbp - 96]
    mov [rbp - 104], rax

    # grid = (N + 1023) / 1024 for float4 vectorization
    mov eax, [rbp - 68]
    add eax, 1023
    shr eax, 10
    test eax, eax
    jnz 1f
    mov eax, 1
1:
    mov rcx, [rip + gpu_fn_vec_scale]
    mov edx, eax
    mov r8d, 1
    mov r9d, 1
    mov dword ptr [rsp + 32], 256
    mov dword ptr [rsp + 40], 1
    mov dword ptr [rsp + 48], 1
    mov dword ptr [rsp + 56], 0
    mov qword ptr [rsp + 64], 0
    lea rax, [rbp - 128]
    mov [rsp + 72], rax
    mov qword ptr [rsp + 80], 0
    call [rip + gpu_p_cuLaunchKernel]

    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8,  [rbp - 76]
    mov r9,  1
    mov r10d, [rsi + 40]
    mov [rsp + 32], r10d
    mov r11d, [rsi + 44]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.scale_host:
    mov rcx, [rbp - 76]
    call malloc
    mov [rbp - 88], rax
    mov r8, [rsi + 16]
    mov rdi, [rbp - 88]
    mov rcx, [rbp - 68]
    movss xmm1, [rbp - 92]
    xor edx, edx
.scale_h_lp:
    cmp rdx, rcx
    jae .scale_h_dn
    movss xmm0, [r8 + rdx * 4]
    mulss xmm0, xmm1
    movss [rdi + rdx * 4], xmm0
    inc rdx
    jmp .scale_h_lp
.scale_h_dn:
    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8,  [rbp - 76]
    xor r9,  r9
    mov r10d, [rsi + 40]
    mov [rsp + 32], r10d
    mov r11d, [rsi + 44]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.scale_fail:
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_act:
    # --------------------------------------------------------------------------
    # OP 24: RELU, OP 25: SIGMOID, OP 40: GELU, OP 41: SILU
    # --------------------------------------------------------------------------
    cmp r14, 24
    je .do_activation
    cmp r14, 25
    je .do_activation
    cmp r14, 40
    je .do_activation
    cmp r14, 41
    je .do_activation
    jmp .check_op_26

.do_activation:
    test r15, r15
    jz .act_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .act_from_scalar
    movsd xmm0, [r15]
    jmp .act_do_lookup
.act_from_scalar:
    mov rdx, [rbp - 24]     # args_reg
    movsd xmm0, [r13 + rdx * 8]
.act_do_lookup:
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .act_fail
    mov rsi, rax

    mov r8, [rsi + 24]
    mov [rbp - 76], r8
    mov r10, r8
    shr r10, 2
    mov [rbp - 68], r10

    mov edx, [rsi + 32]
    and edx, [rip + gpu_has_cuda]
    cmp edx, 1
    jne .act_host

    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov rdx, [rbp - 76]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .act_host
    mov rdi, [rbp - 48]
    mov [rbp - 88], rdi

    mov edx, [rbp - 68]
    mov [rbp - 96], edx

    lea rax, [rsi + 16]
    mov [rbp - 120], rax
    lea rax, [rbp - 88]
    mov [rbp - 112], rax
    lea rax, [rbp - 96]
    mov [rbp - 104], rax

    # Select kernel function pointer based on r14
    lea rax, [rip + gpu_fn_relu]
    cmp r14, 24
    je 1f
    lea rax, [rip + gpu_fn_sigmoid]
    cmp r14, 25
    je 1f
    lea rax, [rip + gpu_fn_gelu]
    cmp r14, 40
    je 1f
    lea rax, [rip + gpu_fn_silu]
1:
    mov r11, [rax]

    mov eax, [rbp - 68]
    cmp r14, 24
    jne 11f
    add eax, 1023
    shr eax, 10
    jmp 12f
11:
    add eax, 255
    shr eax, 8
12:
    test eax, eax
    jnz 2f
    mov eax, 1
2:
    mov rcx, r11
    mov edx, eax
    mov r8d, 1
    mov r9d, 1
    mov dword ptr [rsp + 32], 256
    mov dword ptr [rsp + 40], 1
    mov dword ptr [rsp + 48], 1
    mov dword ptr [rsp + 56], 0
    mov qword ptr [rsp + 64], 0
    lea rax, [rbp - 120]
    mov [rsp + 72], rax
    mov qword ptr [rsp + 80], 0
    call [rip + gpu_p_cuLaunchKernel]

    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8,  [rbp - 76]
    mov r9,  1
    mov r10d, [rsi + 40]
    mov [rsp + 32], r10d
    mov r11d, [rsi + 44]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.act_host:
    mov rcx, [rbp - 76]
    call malloc
    mov [rbp - 88], rax
    mov r8, [rsi + 16]
    mov rdi, [rbp - 88]
    mov rcx, [rbp - 68]
    xor edx, edx
    xorps xmm2, xmm2
.act_h_lp:
    cmp rdx, rcx
    jae .act_h_dn
    movss xmm0, [r8 + rdx * 4]
    cmp r14, 24
    jne 3f
    maxss xmm0, xmm2
    jmp 6f
3:
    # Sigmoid/GELU/SiLU approximation
    movss [rdi + rdx * 4], xmm0
    inc rdx
    jmp .act_h_lp
6:
    movss [rdi + rdx * 4], xmm0
    inc rdx
    jmp .act_h_lp

.act_h_dn:
    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8,  [rbp - 76]
    xor r9,  r9
    mov r10d, [rsi + 40]
    mov [rsp + 32], r10d
    mov r11d, [rsi + 44]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.act_fail:
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_26:
    # --------------------------------------------------------------------------
    # OP 26: GPU_CONV2D (args = [in, kernel, stride, pad])
    # --------------------------------------------------------------------------
    cmp r14, 26
    jne .check_op_27
    test r15, r15
    jz .conv_fail

    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .conv_fail
    mov rsi, rax            # rsi = in handle

    movsd xmm0, [r15 + 8]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .conv_fail
    mov rbx, rax            # rbx = kernel handle

    mov r10d, [rsi + 40]    # H
    mov r11d, [rsi + 44]    # W
    mov [rbp - 56], r10d    # H
    mov [rbp - 60], r11d    # W

    mov eax, [rbx + 40]     # kH
    mov ecx, [rbx + 44]     # kW
    mov [rbp - 64], eax     # kH
    mov [rbp - 68], ecx     # kW

    mov dword ptr [rbp - 72], 1 # stride default = 1
    movsd xmm0, [r15 - 16]
    cvttsd2si rcx, xmm0
    cmp rcx, 2
    jle 1f
    movsd xmm1, [r15 + 16]
    cvttsd2si eax, xmm1
    test eax, eax
    jle 1f
    mov [rbp - 72], eax
1:
    mov dword ptr [rbp - 76], 0 # pad default = 0
    cmp rcx, 3
    jle 2f
    movsd xmm1, [r15 + 24]
    cvttsd2si eax, xmm1
    mov [rbp - 76], eax
2:
    # outH = (H + 2*pad - kH) / stride + 1
    mov eax, [rbp - 56]
    mov ecx, [rbp - 76]
    shl ecx, 1
    add eax, ecx
    sub eax, [rbp - 64]
    cdq
    idiv dword ptr [rbp - 72]
    inc eax
    test eax, eax
    jg 3f
    mov eax, 1
3:
    mov [rbp - 80], eax     # outH

    # outW = (W + 2*pad - kW) / stride + 1
    mov eax, [rbp - 60]
    mov ecx, [rbp - 76]
    shl ecx, 1
    add eax, ecx
    sub eax, [rbp - 68]
    cdq
    idiv dword ptr [rbp - 72]
    inc eax
    test eax, eax
    jg 4f
    mov eax, 1
4:
    mov [rbp - 84], eax     # outW

    mov eax, [rbp - 80]
    imul eax, [rbp - 84]
    mov [rbp - 96], eax
    shl eax, 2
    mov [rbp - 100], eax    # bytes out

    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov edx, [rbp - 100]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .conv_fail
    mov rdi, [rbp - 48]
    mov [rbp - 88], rdi

    # Setup kargs contiguously at [rbp - 256]
    lea rax, [rsi + 16]
    mov [rbp - 256], rax
    lea rax, [rbx + 16]
    mov [rbp - 248], rax
    lea rax, [rbp - 88]
    mov [rbp - 240], rax
    lea rax, [rbp - 56]
    mov [rbp - 232], rax
    lea rax, [rbp - 60]
    mov [rbp - 224], rax
    lea rax, [rbp - 64]
    mov [rbp - 216], rax
    lea rax, [rbp - 68]
    mov [rbp - 208], rax
    lea rax, [rbp - 80]
    mov [rbp - 200], rax
    lea rax, [rbp - 84]
    mov [rbp - 192], rax
    lea rax, [rbp - 72]
    mov [rbp - 184], rax
    lea rax, [rbp - 76]
    mov [rbp - 176], rax

    mov eax, [rbp - 84]
    add eax, 15
    shr eax, 4
    test eax, eax
    jnz 5f
    mov eax, 1
5:
    mov edx, eax
    mov eax, [rbp - 80]
    add eax, 15
    shr eax, 4
    test eax, eax
    jnz 6f
    mov eax, 1
6:
    mov r8d, eax
    mov rcx, [rip + gpu_fn_conv2d]
    mov r9d, 1
    mov dword ptr [rsp + 32], 16
    mov dword ptr [rsp + 40], 16
    mov dword ptr [rsp + 48], 1
    mov dword ptr [rsp + 56], 0
    mov qword ptr [rsp + 64], 0
    lea rax, [rbp - 256]
    mov [rsp + 72], rax
    mov qword ptr [rsp + 80], 0
    call [rip + gpu_p_cuLaunchKernel]

    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8d, [rbp - 100]
    mov r9,  1
    mov r10d, [rbp - 80]
    mov [rsp + 32], r10d
    mov r11d, [rbp - 84]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.conv_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_27:
    # --------------------------------------------------------------------------
    # OP 27: GPU_MAXPOOL2D (args = [in, pool_size, stride])
    # --------------------------------------------------------------------------
    cmp r14, 27
    jne .check_op_28
    test r15, r15
    jz .pool_fail

    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .pool_fail
    mov rsi, rax

    mov r10d, [rsi + 40]
    mov r11d, [rsi + 44]
    mov [rbp - 56], r10d
    mov [rbp - 60], r11d

    mov dword ptr [rbp - 64], 2 # default pool_size = 2
    movsd xmm0, [r15 - 16]
    cvttsd2si rcx, xmm0
    cmp rcx, 1
    jle 1f
    movsd xmm1, [r15 + 8]
    cvttsd2si eax, xmm1
    test eax, eax
    jle 1f
    mov [rbp - 64], eax
1:
    mov eax, [rbp - 64]
    mov [rbp - 68], eax         # default stride = pool_size
    cmp rcx, 2
    jle 2f
    movsd xmm1, [r15 + 16]
    cvttsd2si eax, xmm1
    test eax, eax
    jle 2f
    mov [rbp - 68], eax
2:
    # outH = (H - pool_size) / stride + 1
    mov eax, [rbp - 56]
    sub eax, [rbp - 64]
    cdq
    idiv dword ptr [rbp - 68]
    inc eax
    test eax, eax
    jg 3f
    mov eax, 1
3:
    mov [rbp - 80], eax

    # outW = (W - pool_size) / stride + 1
    mov eax, [rbp - 60]
    sub eax, [rbp - 64]
    cdq
    idiv dword ptr [rbp - 68]
    inc eax
    test eax, eax
    jg 4f
    mov eax, 1
4:
    mov [rbp - 84], eax

    mov eax, [rbp - 80]
    imul eax, [rbp - 84]
    mov [rbp - 96], eax
    shl eax, 2
    mov [rbp - 100], eax

    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov edx, [rbp - 100]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .pool_fail
    mov rdi, [rbp - 48]
    mov [rbp - 88], rdi

    # Setup kargs contiguously at [rbp - 256]
    lea rax, [rsi + 16]
    mov [rbp - 256], rax
    lea rax, [rbp - 88]
    mov [rbp - 248], rax
    lea rax, [rbp - 56]
    mov [rbp - 240], rax
    lea rax, [rbp - 60]
    mov [rbp - 232], rax
    lea rax, [rbp - 64]
    mov [rbp - 224], rax
    lea rax, [rbp - 68]
    mov [rbp - 216], rax
    lea rax, [rbp - 80]
    mov [rbp - 208], rax
    lea rax, [rbp - 84]
    mov [rbp - 200], rax

    mov eax, [rbp - 84]
    add eax, 15
    shr eax, 4
    test eax, eax
    jnz 5f
    mov eax, 1
5:
    mov edx, eax
    mov eax, [rbp - 80]
    add eax, 15
    shr eax, 4
    test eax, eax
    jnz 6f
    mov eax, 1
6:
    mov r8d, eax
    mov rcx, [rip + gpu_fn_maxpool2d]
    mov r9d, 1
    mov dword ptr [rsp + 32], 16
    mov dword ptr [rsp + 40], 16
    mov dword ptr [rsp + 48], 1
    mov dword ptr [rsp + 56], 0
    mov qword ptr [rsp + 64], 0
    lea rax, [rbp - 256]
    mov [rsp + 72], rax
    mov qword ptr [rsp + 80], 0
    call [rip + gpu_p_cuLaunchKernel]

    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8d, [rbp - 100]
    mov r9,  1
    mov r10d, [rbp - 80]
    mov [rsp + 32], r10d
    mov r11d, [rbp - 84]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.pool_fail:
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_28:
    # --------------------------------------------------------------------------
    # OP 28: GPU_RGB_TO_GRAY (args = [in])
    # --------------------------------------------------------------------------
    cmp r14, 28
    jne .check_op_30
    test r15, r15
    jz .rgb_fail

    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .rgb_from_scalar
    movsd xmm0, [r15]
    jmp .rgb_do_lookup
.rgb_from_scalar:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
.rgb_do_lookup:
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .rgb_fail
    mov rsi, rax

    mov rax, [rsi + 24]
    shr rax, 2
    xor edx, edx
    mov rcx, 3
    div rcx
    test eax, eax
    jle .rgb_fail
    mov [rbp - 96], eax
    shl eax, 2
    mov [rbp - 100], eax

    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov edx, [rbp - 100]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .rgb_fail
    mov rdi, [rbp - 48]
    mov [rbp - 88], rdi

    lea rax, [rsi + 16]
    mov [rbp - 128], rax
    lea rax, [rbp - 88]
    mov [rbp - 120], rax
    lea rax, [rbp - 96]
    mov [rbp - 112], rax

    mov eax, [rbp - 96]
    add eax, 255
    shr eax, 8
    test eax, eax
    jnz 1f
    mov eax, 1
1:
    mov rcx, [rip + gpu_fn_rgb_to_gray]
    mov edx, eax
    mov r8d, 1
    mov r9d, 1
    mov dword ptr [rsp + 32], 256
    mov dword ptr [rsp + 40], 1
    mov dword ptr [rsp + 48], 1
    mov dword ptr [rsp + 56], 0
    mov qword ptr [rsp + 64], 0
    lea rax, [rbp - 128]
    mov [rsp + 72], rax
    mov qword ptr [rsp + 80], 0
    call [rip + gpu_p_cuLaunchKernel]

    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8d, [rbp - 100]
    mov r9,  1
    mov dword ptr [rsp + 32], 1
    mov r11d, [rbp - 96]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.rgb_fail:
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_30:
    # --------------------------------------------------------------------------
    # OP 30: GPU_TIME_MS (High-precision timing in milliseconds)
    # --------------------------------------------------------------------------
    cmp r14, 30
    jne .check_op_31

    lea rcx, [rbp - 48]     # freq
    call QueryPerformanceFrequency
    lea rcx, [rbp - 40]     # counter
    call QueryPerformanceCounter

    cvtsi2sd xmm0, qword ptr [rbp - 40]
    mov rax, 1000
    cvtsi2sd xmm1, rax
    mulsd xmm0, xmm1
    cvtsi2sd xmm2, qword ptr [rbp - 48]
    divsd xmm0, xmm2
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_31:
    # --------------------------------------------------------------------------
    # OP 31: GPU_STREAM_CREATE () -> stream_handle_id
    # --------------------------------------------------------------------------
    cmp r14, 31
    jne .check_op_32
    lea rdi, [rbp - 48]     # &hStream
    mov rcx, rdi
    xor edx, edx            # flags = 0
    cmp dword ptr [rip + gpu_has_cuda], 1
    jne .stream_host
    call [rip + gpu_p_cuStreamCreate]
    test eax, eax
    jnz .stream_fail
    mov rdx, [rdi]          # stream ptr
    mov r9d, 1              # is_device = 1
    jmp .stream_reg
.stream_host:
    mov rdx, 1              # dummy stream 1
    xor r9d, r9d
.stream_reg:
    mov rcx, 3              # type = 3 (stream)
    xor r8d, r8d            # size = 0
    mov qword ptr [rsp + 32], 0
    mov qword ptr [rsp + 40], 0
    call asm_gpu_register_handle
    cvtsi2sd xmm0, rax
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done
.stream_fail:
    xorpd xmm0, xmm0
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_32:
    # --------------------------------------------------------------------------
    # OP 32: GPU_STREAM_SYNC (args[0] = stream_handle)
    # --------------------------------------------------------------------------
    cmp r14, 32
    jne .check_op_33
    test r15, r15
    jz .stream_sync_all
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .stream_sync_from_scalar
    movsd xmm0, [r15]
    jmp .stream_sync_do
.stream_sync_from_scalar:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
.stream_sync_do:
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .stream_sync_all
    mov rbx, rax
    cmp dword ptr [rbx + 32], 1
    jne .stream_sync_all
    mov rcx, [rbx + 16]     # hStream
    call [rip + gpu_p_cuStreamSynchronize]
    jmp .stream_sync_ok
.stream_sync_all:
    call [rip + gpu_p_cuCtxSynchronize]
.stream_sync_ok:
    mov rax, 1
    cvtsi2sd xmm0, rax
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_33:
    # --------------------------------------------------------------------------
    # OP 33: GPU_STREAM_DESTROY (args[0] = stream_handle)
    # --------------------------------------------------------------------------
    cmp r14, 33
    jne .check_op_34
    test r15, r15
    jz .stream_dest_done
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .stream_dest_from_scalar
    movsd xmm0, [r15]
    jmp .stream_dest_do
.stream_dest_from_scalar:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
.stream_dest_do:
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .stream_dest_done
    mov rbx, rax
    cmp dword ptr [rbx + 32], 1
    jne .stream_dest_clear
    mov rcx, [rbx + 16]     # hStream
    call [rip + gpu_p_cuStreamDestroy]
.stream_dest_clear:
    mov qword ptr [rbx], 0
.stream_dest_done:
    mov rax, 1
    cvtsi2sd xmm0, rax
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_34:
    # --------------------------------------------------------------------------
    # OP 34: GPU_EVENT_CREATE () -> event_handle_id
    # --------------------------------------------------------------------------
    cmp r14, 34
    jne .check_op_35
    lea rdi, [rbp - 48]     # &hEvent
    mov rcx, rdi
    xor edx, edx            # flags = 0
    cmp dword ptr [rip + gpu_has_cuda], 1
    jne .event_host
    call [rip + gpu_p_cuEventCreate]
    test eax, eax
    jnz .event_fail
    mov rdx, [rdi]          # event ptr
    mov r9d, 1
    jmp .event_reg
.event_host:
    lea rcx, [rbp - 48]
    call QueryPerformanceCounter
    mov rdx, [rbp - 48]
    xor r9d, r9d
.event_reg:
    mov rcx, 4              # type = 4 (event)
    xor r8d, r8d            # size = 0
    mov qword ptr [rsp + 32], 0
    mov qword ptr [rsp + 40], 0
    call asm_gpu_register_handle
    cvtsi2sd xmm0, rax
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done
.event_fail:
    xorpd xmm0, xmm0
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_35:
    # --------------------------------------------------------------------------
    # OP 35: GPU_EVENT_RECORD (args[0] = event_handle, args[1] = stream_handle)
    # --------------------------------------------------------------------------
    cmp r14, 35
    jne .check_op_36
    test r15, r15
    jz .event_rec_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .event_rec_from_scalar
    movsd xmm0, [r15]       # event_id
    movsd xmm1, [r15 + 8]   # stream_id (optional)
    jmp .event_rec_lookup
.event_rec_from_scalar:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
    xorpd xmm1, xmm1
.event_rec_lookup:
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .event_rec_fail
    mov rsi, rax            # event entry
    xor edx, edx
    cvttsd2si rcx, xmm1
    test rcx, rcx
    jz 1f
    call asm_gpu_lookup_handle
    test rax, rax
    jz 1f
    mov rdx, [rax + 16]     # hStream
1:
    cmp dword ptr [rsi + 32], 1
    jne .event_rec_host
    mov rcx, [rsi + 16]     # hEvent
    call [rip + gpu_p_cuEventRecord]
    jmp .event_rec_ok
.event_rec_host:
    lea rcx, [rsi + 16]
    call QueryPerformanceCounter
.event_rec_ok:
    mov rax, 1
    cvtsi2sd xmm0, rax
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done
.event_rec_fail:
    xorpd xmm0, xmm0
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_36:
    # --------------------------------------------------------------------------
    # OP 36: GPU_EVENT_ELAPSED (args[0] = start_event, args[1] = end_event) -> ms
    # --------------------------------------------------------------------------
    cmp r14, 36
    jne .check_op_37
    test r15, r15
    jz .event_el_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .event_el_from_scalar
    movsd xmm0, [r15]       # start_event
    movsd xmm1, [r15 + 8]   # end_event
    jmp .event_el_lookup
.event_el_from_scalar:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
    inc rdx
    movsd xmm1, [r13 + rdx * 8]
.event_el_lookup:
    movsd [rbp - 152], xmm1
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .event_el_fail
    mov rsi, rax            # start entry

    movsd xmm1, [rbp - 152]
    cvttsd2si rcx, xmm1
    call asm_gpu_lookup_handle
    test rax, rax
    jz .event_el_fail
    mov rbx, rax            # end entry

    mov eax, [rsi + 32]
    and eax, [rbx + 32]
    and eax, [rip + gpu_has_cuda]
    cmp eax, 1
    jne .event_el_host

    lea rdi, [rbp - 48]     # &float_ms
    mov rcx, rdi
    mov rdx, [rsi + 16]     # hStart
    mov r8,  [rbx + 16]     # hEnd
    call [rip + gpu_p_cuEventElapsedTime]
    test eax, eax
    jnz .event_el_fail
    cvtss2sd xmm0, [rbp - 48]
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.event_el_host:
    mov rax, [rbx + 16]
    sub rax, [rsi + 16]
    cvtsi2sd xmm0, rax
    lea rcx, [rbp - 48]
    call QueryPerformanceFrequency
    cvtsi2sd xmm1, qword ptr [rbp - 48]
    divsd xmm0, xmm1
    mov rax, 1000
    cvtsi2sd xmm2, rax
    mulsd xmm0, xmm2
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.event_el_fail:
    xorpd xmm0, xmm0
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_37:
    # --------------------------------------------------------------------------
    # OP 37: GPU_EVENT_DESTROY (args[0] = event_handle)
    # --------------------------------------------------------------------------
    cmp r14, 37
    jne .check_op_38
    test r15, r15
    jz .event_dest_done
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .event_dest_from_scalar
    movsd xmm0, [r15]
    jmp .event_dest_do
.event_dest_from_scalar:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
.event_dest_do:
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .event_dest_done
    mov rbx, rax
    cmp dword ptr [rbx + 32], 1
    jne .event_dest_clear
    mov rcx, [rbx + 16]     # hEvent
    call [rip + gpu_p_cuEventDestroy]
.event_dest_clear:
    mov qword ptr [rbx], 0
.event_dest_done:
    mov rax, 1
    cvtsi2sd xmm0, rax
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_38:
    # --------------------------------------------------------------------------
    # OP 38: GPU_LOAD_KERNEL (args[0] = ptx_string, args[1] = kernel_name_string)
    # --------------------------------------------------------------------------
    cmp r14, 38
    jne .check_op_39
    test r15, r15
    jz .load_k_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .load_k_from_regs
    mov rsi, [r15]          # ptx string
    mov rdi, [r15 + 8]      # kernel name string
    jmp .load_k_do
.load_k_from_regs:
    mov rdx, [rbp - 24]     # args_reg
    mov rsi, [r13 + rdx * 8]
    inc rdx
    mov rdi, [r13 + rdx * 8]
.load_k_do:
    test rsi, rsi
    jz .load_k_fail
    test rdi, rdi
    jz .load_k_fail

    cmp dword ptr [rip + gpu_has_cuda], 1
    jne .load_k_fail

    # Save kernel name in [rbp - 24]
    mov [rbp - 24], rdi

    # Normalize PTX string: replace literal '\' 'n' with actual newline 0x0A
    mov rcx, rsi
    call strlen
    lea rcx, [rax + 128]
    call malloc
    test rax, rax
    jz .load_k_fail
    mov [rbp - 152], rax    # norm buffer

    mov r8, rax             # dst
    xor ecx, ecx            # src idx
    xor edx, edx            # dst idx
.ptx_norm_lp:
    mov al, [rsi + rcx]
    test al, al
    jz .ptx_norm_dn
    cmp al, 92              # '\\'
    jne 1f
    cmp byte ptr [rsi + rcx + 1], 110 # 'n'
    jne 1f
    mov byte ptr [r8 + rdx], 10       # '\n'
    inc rdx
    add rcx, 2
    jmp .ptx_norm_lp
1:
    mov [r8 + rdx], al
    inc rcx
    inc rdx
    jmp .ptx_norm_lp
.ptx_norm_dn:
    mov byte ptr [r8 + rdx], 0

    # cuModuleLoadData(&hModule, norm_ptx_string)
    lea rcx, [rbp - 48]     # &hModule
    mov rdx, [rbp - 152]    # norm string
    call [rip + gpu_p_cuModuleLoadData]
    mov ebx, eax            # save return code

    # Free temporary normalized string
    mov rcx, [rbp - 152]
    call free

    test ebx, ebx
    jnz .load_k_fail
    mov r14, [rbp - 48]     # r14 = hModule

    # cuModuleGetFunction(&hFunc, hModule, kernel_name)
    lea rcx, [rbp - 40]     # &hFunc
    mov rdx, r14            # hModule
    mov r8,  [rbp - 24]     # kernel name
    call [rip + gpu_p_cuModuleGetFunction]
    test eax, eax
    jnz .load_k_fail
    mov rdx, [rbp - 40]     # rdx = hFunc

    # Register kernel handle: type = 5 (kernel), d_ptr = hFunc, size = hModule
    mov rcx, 5              # type = 5
    mov r8, r14             # size = hModule
    mov r9, 1               # is_device = 1
    mov qword ptr [rsp + 32], 0
    mov qword ptr [rsp + 40], 0
    call asm_gpu_register_handle
    cvtsi2sd xmm0, rax
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.load_k_fail:
    xorpd xmm0, xmm0
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_39:
    # --------------------------------------------------------------------------
    # OP 39: GPU_LAUNCH (args = [kernel_id, grid, block, smem, stream, params])
    # --------------------------------------------------------------------------
    cmp r14, 39
    jne .check_op_42
    test r15, r15
    jz .launch_fail

    # kernel_handle is args[0]
    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .launch_fail
    mov rax, [rax + 16]     # hFunc
    mov [rbp - 40], rax     # [rbp - 40] = hFunc

    # Grid dimensions (args[1])
    mov dword ptr [rbp - 48], 1 # gx
    mov dword ptr [rbp - 52], 1 # gy
    mov dword ptr [rbp - 56], 1 # gz
    mov r10, [r15 + 8]
    mov rcx, r10
    call asm_gpu_is_nexus_array
    jne 1f
    movsd xmm0, [r10]
    cvttsd2si eax, xmm0
    mov [rbp - 48], eax
    movsd xmm1, [r10 - 16]
    cvttsd2si rcx, xmm1
    cmp rcx, 1
    jle 2f
    movsd xmm2, [r10 + 8]
    cvttsd2si eax, xmm2
    mov [rbp - 52], eax
    cmp rcx, 2
    jle 2f
    movsd xmm3, [r10 + 16]
    cvttsd2si eax, xmm3
    mov [rbp - 56], eax
    jmp 2f
1:
    movsd xmm0, [r15 + 8]
    cvttsd2si eax, xmm0
    mov [rbp - 48], eax
2:

    # Block dimensions (args[2])
    mov dword ptr [rbp - 60], 256 # bx
    mov dword ptr [rbp - 64], 1   # by
    mov dword ptr [rbp - 68], 1   # bz
    mov r10, [r15 + 16]
    mov rcx, r10
    call asm_gpu_is_nexus_array
    jne 3f
    movsd xmm0, [r10]
    cvttsd2si eax, xmm0
    mov [rbp - 60], eax
    movsd xmm1, [r10 - 16]
    cvttsd2si rcx, xmm1
    cmp rcx, 1
    jle 4f
    movsd xmm2, [r10 + 8]
    cvttsd2si eax, xmm2
    mov [rbp - 64], eax
    cmp rcx, 2
    jle 4f
    movsd xmm3, [r10 + 16]
    cvttsd2si eax, xmm3
    mov [rbp - 68], eax
    jmp 4f
3:
    movsd xmm0, [r15 + 16]
    cvttsd2si eax, xmm0
    mov [rbp - 60], eax
4:

    # Shared memory (args[3])
    mov dword ptr [rbp - 72], 0
    movsd xmm0, [r15 + 24]
    cvttsd2si eax, xmm0
    mov [rbp - 72], eax

    # Stream (args[4])
    mov qword ptr [rbp - 80], 0
    movsd xmm0, [r15 + 32]
    cvttsd2si rcx, xmm0
    test rcx, rcx
    jz .launch_params_setup
    call asm_gpu_lookup_handle
    test rax, rax
    jz .launch_params_setup
    mov rcx, [rax + 16]
    mov [rbp - 80], rcx

.launch_params_setup:
    # Kernel parameters array (args[5])
    mov qword ptr [rbp - 88], 0
    mov rsi, [r15 + 40]
    mov rcx, rsi
    call asm_gpu_is_nexus_array
    jne .launch_zero_params
    movsd xmm0, [rsi - 16]
    cvttsd2si r12, xmm0
    test r12, r12
    jle .launch_zero_params
    cmp r12, 8
    jbe 5f
    mov r12, 8
5:
    xor ecx, ecx
.launch_p_lp:
    cmp rcx, r12
    jge .launch_p_ready
    movsd xmm0, [rsi + rcx * 8]
    cvttsd2si rdx, xmm0
    push rcx
    push r12
    mov rcx, rdx
    call asm_gpu_lookup_handle
    pop r12
    pop rcx
    test rax, rax
    jz .launch_p_scalar
    lea rdx, [rax + 16]     # &d_ptr
    mov [rbp - 144 + rcx * 8], rdx
    inc rcx
    jmp .launch_p_lp
.launch_p_scalar:
    movsd xmm0, [rsi + rcx * 8]
    cvttsd2si rax, xmm0
    cvtsi2sd xmm2, rax
    ucomisd xmm2, xmm0
    jne 6f
    # Integer scalar
    mov [rbp - 208 + rcx * 8], rax
    jmp 7f
6:
    # Float scalar
    cvtsd2ss xmm1, xmm0
    movss [rbp - 208 + rcx * 8], xmm1
7:
    lea rdx, [rbp - 208 + rcx * 8]
    mov [rbp - 144 + rcx * 8], rdx
    inc rcx
    jmp .launch_p_lp

.launch_p_ready:
    lea rax, [rbp - 144]
    mov [rbp - 88], rax

.launch_zero_params:
    # Invoke cuLaunchKernel
    mov eax, [rbp - 60]
    mov [rsp + 32], eax     # block_x
    mov eax, [rbp - 64]
    mov [rsp + 40], eax     # block_y
    mov eax, [rbp - 68]
    mov [rsp + 48], eax     # block_z
    mov eax, [rbp - 72]
    mov [rsp + 56], eax     # smem
    mov rax, [rbp - 80]
    mov [rsp + 64], rax     # hStream
    mov rax, [rbp - 88]
    mov [rsp + 72], rax     # kernelParams
    mov qword ptr [rsp + 80], 0 # extra

    mov rcx, [rbp - 40]     # hFunc
    mov edx, [rbp - 48]     # grid_x
    mov r8d, [rbp - 52]     # grid_y
    mov r9d, [rbp - 56]     # grid_z
    call [rip + gpu_p_cuLaunchKernel]
    test eax, eax
    jnz .launch_fail
    mov rax, 1
    cvtsi2sd xmm0, rax
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.launch_fail:
    xorpd xmm0, xmm0
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_42:
    # --------------------------------------------------------------------------
    # OP 42: GPU_SOFTMAX (args = [in])
    # --------------------------------------------------------------------------
    cmp r14, 42
    jne .check_op_43
    test r15, r15
    jz .sm_fail

    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .sm_from_scalar
    movsd xmm0, [r15]
    jmp .sm_do_lookup
.sm_from_scalar:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
.sm_do_lookup:
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .sm_fail
    mov rsi, rax

    mov r10d, [rsi + 40]    # rows
    mov r11d, [rsi + 44]    # cols
    mov [rbp - 56], r10d
    mov [rbp - 60], r11d

    mov eax, r10d
    imul eax, r11d
    mov [rbp - 68], eax
    shl eax, 2
    mov [rbp - 76], eax

    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov edx, [rbp - 76]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .sm_fail
    mov rdi, [rbp - 48]
    mov [rbp - 88], rdi

    # Setup kargs: [&d_in, &d_out, &rows, &cols]
    lea rax, [rsi + 16]
    mov [rbp - 256], rax
    lea rax, [rbp - 88]
    mov [rbp - 248], rax
    lea rax, [rbp - 56]
    mov [rbp - 240], rax
    lea rax, [rbp - 60]
    mov [rbp - 232], rax

    mov eax, [rbp - 56]
    add eax, 255
    shr eax, 8
    test eax, eax
    jnz 1f
    mov eax, 1
1:
    mov rcx, [rip + gpu_fn_softmax]
    mov edx, eax
    mov r8d, 1
    mov r9d, 1
    mov dword ptr [rsp + 32], 256
    mov dword ptr [rsp + 40], 1
    mov dword ptr [rsp + 48], 1
    mov dword ptr [rsp + 56], 0
    mov qword ptr [rsp + 64], 0
    lea rax, [rbp - 256]
    mov [rsp + 72], rax
    mov qword ptr [rsp + 80], 0
    call [rip + gpu_p_cuLaunchKernel]

    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8,  [rbp - 76]
    mov r9,  1
    mov r10d, [rbp - 56]
    mov [rsp + 32], r10d
    mov r11d, [rbp - 60]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.sm_fail:
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_43:
    # --------------------------------------------------------------------------
    # OP 43: GPU_LAYERNORM (args = [in, gamma, beta, eps])
    # --------------------------------------------------------------------------
    cmp r14, 43
    jne .check_op_44
    test r15, r15
    jz .ln_fail

    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .ln_fail
    mov rsi, rax

    mov r10d, [rsi + 40]    # rows
    mov r11d, [rsi + 44]    # cols
    mov [rbp - 56], r10d
    mov [rbp - 60], r11d

    mov eax, r10d
    imul eax, r11d
    shl eax, 2
    mov [rbp - 76], eax

    mov qword ptr [rbp - 68], 0         # d_gamma = 0
    mov qword ptr [rbp - 80], 0         # d_beta = 0
    mov dword ptr [rbp - 84], 0x3727C5AC # eps default = 1e-5

    movsd xmm0, [r15 - 16]
    cvttsd2si r10, xmm0                 # r10 = total args
    mov [rbp - 104], r10                # preserve arg count

    cmp r10, 1
    jle 1f
    movsd xmm1, [r15 + 8]
    cvttsd2si rcx, xmm1
    test rcx, rcx
    jz 1f
    call asm_gpu_lookup_handle
    test rax, rax
    jz 1f
    mov rax, [rax + 16]
    mov [rbp - 68], rax
1:
    mov r10, [rbp - 104]
    cmp r10, 2
    jle 2f
    movsd xmm1, [r15 + 16]
    cvttsd2si rcx, xmm1
    test rcx, rcx
    jz 2f
    call asm_gpu_lookup_handle
    test rax, rax
    jz 2f
    mov rax, [rax + 16]
    mov [rbp - 80], rax
2:
    mov r10, [rbp - 104]
    cmp r10, 3
    jle 3f
    movsd xmm1, [r15 + 24]
    cvtsd2ss xmm2, xmm1
    movss [rbp - 84], xmm2
3:
    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov edx, [rbp - 76]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .ln_fail
    mov rdi, [rbp - 48]
    mov [rbp - 88], rdi

    # Setup kargs: [&d_in, &d_out, &d_gamma, &d_beta, &eps, &rows, &cols]
    lea rax, [rsi + 16]
    mov [rbp - 256], rax
    lea rax, [rbp - 88]
    mov [rbp - 248], rax
    lea rax, [rbp - 68]
    mov [rbp - 240], rax
    lea rax, [rbp - 80]
    mov [rbp - 232], rax
    lea rax, [rbp - 84]
    mov [rbp - 224], rax
    lea rax, [rbp - 56]
    mov [rbp - 216], rax
    lea rax, [rbp - 60]
    mov [rbp - 208], rax

    mov eax, [rbp - 56]
    add eax, 255
    shr eax, 8
    test eax, eax
    jnz 4f
    mov eax, 1
4:
    mov rcx, [rip + gpu_fn_layernorm]
    mov edx, eax
    mov r8d, 1
    mov r9d, 1
    mov dword ptr [rsp + 32], 256
    mov dword ptr [rsp + 40], 1
    mov dword ptr [rsp + 48], 1
    mov dword ptr [rsp + 56], 0
    mov qword ptr [rsp + 64], 0
    lea rax, [rbp - 256]
    mov [rsp + 72], rax
    mov qword ptr [rsp + 80], 0
    call [rip + gpu_p_cuLaunchKernel]

    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8,  [rbp - 76]
    mov r9,  1
    mov r10d, [rbp - 56]
    mov [rsp + 32], r10d
    mov r11d, [rbp - 60]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.ln_fail:
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_44:
    # --------------------------------------------------------------------------
    # OP 44: GPU_RMSNORM (args = [in, gamma, eps])
    # --------------------------------------------------------------------------
    cmp r14, 44
    jne .check_op_45
    test r15, r15
    jz .rms_fail

    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .rms_fail
    mov rsi, rax

    mov r10d, [rsi + 40]
    mov r11d, [rsi + 44]
    mov [rbp - 56], r10d
    mov [rbp - 60], r11d

    mov eax, r10d
    imul eax, r11d
    shl eax, 2
    mov [rbp - 76], eax

    mov qword ptr [rbp - 68], 0         # d_gamma = 0
    mov dword ptr [rbp - 84], 0x3727C5AC # eps default = 1e-5

    movsd xmm0, [r15 - 16]
    cvttsd2si r10, xmm0                 # r10 = total args
    mov [rbp - 104], r10                # preserve arg count

    cmp r10, 1
    jle 1f
    movsd xmm1, [r15 + 8]
    cvttsd2si rcx, xmm1
    test rcx, rcx
    jz 1f
    call asm_gpu_lookup_handle
    test rax, rax
    jz 1f
    mov rax, [rax + 16]
    mov [rbp - 68], rax
1:
    mov r10, [rbp - 104]
    cmp r10, 2
    jle 2f
    movsd xmm1, [r15 + 16]
    cvtsd2ss xmm2, xmm1
    movss [rbp - 84], xmm2
2:
    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov edx, [rbp - 76]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .rms_fail
    mov rdi, [rbp - 48]
    mov [rbp - 88], rdi

    # Setup kargs: [&d_in, &d_out, &d_gamma, &eps, &rows, &cols]
    lea rax, [rsi + 16]
    mov [rbp - 256], rax
    lea rax, [rbp - 88]
    mov [rbp - 248], rax
    lea rax, [rbp - 68]
    mov [rbp - 240], rax
    lea rax, [rbp - 84]
    mov [rbp - 232], rax
    lea rax, [rbp - 56]
    mov [rbp - 224], rax
    lea rax, [rbp - 60]
    mov [rbp - 216], rax

    mov eax, [rbp - 56]
    add eax, 255
    shr eax, 8
    test eax, eax
    jnz 3f
    mov eax, 1
3:
    mov rcx, [rip + gpu_fn_rmsnorm]
    mov edx, eax
    mov r8d, 1
    mov r9d, 1
    mov dword ptr [rsp + 32], 256
    mov dword ptr [rsp + 40], 1
    mov dword ptr [rsp + 48], 1
    mov dword ptr [rsp + 56], 0
    mov qword ptr [rsp + 64], 0
    lea rax, [rbp - 256]
    mov [rsp + 72], rax
    mov qword ptr [rsp + 80], 0
    call [rip + gpu_p_cuLaunchKernel]

    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8,  [rbp - 76]
    mov r9,  1
    mov r10d, [rbp - 56]
    mov [rsp + 32], r10d
    mov r11d, [rbp - 60]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.rms_fail:
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_45:
    # --------------------------------------------------------------------------
    # OP 45: GPU_SUM / OP 46: GPU_MEAN (args = [in])
    # --------------------------------------------------------------------------
    cmp r14, 45
    je .do_reduction
    cmp r14, 46
    jne .check_op_47

.do_reduction:
    test r15, r15
    jz .red_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .red_from_scalar
    movsd xmm0, [r15]
    jmp .red_do_lookup
.red_from_scalar:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
.red_do_lookup:
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .red_fail
    mov rbx, rax

    mov r8, [rbx + 24]
    mov r10, r8
    shr r10, 2
    test r10, r10
    jle .red_fail
    mov [rbp - 68], r10

    mov edx, [rbx + 32]
    and edx, [rip + gpu_has_cuda]
    cmp edx, 1
    jne .red_host

    mov rcx, r8
    call malloc
    test rax, rax
    jz .red_fail
    mov [rbp - 48], rax

    mov rcx, [rbp - 48]
    mov rdx, [rbx + 16]
    mov r8,  [rbx + 24]
    call [rip + gpu_p_cuMemcpyDtoH]

    mov rsi, [rbp - 48]
    mov rcx, [rbp - 68]
    xorps xmm0, xmm0
.red_dev_lp:
    test rcx, rcx
    jz .red_dev_dn
    cvtss2sd xmm1, [rsi]
    addsd xmm0, xmm1
    add rsi, 4
    dec rcx
    jmp .red_dev_lp
.red_dev_dn:
    movsd [rbp - 152], xmm0
    mov rcx, [rbp - 48]
    call free
    movsd xmm0, [rbp - 152]
    jmp .red_calc

.red_host:
    mov rsi, [rbx + 16]
    mov rcx, [rbp - 68]
    xorps xmm0, xmm0
.red_h_lp:
    test rcx, rcx
    jz .red_calc
    cvtss2sd xmm1, [rsi]
    addsd xmm0, xmm1
    add rsi, 4
    dec rcx
    jmp .red_h_lp

.red_calc:
    cmp r14, 46
    jne .red_write
    cvtsi2sd xmm1, qword ptr [rbp - 68]
    divsd xmm0, xmm1

.red_write:
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.red_fail:
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_47:
    # --------------------------------------------------------------------------
    # OP 47: GPU_GAUSSIAN_BLUR (args = [in, H, W])
    # --------------------------------------------------------------------------
    cmp r14, 47
    jne .check_op_48
    test r15, r15
    jz .blur_fail

    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .blur_fail
    mov rsi, rax

    mov r10d, [rsi + 40]
    mov r11d, [rsi + 44]
    mov [rbp - 56], r10d
    mov [rbp - 60], r11d

    movsd xmm0, [r15 - 16]
    cvttsd2si rcx, xmm0
    cmp rcx, 1
    jle 1f
    movsd xmm1, [r15 + 8]
    cvttsd2si eax, xmm1
    test eax, eax
    jle 1f
    mov [rbp - 56], eax
1:
    cmp rcx, 2
    jle 2f
    movsd xmm1, [r15 + 16]
    cvttsd2si eax, xmm1
    test eax, eax
    jle 2f
    mov [rbp - 60], eax
2:
    mov eax, [rbp - 56]
    imul eax, [rbp - 60]
    shl eax, 2
    mov [rbp - 76], eax

    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov edx, [rbp - 76]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .blur_fail
    mov rdi, [rbp - 48]
    mov [rbp - 88], rdi

    # Setup kargs: [&d_in, &d_out, &H, &W]
    lea rax, [rsi + 16]
    mov [rbp - 256], rax
    lea rax, [rbp - 88]
    mov [rbp - 248], rax
    lea rax, [rbp - 56]
    mov [rbp - 240], rax
    lea rax, [rbp - 60]
    mov [rbp - 232], rax

    mov eax, [rbp - 60]
    add eax, 15
    shr eax, 4
    test eax, eax
    jnz 3f
    mov eax, 1
3:
    mov edx, eax
    mov eax, [rbp - 56]
    add eax, 15
    shr eax, 4
    test eax, eax
    jnz 4f
    mov eax, 1
4:
    mov r8d, eax
    mov rcx, [rip + gpu_fn_blur]
    mov r9d, 1
    mov dword ptr [rsp + 32], 16
    mov dword ptr [rsp + 40], 16
    mov dword ptr [rsp + 48], 1
    mov dword ptr [rsp + 56], 0
    mov qword ptr [rsp + 64], 0
    lea rax, [rbp - 256]
    mov [rsp + 72], rax
    mov qword ptr [rsp + 80], 0
    call [rip + gpu_p_cuLaunchKernel]

    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8,  [rbp - 76]
    mov r9,  1
    mov r10d, [rbp - 56]
    mov [rsp + 32], r10d
    mov r11d, [rbp - 60]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.blur_fail:
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_48:
    # --------------------------------------------------------------------------
    # OP 48: GPU_SOBEL (args = [in, H, W])
    # --------------------------------------------------------------------------
    cmp r14, 48
    jne .check_op_49
    test r15, r15
    jz .sobel_fail

    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .sobel_fail
    mov rsi, rax

    mov r10d, [rsi + 40]
    mov r11d, [rsi + 44]
    mov [rbp - 56], r10d
    mov [rbp - 60], r11d

    movsd xmm0, [r15 - 16]
    cvttsd2si rcx, xmm0
    cmp rcx, 1
    jle 1f
    movsd xmm1, [r15 + 8]
    cvttsd2si eax, xmm1
    test eax, eax
    jle 1f
    mov [rbp - 56], eax
1:
    cmp rcx, 2
    jle 2f
    movsd xmm1, [r15 + 16]
    cvttsd2si eax, xmm1
    test eax, eax
    jle 2f
    mov [rbp - 60], eax
2:
    mov eax, [rbp - 56]
    imul eax, [rbp - 60]
    shl eax, 2
    mov [rbp - 76], eax

    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov edx, [rbp - 76]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .sobel_fail
    mov rdi, [rbp - 48]
    mov [rbp - 88], rdi

    # Setup kargs: [&d_in, &d_out, &H, &W]
    lea rax, [rsi + 16]
    mov [rbp - 256], rax
    lea rax, [rbp - 88]
    mov [rbp - 248], rax
    lea rax, [rbp - 56]
    mov [rbp - 240], rax
    lea rax, [rbp - 60]
    mov [rbp - 232], rax

    mov eax, [rbp - 60]
    add eax, 15
    shr eax, 4
    test eax, eax
    jnz 3f
    mov eax, 1
3:
    mov edx, eax
    mov eax, [rbp - 56]
    add eax, 15
    shr eax, 4
    test eax, eax
    jnz 4f
    mov eax, 1
4:
    mov r8d, eax
    mov rcx, [rip + gpu_fn_sobel]
    mov r9d, 1
    mov dword ptr [rsp + 32], 16
    mov dword ptr [rsp + 40], 16
    mov dword ptr [rsp + 48], 1
    mov dword ptr [rsp + 56], 0
    mov qword ptr [rsp + 64], 0
    lea rax, [rbp - 256]
    mov [rsp + 72], rax
    mov qword ptr [rsp + 80], 0
    call [rip + gpu_p_cuLaunchKernel]

    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8,  [rbp - 76]
    mov r9,  1
    mov r10d, [rbp - 56]
    mov [rsp + 32], r10d
    mov r11d, [rbp - 60]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.sobel_fail:
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_49:
    # --------------------------------------------------------------------------
    # OP 49: GPU_RESIZE_BILINEAR (args = [in, inH, inW, outH, outW])
    # --------------------------------------------------------------------------
    cmp r14, 49
    jne .check_op_50
    test r15, r15
    jz .resz_fail

    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .resz_fail
    mov rsi, rax

    mov r10d, [rsi + 40]
    mov r11d, [rsi + 44]
    mov [rbp - 56], r10d    # inH
    mov [rbp - 60], r11d    # inW

    movsd xmm0, [r15 - 16]
    cvttsd2si rcx, xmm0
    cmp rcx, 1
    jle 1f
    movsd xmm1, [r15 + 8]
    cvttsd2si eax, xmm1
    test eax, eax
    jle 1f
    mov [rbp - 56], eax
1:
    cmp rcx, 2
    jle 2f
    movsd xmm1, [r15 + 16]
    cvttsd2si eax, xmm1
    test eax, eax
    jle 2f
    mov [rbp - 60], eax
2:
    mov eax, [rbp - 56]
    mov [rbp - 64], eax     # outH default = inH
    cmp rcx, 3
    jle 3f
    movsd xmm1, [r15 + 24]
    cvttsd2si eax, xmm1
    test eax, eax
    jle 3f
    mov [rbp - 64], eax
3:
    mov eax, [rbp - 60]
    mov [rbp - 68], eax     # outW default = inW
    cmp rcx, 4
    jle 4f
    movsd xmm1, [r15 + 32]
    cvttsd2si eax, xmm1
    test eax, eax
    jle 4f
    mov [rbp - 68], eax
4:
    mov eax, [rbp - 64]
    imul eax, [rbp - 68]
    shl eax, 2
    mov [rbp - 76], eax

    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov edx, [rbp - 76]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .resz_fail
    mov rdi, [rbp - 48]
    mov [rbp - 88], rdi

    # Setup kargs: [&d_in, &d_out, &inH, &inW, &outH, &outW]
    lea rax, [rsi + 16]
    mov [rbp - 256], rax
    lea rax, [rbp - 88]
    mov [rbp - 248], rax
    lea rax, [rbp - 56]
    mov [rbp - 240], rax
    lea rax, [rbp - 60]
    mov [rbp - 232], rax
    lea rax, [rbp - 64]
    mov [rbp - 224], rax
    lea rax, [rbp - 68]
    mov [rbp - 216], rax

    mov eax, [rbp - 68]     # outW
    add eax, 15
    shr eax, 4
    test eax, eax
    jnz 5f
    mov eax, 1
5:
    mov edx, eax
    mov eax, [rbp - 64]     # outH
    add eax, 15
    shr eax, 4
    test eax, eax
    jnz 6f
    mov eax, 1
6:
    mov r8d, eax
    mov rcx, [rip + gpu_fn_resize]
    mov r9d, 1
    mov dword ptr [rsp + 32], 16
    mov dword ptr [rsp + 40], 16
    mov dword ptr [rsp + 48], 1
    mov dword ptr [rsp + 56], 0
    mov qword ptr [rsp + 64], 0
    lea rax, [rbp - 256]
    mov [rsp + 72], rax
    mov qword ptr [rsp + 80], 0
    call [rip + gpu_p_cuLaunchKernel]

    mov rcx, 2
    mov rdx, [rbp - 88]
    mov r8,  [rbp - 76]
    mov r9,  1
    mov r10d, [rbp - 64]
    mov [rsp + 32], r10d
    mov r11d, [rbp - 68]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.resz_fail:
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_50:
    # --------------------------------------------------------------------------
    # OP 50: GPU_MEM_INFO -> returns [free_mb, total_mb]
    # --------------------------------------------------------------------------
    cmp r14, 50
    jne .check_op_51
    mov rax, [rip + gpu_p_cuMemGetInfo]
    test rax, rax
    jz .op50_fail
    lea rcx, [rbp - 48]
    lea rdx, [rbp - 56]
    call rax
    test eax, eax
    jnz .op50_fail

    # Allocate Nexus 2-element array (16 bytes payload)
    mov rcx, 16
    mov rdx, 0x4152524159   # "ARRAY"
    call gc_malloc
    test rax, rax
    jz .op50_fail

    mov r10, 0x4152524159
    mov [rax - 32], r10
    mov qword ptr [rax - 24], 16
    mov qword ptr [rax - 8], 2
    mov r10, 2
    cvtsi2sd xmm0, r10
    movsd [rax - 16], xmm0

    # free_mb:
    mov r10, [rbp - 48]
    shr r10, 20
    cvtsi2sd xmm1, r10
    movsd [rax], xmm1

    # total_mb:
    mov r11, [rbp - 56]
    shr r11, 20
    cvtsi2sd xmm2, r11
    movsd [rax + 8], xmm2

    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    mov [r13 + rdx * 8], rax
    jmp .dispatch_done

.op50_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_51:
    # --------------------------------------------------------------------------
    # OP 51: GPU_ALLOC_MANAGED (args[0] = size_bytes)
    # --------------------------------------------------------------------------
    cmp r14, 51
    jne .check_op_52
    mov rbx, 1024
    test r15, r15
    jz .do_alloc_managed
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .alloc_man_scalar
    movsd xmm0, [r15]
    cvttsd2si rbx, xmm0
    jmp .do_alloc_managed
.alloc_man_scalar:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
    cvttsd2si rbx, xmm0

.do_alloc_managed:
    mov rax, [rip + gpu_p_cuMemAllocManaged]
    test rax, rax
    jz .alloc_man_fail

    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov rdx, rbx
    mov r8d, 1               # CU_MEM_ATTACH_GLOBAL = 1
    call rax
    test eax, eax
    jnz .alloc_man_fail

    mov rcx, 5               # type = 5 (managed)
    mov rdx, [rbp - 48]      # d_ptr
    mov r8,  rbx             # size_bytes
    mov r9,  1               # is_device = 1
    mov qword ptr [rsp + 32], 0
    mov qword ptr [rsp + 40], 0
    call asm_gpu_register_handle
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.alloc_man_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_52:
    # --------------------------------------------------------------------------
    # OP 52: GPU_ALLOC_PINNED (args[0] = size_bytes)
    # --------------------------------------------------------------------------
    cmp r14, 52
    jne .check_op_53
    mov rbx, 1024
    test r15, r15
    jz .do_alloc_pinned
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .alloc_pin_scalar
    movsd xmm0, [r15]
    cvttsd2si rbx, xmm0
    jmp .do_alloc_pinned
.alloc_pin_scalar:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
    cvttsd2si rbx, xmm0

.do_alloc_pinned:
    mov rax, [rip + gpu_p_cuMemAllocHost]
    test rax, rax
    jz .alloc_pin_fail

    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov rdx, rbx
    call rax
    test eax, eax
    jnz .alloc_pin_fail

    mov rcx, 6               # type = 6 (pinned)
    mov rdx, [rbp - 48]      # h_ptr
    mov r8,  rbx             # size_bytes
    mov r9,  0               # is_device = 0
    mov qword ptr [rsp + 32], 0
    mov qword ptr [rsp + 40], 0
    call asm_gpu_register_handle
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.alloc_pin_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_53:
    # --------------------------------------------------------------------------
    # OP 53: GPU_MEMCPY_ASYNC (args = [mode, dst_handle, src, bytes, stream_handle])
    # --------------------------------------------------------------------------
    cmp r14, 53
    jne .check_op_54
    test r15, r15
    jz .async_cpy_fail

    # Read mode: args[0]
    movsd xmm0, [r15]
    cvttsd2si rbx, xmm0     # rbx = mode (1=HtoD, 2=DtoH, 3=DtoD)

    # Read dst: args[1]
    movsd xmm0, [r15 + 8]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .async_cpy_fail
    mov rsi, rax            # rsi = dst entry

    # Read bytes: args[3]
    movsd xmm0, [r15 + 24]
    cvttsd2si r11, xmm0     # r11 = bytes
    mov [rbp - 56], r11

    # Read stream: args[4]
    xor r10, r10            # default stream = 0
    movsd xmm0, [r15 - 16]
    cvttsd2si rcx, xmm0
    cmp rcx, 4
    jle 1f
    movsd xmm0, [r15 + 32]
    cvttsd2si rcx, xmm0
    test rcx, rcx
    jz 1f
    call asm_gpu_lookup_handle
    test rax, rax
    jz 1f
    mov r10, [rax + 16]     # hStream
1:
    mov [rbp - 64], r10     # stream handle

    cmp rbx, 3
    je .async_dtod
    cmp rbx, 2
    je .async_dtoh

    # Mode 1: HtoD Async
    # Check if args[2] is a handle or array pointer
    mov r8, [r15 + 16]       # raw pointer or double
    mov rcx, r8
    call asm_gpu_is_nexus_array
    je .async_htod_from_arr
    # Try as handle:
    movsd xmm0, [r15 + 16]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .async_cpy_fail
    mov rdx, [rax + 16]     # h_ptr
    jmp .do_async_htod

.async_htod_from_arr:
    lea rdx, [rbp - 48]
    mov rcx, r8
    call asm_extract_floats_from_nexus_array
    test rax, rax
    jz .async_cpy_fail
    mov rdx, rax            # float*

.do_async_htod:
    mov rcx, [rsi + 16]     # dst d_ptr
    mov r8,  [rbp - 56]     # bytes
    mov r9,  [rbp - 64]     # stream
    call [rip + gpu_p_cuMemcpyHtoDAsync]
    jmp .async_cpy_done

.async_dtoh:
    # Mode 2: DtoH Async
    # dst is pinned handle (rsi + 16), src is device handle in args[2]
    movsd xmm0, [r15 + 16]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .async_cpy_fail
    mov rdx, [rax + 16]     # src d_ptr
    mov rcx, [rsi + 16]     # dst h_ptr
    mov r8,  [rbp - 56]     # bytes
    mov r9,  [rbp - 64]     # stream
    call [rip + gpu_p_cuMemcpyDtoHAsync]
    jmp .async_cpy_done

.async_dtod:
    # Mode 3: DtoD Async
    # src is device handle in args[2]
    movsd xmm0, [r15 + 16]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .async_cpy_fail
    mov rdx, [rax + 16]     # src d_ptr
    mov rcx, [rsi + 16]     # dst d_ptr
    mov r8,  [rbp - 56]     # bytes
    mov r9,  [rbp - 64]     # stream
    call [rip + gpu_p_cuMemcpyDtoDAsync]

.async_cpy_done:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    mov rax, 1
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.async_cpy_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_54:
    # --------------------------------------------------------------------------
    # OP 54: GPU_MEM_PREFETCH (args = [handle, bytes, stream_handle])
    # --------------------------------------------------------------------------
    cmp r14, 54
    jne .check_op_55
    test r15, r15
    jz .prefetch_fail

    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .prefetch_fail
    mov rsi, rax

    mov rdx, [rsi + 24]      # default bytes = size_bytes
    movsd xmm0, [r15 - 16]
    cvttsd2si rcx, xmm0
    cmp rcx, 1
    jle 1f
    movsd xmm0, [r15 + 8]
    cvttsd2si rdx, xmm0
1:
    mov [rbp - 48], rdx      # bytes

    xor r9, r9               # stream = 0
    cmp rcx, 2
    jle 2f
    movsd xmm0, [r15 + 16]
    cvttsd2si rcx, xmm0
    test rcx, rcx
    jz 2f
    call asm_gpu_lookup_handle
    test rax, rax
    jz 2f
    mov r9, [rax + 16]
2:
    mov rax, [rip + gpu_p_cuMemPrefetchAsync]
    test rax, rax
    jz .prefetch_fail

    mov rcx, [rsi + 16]      # d_ptr
    mov rdx, [rbp - 48]      # count
    mov r8d, [rip + gpu_dev_id] # dev_id
    call rax
    test eax, eax
    jnz .prefetch_fail

    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    mov rax, 1
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.prefetch_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_55:
    # --------------------------------------------------------------------------
    # OP 55: GPU_STREAM_WAIT_EVENT (args = [stream_handle, event_handle])
    # --------------------------------------------------------------------------
    cmp r14, 55
    jne .check_op_56
    test r15, r15
    jz .wait_evt_fail

    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .wait_evt_fail
    mov rbx, [rax + 16]      # rbx = hStream

    movsd xmm0, [r15 + 8]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .wait_evt_fail
    mov rsi, [rax + 16]      # rsi = hEvent

    mov rax, [rip + gpu_p_cuStreamWaitEvent]
    test rax, rax
    jz .wait_evt_fail

    mov rcx, rbx
    mov rdx, rsi
    xor r8d, r8d             # flags = 0
    call rax

    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    mov rax, 1
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.wait_evt_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_56:
    # --------------------------------------------------------------------------
    # OP 56: GPU_STREAM_QUERY (args[0] = stream_handle)
    # --------------------------------------------------------------------------
    cmp r14, 56
    jne .check_op_57
    test r15, r15
    jz .stream_q_zero
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .stream_q_scalar
    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    jmp .do_stream_q
.stream_q_scalar:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
    cvttsd2si rcx, xmm0
.do_stream_q:
    call asm_gpu_lookup_handle
    test rax, rax
    jz .stream_q_zero

    mov rcx, [rax + 16]
    call [rip + gpu_p_cuStreamQuery]
    test eax, eax
    jnz .stream_q_zero       # 0 = CUDA_SUCCESS (completed)
    mov rax, 1
    cvtsi2sd xmm0, rax
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.stream_q_zero:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_57:
    # --------------------------------------------------------------------------
    # OP 57: GPU_EVENT_QUERY (args[0] = event_handle)
    # --------------------------------------------------------------------------
    cmp r14, 57
    jne .check_op_58
    test r15, r15
    jz .event_q_zero
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .event_q_scalar
    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    jmp .do_event_q
.event_q_scalar:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
    cvttsd2si rcx, xmm0
.do_event_q:
    call asm_gpu_lookup_handle
    test rax, rax
    jz .event_q_zero

    mov rcx, [rax + 16]
    call [rip + gpu_p_cuEventQuery]
    test eax, eax
    jnz .event_q_zero        # 0 = CUDA_SUCCESS
    mov rax, 1
    cvtsi2sd xmm0, rax
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.event_q_zero:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_58:
    # --------------------------------------------------------------------------
    # OP 58: GPU_PINNED_WRITE (args = [pinned_handle, host_array])
    # --------------------------------------------------------------------------
    cmp r14, 58
    jne .check_op_59
    test r15, r15
    jz .pin_write_fail

    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .pin_write_fail
    mov rsi, rax            # rsi = handle entry
    mov rdi, [rsi + 16]     # rdi = pinned host ptr

    # args[1] is array:
    mov rbx, [r15 + 8]
    mov rcx, rbx
    call asm_gpu_is_nexus_array
    jne .pin_write_fail

    movsd xmm0, [rbx - 16]
    cvttsd2si r12, xmm0     # count
    test r12, r12
    jle .pin_write_fail

    xor ecx, ecx
.pin_wr_lp:
    cmp rcx, r12
    jae .pin_wr_dn
    movsd xmm1, [rbx + rcx * 8]
    cvtsd2ss xmm2, xmm1
    movss [rdi + rcx * 4], xmm2
    inc rcx
    jmp .pin_wr_lp
.pin_wr_dn:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    mov rax, 1
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.pin_write_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_59:
    # --------------------------------------------------------------------------
    # OP 59: GPU_PINNED_READ (args = [pinned_handle, count])
    # --------------------------------------------------------------------------
    cmp r14, 59
    jne .check_op_60
    test r15, r15
    jz .pin_read_fail

    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .pin_read_fail
    mov rsi, [rax + 16]     # rsi = pinned host ptr

    mov r12, 1
    movsd xmm0, [r15 - 16]
    cvttsd2si rcx, xmm0
    cmp rcx, 1
    jle 1f
    movsd xmm0, [r15 + 8]
    cvttsd2si r12, xmm0
1:
    test r12, r12
    jle .pin_read_fail

    mov rcx, rsi
    mov rdx, r12
    call asm_create_nexus_array_from_floats
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    mov [r13 + rdx * 8], rax
    jmp .dispatch_done

.pin_read_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_60:
    # --------------------------------------------------------------------------
    # OP 60: GPU_TENSOR_SET_ITEM (args = [tensor, row, col, val])
    # Memory-Safe Scalar Element Mutation with Hardware Bounds Checking
    # --------------------------------------------------------------------------
    cmp r14, 60
    jne .check_op_61
    test r15, r15
    jz .set_item_fail

    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .set_item_fail
    mov rsi, rax            # rsi = handle entry

    # Default row=0, col=0, val=0.0
    xor r10d, r10d          # row
    xor r11d, r11d          # col
    xorps xmm2, xmm2        # val
    movsd xmm0, [r15 - 16]
    cvttsd2si rcx, xmm0     # arg count
    cmp rcx, 1
    jle 1f
    movsd xmm0, [r15 + 8]
    cvttsd2si r10d, xmm0    # row
1:
    cmp rcx, 2
    jle 2f
    movsd xmm0, [r15 + 16]
    cvttsd2si r11d, xmm0    # col
2:
    cmp rcx, 3
    jle 3f
    movsd xmm0, [r15 + 24]
    cvtsd2ss xmm2, xmm0     # val (float32)
3:
    # Bounds check:
    # 0 <= row < dim0 [rsi + 40]
    # 0 <= col < dim1 [rsi + 44]
    test r10d, r10d
    jl .set_item_fail
    cmp r10d, [rsi + 40]
    jge .set_item_fail
    test r11d, r11d
    jl .set_item_fail
    cmp r11d, [rsi + 44]
    jge .set_item_fail

    # Linear offset in bytes = (row * dim1 + col) * 4
    mov eax, r10d
    imul eax, [rsi + 44]
    add eax, r11d
    shl rax, 2              # rax = offset in bytes

    # Check offset + 4 <= size_bytes [rsi + 24]
    lea rdx, [rax + 4]
    cmp rdx, [rsi + 24]
    ja .set_item_fail

    mov rbx, [rsi + 16]     # ptr
    add rbx, rax

    cmp dword ptr [rsi + 32], 1
    jne .set_item_host

    # Write float to CUDA VRAM via cuMemcpyHtoD
    movss [rbp - 48], xmm2
    mov rcx, rbx            # dst = rbx (d_ptr + offset)
    lea rdx, [rbp - 48]     # src = &val
    mov r8d, 4              # 4 bytes
    call [rip + gpu_p_cuMemcpyHtoD]
    test eax, eax
    jnz .set_item_fail

    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    mov rax, 1
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.set_item_host:
    movss [rbx], xmm2
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    mov rax, 1
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.set_item_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_61:
    # --------------------------------------------------------------------------
    # OP 61: GPU_TENSOR_DEVICE (args = [tensor])
    # Returns 1.0 for CUDA VRAM, 0.0 for CPU RAM
    # --------------------------------------------------------------------------
    cmp r14, 61
    jne .check_op_62
    test r15, r15
    jz .dev_fail

    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .dev_from_scalar
    movsd xmm0, [r15]
    jmp .dev_lookup
.dev_from_scalar:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
.dev_lookup:
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .dev_fail

    mov rax, [rax + 32]      # is_device (1 = CUDA, 0 = CPU)
    cvtsi2sd xmm0, rax
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.dev_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_62:
    # --------------------------------------------------------------------------
    # OP 62: GPU_TENSOR_TO_DEVICE (args = [tensor, target_device])
    # target_device: 1 = CUDA VRAM, 0 = CPU RAM
    # Returns: handle_id (zero-copy if already on target, new handle if migrated)
    # --------------------------------------------------------------------------
    cmp r14, 62
    jne .check_op_63
    test r15, r15
    jz .to_dev_fail

    movsd xmm0, [r15]
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .to_dev_fail
    mov rsi, rax            # rsi = source handle entry

    # target_device (default 1 = CUDA)
    mov r12, 1
    movsd xmm0, [r15 - 16]
    cvttsd2si rcx, xmm0
    cmp rcx, 1
    jle 1f
    movsd xmm0, [r15 + 8]
    cvttsd2si r12, xmm0     # r12 = target_device (0 or 1)
1:
    mov r10, [rsi + 32]     # current is_device
    cmp r10, r12
    je .to_dev_same         # Zero-copy optimization!

    # Target is CUDA (r12 == 1), Current is CPU (r10 == 0)
    test r12, r12
    jz .to_dev_to_cpu

    # CPU -> CUDA migration
    cmp dword ptr [rip + gpu_has_cuda], 1
    jne .to_dev_same        # Fallback to current if CUDA unavailable

    mov rbx, [rsi + 24]     # size_bytes
    lea rdi, [rbp - 48]
    mov rcx, rdi
    mov rdx, rbx
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .to_dev_fail
    mov rdi, [rbp - 48]     # dst VRAM

    mov rcx, rdi            # dst
    mov rdx, [rsi + 16]     # src host
    mov r8,  rbx            # size_bytes
    call [rip + gpu_p_cuMemcpyHtoD]
    test eax, eax
    jnz .to_dev_fail

    # Register new CUDA tensor handle
    mov rcx, 2              # type = tensor
    mov rdx, rdi            # d_ptr
    mov r8,  rbx            # size_bytes
    mov r9,  1              # is_device = 1
    mov r10d, [rsi + 40]
    mov [rsp + 32], r10d
    mov r11d, [rsi + 44]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    cvtsi2sd xmm0, rax
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.to_dev_to_cpu:
    # CUDA -> CPU migration
    mov rbx, [rsi + 24]     # size_bytes
    mov rcx, rbx
    call malloc
    test rax, rax
    jz .to_dev_fail
    mov rdi, rax            # dst host

    mov rcx, rdi            # dst host
    mov rdx, [rsi + 16]     # src VRAM
    mov r8,  rbx            # size_bytes
    call [rip + gpu_p_cuMemcpyDtoH]
    test eax, eax
    jnz .to_dev_fail

    # Register new CPU tensor handle
    mov rcx, 2              # type = tensor
    mov rdx, rdi            # host ptr
    mov r8,  rbx            # size_bytes
    mov r9,  0              # is_device = 0
    mov r10d, [rsi + 40]
    mov [rsp + 32], r10d
    mov r11d, [rsi + 44]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    cvtsi2sd xmm0, rax
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.to_dev_same:
    mov rax, [rsi]          # return current handle_id
    cvtsi2sd xmm0, rax
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.to_dev_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_63:
    # --------------------------------------------------------------------------
    # OP 63: GPU_TENSOR_ARANGE (args = [start, stop, step])
    # Generates a 1D range Tensor [1, N]
    # If 1 arg:  start=0, stop=arg0, step=1
    # If 2 args: start=arg0, stop=arg1, step=1
    # If 3 args: start=arg0, stop=arg1, step=arg2
    # --------------------------------------------------------------------------
    cmp r14, 63
    jne .check_op_64
    test r15, r15
    jz .arange_fail

    # Default values:
    xorps xmm3, xmm3        # start = 0.0
    mov rax, 1
    cvtsi2sd xmm4, rax      # step = 1.0

    movsd xmm0, [r15 - 16]
    cvttsd2si rcx, xmm0     # arg count
    cmp rcx, 1
    jl .arange_fail
    jg .arange_multi_arg

    # 1 arg: stop = arg0
    movsd xmm5, [r15]       # stop
    jmp .arange_calc_n

.arange_multi_arg:
    movsd xmm3, [r15]       # start
    movsd xmm5, [r15 + 8]   # stop
    cmp rcx, 2
    jle .arange_calc_n
    movsd xmm4, [r15 + 16]  # step

.arange_calc_n:
    # Calculate count: N = (stop - start) / step
    movsd xmm0, xmm5
    subsd xmm0, xmm3        # stop - start
    divsd xmm0, xmm4        # (stop - start) / step
    cvttsd2si rbx, xmm0     # rbx = N
    test rbx, rbx
    jle .arange_fail
    cmp rbx, 10000000       # safety cap (10M elements)
    jg .arange_fail

    # Allocate host staging buffer: rbx * 4 bytes
    mov [rbp - 56], rbx     # N
    movsd [rbp - 64], xmm3  # start
    movsd [rbp - 72], xmm4  # step

    mov rcx, rbx
    shl rcx, 2              # bytes
    mov [rbp - 80], rcx     # size_bytes
    call malloc
    test rax, rax
    jz .arange_fail
    mov rdi, rax            # rdi = host buffer

    # Fill sequential values
    mov rbx, [rbp - 56]     # N
    movsd xmm3, [rbp - 64]  # cur_val = start
    movsd xmm4, [rbp - 72]  # step
    xor ecx, ecx            # i = 0
.arange_fill_lp:
    cmp rcx, rbx
    jge .arange_fill_dn
    cvtsd2ss xmm0, xmm3
    movss [rdi + rcx * 4], xmm0
    addsd xmm3, xmm4
    inc rcx
    jmp .arange_fill_lp
.arange_fill_dn:

    # If CUDA available, upload to VRAM
    xor r14d, r14d          # is_device = 0
    cmp dword ptr [rip + gpu_has_cuda], 1
    jne .arange_register

    lea rax, [rbp - 48]
    mov rcx, rax
    mov rdx, [rbp - 80]     # size_bytes
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .arange_register

    mov rsi, [rbp - 48]     # d_ptr
    mov rcx, rsi            # dst
    mov rdx, rdi            # src host
    mov r8,  [rbp - 80]     # size_bytes
    call [rip + gpu_p_cuMemcpyHtoD]
    test eax, eax
    jnz .arange_register

    # Free host staging buffer
    mov rcx, rdi
    call free
    mov rdi, rsi            # ptr is now VRAM
    mov r14d, 1             # is_device = 1

.arange_register:
    mov rcx, 2              # type = tensor
    mov rdx, rdi            # ptr
    mov r8,  [rbp - 80]     # size_bytes
    mov r9,  r14            # is_device
    mov dword ptr [rsp + 32], 1    # dim0 = 1
    mov r10d, [rbp - 56]
    mov [rsp + 40], r10d           # dim1 = N
    call asm_gpu_register_handle
    cvtsi2sd xmm0, rax
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.arange_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_64:
    # --------------------------------------------------------------------------
    # OP 64: GPU_TENSOR_EYE (args = [N])
    # Generates an identity matrix Tensor [N, N]
    # --------------------------------------------------------------------------
    cmp r14, 64
    jne .check_op_65
    test r15, r15
    jz .eye_fail

    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .eye_from_scalar
    movsd xmm0, [r15]
    jmp .eye_lookup
.eye_from_scalar:
    mov rdx, [rbp - 24]
    movsd xmm0, [r13 + rdx * 8]
.eye_lookup:
    cvttsd2si rbx, xmm0     # rbx = N
    test rbx, rbx
    jle .eye_fail
    cmp rbx, 16384          # safety cap (16K x 16K)
    jg .eye_fail

    mov [rbp - 56], rbx     # N
    mov rax, rbx
    imul rax, rbx           # total elements = N * N
    shl rax, 2              # size_bytes = N * N * 4
    mov [rbp - 64], rax     # size_bytes

    # Allocate host buffer
    mov rcx, rax
    call malloc
    test rax, rax
    jz .eye_fail
    mov rdi, rax            # rdi = host buffer

    # Zero entire host buffer
    mov rcx, [rbp - 64]
    shr rcx, 2              # dwords
    xor eax, eax
    mov r8, rdi
1:
    test rcx, rcx
    jz 2f
    mov dword ptr [r8], eax
    add r8, 4
    dec rcx
    jmp 1b
2:
    # Set diagonals: p[i * N + i] = 1.0f
    mov rbx, [rbp - 56]     # N
    mov eax, 0x3F800000     # 1.0f in IEEE 754
    xor ecx, ecx            # i = 0
.eye_diag_lp:
    cmp rcx, rbx
    jge .eye_diag_dn
    mov r8, rcx
    imul r8, rbx
    add r8, rcx             # index = i * N + i
    mov dword ptr [rdi + r8 * 4], eax
    inc rcx
    jmp .eye_diag_lp
.eye_diag_dn:

    # If CUDA available, upload to VRAM
    xor r14d, r14d          # is_device = 0
    cmp dword ptr [rip + gpu_has_cuda], 1
    jne .eye_register

    lea rax, [rbp - 48]
    mov rcx, rax
    mov rdx, [rbp - 64]     # size_bytes
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .eye_register

    mov rsi, [rbp - 48]     # d_ptr
    mov rcx, rsi            # dst
    mov rdx, rdi            # src host
    mov r8,  [rbp - 64]     # size_bytes
    call [rip + gpu_p_cuMemcpyHtoD]
    test eax, eax
    jnz .eye_register

    # Free host staging buffer
    mov rcx, rdi
    call free
    mov rdi, rsi            # ptr is VRAM
    mov r14d, 1             # is_device = 1

.eye_register:
    mov rcx, 2              # type = tensor
    mov rdx, rdi            # ptr
    mov r8,  [rbp - 64]     # size_bytes
    mov r9,  r14            # is_device
    mov r10d, [rbp - 56]
    mov [rsp + 32], r10d    # dim0 = N
    mov [rsp + 40], r10d    # dim1 = N
    call asm_gpu_register_handle
    cvtsi2sd xmm0, rax
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.eye_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_65:
    # --------------------------------------------------------------------------
    # OP 65: GPU_PARSE_FLOAT (args[0] = string or scalar)
    # --------------------------------------------------------------------------
    cmp r14, 65
    jne .check_op_66
    test r15, r15
    jz .parse_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .parse_from_scalar
    mov rsi, [r15]          # string ptr
    jmp .parse_check_val
.parse_from_scalar:
    mov rdx, [rbp - 24]
    mov rsi, [r13 + rdx * 8]
.parse_check_val:
    test rsi, rsi
    jz .parse_fail
    mov rcx, rsi
.parse_skip_ws:
    mov al, byte ptr [rcx]
    cmp al, ' '
    je 1f
    cmp al, 9          # '\t'
    je 1f
    cmp al, 13         # '\r'
    je 1f
    cmp al, 10         # '\n'
    je 1f
    cmp al, 'n'        # skip 'n' from literal \n split
    je 1f
    jmp .parse_do_atof
1:
    inc rcx
    jmp .parse_skip_ws
.parse_do_atof:
    call atof
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done
.parse_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_66:
    # --------------------------------------------------------------------------
    # OP 66: GPU_TENSOR_LINSPACE (args = [start, stop, num])
    # --------------------------------------------------------------------------
    cmp r14, 66
    jne .check_op_67
    test r15, r15
    jz .linspace_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .linspace_fail

    movsd xmm3, [r15]       # start
    movsd xmm5, [r15 + 8]   # stop
    movsd xmm0, [r15 + 16]  # num
    cvttsd2si rbx, xmm0     # rbx = num
    test rbx, rbx
    jle .linspace_fail
    cmp rbx, 10000000
    jg .linspace_fail

    mov [rbp - 56], rbx     # num
    movsd [rbp - 64], xmm3  # start
    movsd [rbp - 72], xmm5  # stop

    # step = (num > 1) ? (stop - start) / (num - 1) : 0.0
    xorps xmm4, xmm4
    cmp rbx, 1
    jle 1f
    mov rax, rbx
    dec rax
    cvtsi2sd xmm1, rax
    movsd xmm0, xmm5
    subsd xmm0, xmm3
    divsd xmm0, xmm1
    movaps xmm4, xmm0
1:
    movsd [rbp - 88], xmm4  # step

    # Allocate host buffer
    mov rcx, rbx
    shl rcx, 2
    mov [rbp - 80], rcx     # size_bytes
    call malloc
    test rax, rax
    jz .linspace_fail
    mov rdi, rax

    # Fill
    mov rbx, [rbp - 56]
    movsd xmm3, [rbp - 64]
    movsd xmm4, [rbp - 88]
    xor ecx, ecx
.linspace_fill_lp:
    cmp rcx, rbx
    jge .linspace_fill_dn
    cvtsd2ss xmm0, xmm3
    movss [rdi + rcx * 4], xmm0
    addsd xmm3, xmm4
    inc rcx
    jmp .linspace_fill_lp
.linspace_fill_dn:

    # If CUDA, upload
    xor r14d, r14d
    cmp dword ptr [rip + gpu_has_cuda], 1
    jne .linspace_register

    lea rax, [rbp - 48]
    mov rcx, rax
    mov rdx, [rbp - 80]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .linspace_register

    mov rsi, [rbp - 48]
    mov rcx, rsi
    mov rdx, rdi
    mov r8, [rbp - 80]
    call [rip + gpu_p_cuMemcpyHtoD]
    test eax, eax
    jnz .linspace_register

    mov rcx, rdi
    call free
    mov rdi, rsi
    mov r14d, 1

.linspace_register:
    mov rcx, 2
    mov rdx, rdi
    mov r8, [rbp - 80]
    mov r9, r14
    mov dword ptr [rsp + 32], 1
    mov r10d, [rbp - 56]
    mov [rsp + 40], r10d
    call asm_gpu_register_handle
    cvtsi2sd xmm0, rax
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.linspace_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_67:
    # --------------------------------------------------------------------------
    # OP 67: GPU_TENSOR_RANDN (args = [rows, cols, seed])
    # --------------------------------------------------------------------------
    cmp r14, 67
    jne .check_op_68
    test r15, r15
    jz .randn_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .randn_fail

    movsd xmm0, [r15]       # rows
    cvttsd2si r10, xmm0
    movsd xmm1, [r15 + 8]   # cols
    cvttsd2si r11, xmm1
    test r10, r10
    jle .randn_fail
    test r11, r11
    jle .randn_fail

    mov [rbp - 56], r10d    # dim0
    mov [rbp - 60], r11d    # dim1

    mov rax, r10
    imul rax, r11
    mov [rbp - 68], rax     # total
    shl rax, 2
    mov [rbp - 80], rax     # size_bytes

    # Allocate host buffer
    mov rcx, rax
    call malloc
    test rax, rax
    jz .randn_fail
    mov rdi, rax

    # Seed
    mov r9, 0x123456789ABCDEF1
    movsd xmm0, [r15 - 16]
    cvttsd2si rcx, xmm0
    cmp rcx, 2
    jle 1f
    movsd xmm0, [r15 + 16]
    cvttsd2si r9, xmm0
1:
    test r9, r9
    jnz 2f
    mov r9, 0x987654321
2:
    # Fill with pseudo-random normal weights (mean 0, std ~ 0.1)
    mov r8, [rbp - 68]      # count
    xor ecx, ecx            # i = 0
    mov r11, 0x5851F42D4C957F2D
    mov r12, 0x14057B7EF767814F
.randn_fill_lp:
    cmp rcx, r8
    jge .randn_fill_dn

    # Step LCG 4 times and sum lower 16 bits
    mov rax, r9
    imul rax, r11
    add rax, r12
    mov r9, rax
    mov edx, eax
    and edx, 0xFFFF

    mov rax, r9
    imul rax, r11
    add rax, r12
    mov r9, rax
    mov ebx, eax
    and ebx, 0xFFFF
    add edx, ebx

    mov rax, r9
    imul rax, r11
    add rax, r12
    mov r9, rax
    mov ebx, eax
    and ebx, 0xFFFF
    add edx, ebx

    mov rax, r9
    imul rax, r11
    add rax, r12
    mov r9, rax
    mov ebx, eax
    and ebx, 0xFFFF
    add edx, ebx

    # Center: sub 131070
    sub edx, 131070
    cvtsi2ss xmm0, edx
    mov eax, 0x354CC8D7     # 7.62939e-7f
    movd xmm1, eax
    mulss xmm0, xmm1
    movss [rdi + rcx * 4], xmm0

    inc rcx
    jmp .randn_fill_lp
.randn_fill_dn:

    # Upload if CUDA
    xor r14d, r14d
    cmp dword ptr [rip + gpu_has_cuda], 1
    jne .randn_register

    lea rax, [rbp - 48]
    mov rcx, rax
    mov rdx, [rbp - 80]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .randn_register

    mov rsi, [rbp - 48]
    mov rcx, rsi
    mov rdx, rdi
    mov r8, [rbp - 80]
    call [rip + gpu_p_cuMemcpyHtoD]
    test eax, eax
    jnz .randn_register

    mov rcx, rdi
    call free
    mov rdi, rsi
    mov r14d, 1

.randn_register:
    mov rcx, 2
    mov rdx, rdi
    mov r8, [rbp - 80]
    mov r9, r14
    mov r10d, [rbp - 56]
    mov [rsp + 32], r10d
    mov r11d, [rbp - 60]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    cvtsi2sd xmm0, rax
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.randn_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_68:
    # --------------------------------------------------------------------------
    # OP 68: GPU_TENSOR_CLIP (args = [tensor, min_val, max_val])
    # --------------------------------------------------------------------------
    cmp r14, 68
    jne .check_op_69
    test r15, r15
    jz .clip_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .clip_fail

    movsd xmm0, [r15]       # handle
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .clip_fail
    mov rsi, rax            # rsi = src handle

    movsd xmm1, [r15 + 8]   # min_val
    cvtsd2ss xmm3, xmm1
    movsd xmm2, [r15 + 16]  # max_val
    cvtsd2ss xmm4, xmm2

    mov [rbp - 56], rsi     # save src handle
    movss [rbp - 64], xmm3  # min_val float
    movss [rbp - 68], xmm4  # max_val float

    mov rbx, [rsi + 24]     # size_bytes
    mov [rbp - 80], rbx

    # Allocate host buffer
    mov rcx, rbx
    call malloc
    test rax, rax
    jz .clip_fail
    mov rdi, rax

    # Copy src data to host buffer
    mov rsi, [rbp - 56]
    cmp dword ptr [rsi + 32], 1
    jne 1f
    # From CUDA VRAM
    mov rcx, rdi
    mov rdx, [rsi + 16]
    mov r8, [rbp - 80]
    call [rip + gpu_p_cuMemcpyDtoH]
    test eax, eax
    jnz .clip_fail
    jmp 2f
1:
    # From Host RAM
    mov rcx, rdi
    mov rdx, [rsi + 16]
    mov r8, [rbp - 80]
    call memcpy
2:
    # Apply clamp: min(max(val, min_val), max_val)
    mov r8, [rbp - 80]
    shr r8, 2               # element count
    movss xmm3, [rbp - 64]  # min
    movss xmm4, [rbp - 68]  # max
    xor ecx, ecx
.clip_lp:
    cmp rcx, r8
    jge .clip_dn
    movss xmm0, [rdi + rcx * 4]
    maxss xmm0, xmm3
    minss xmm0, xmm4
    movss [rdi + rcx * 4], xmm0
    inc rcx
    jmp .clip_lp
.clip_dn:

    # Upload if CUDA
    mov rsi, [rbp - 56]
    xor r14d, r14d
    cmp dword ptr [rsi + 32], 1
    jne .clip_register

    lea rax, [rbp - 48]
    mov rcx, rax
    mov rdx, [rbp - 80]
    call asm_gpu_alloc_vram
    test eax, eax
    jnz .clip_register

    mov rbx, [rbp - 48]
    mov rcx, rbx
    mov rdx, rdi
    mov r8, [rbp - 80]
    call [rip + gpu_p_cuMemcpyHtoD]
    test eax, eax
    jnz .clip_register

    mov rcx, rdi
    call free
    mov rdi, rbx
    mov r14d, 1

.clip_register:
    mov rsi, [rbp - 56]
    mov rcx, 2
    mov rdx, rdi
    mov r8, [rbp - 80]
    mov r9, r14
    mov r10d, [rsi + 40]
    mov [rsp + 32], r10d
    mov r11d, [rsi + 44]
    mov [rsp + 40], r11d
    call asm_gpu_register_handle
    cvtsi2sd xmm0, rax
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.clip_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_69:
    # --------------------------------------------------------------------------
    # OP 69: GPU_APPLY_GRAD (args = [param_tensor, grad_tensor, lr])
    # In-place parameter update: param[i] -= lr * grad[i]
    # --------------------------------------------------------------------------
    cmp r14, 69
    jne .check_op_fallback
    test r15, r15
    jz .grad_fail
    mov rcx, r15
    call asm_gpu_is_nexus_array
    jne .grad_fail

    movsd xmm0, [r15]       # param_handle
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .grad_fail
    mov rsi, rax            # rsi = param handle

    movsd xmm0, [r15 + 8]   # grad_handle
    cvttsd2si rcx, xmm0
    call asm_gpu_lookup_handle
    test rax, rax
    jz .grad_fail
    mov rbx, rax            # rbx = grad handle

    movsd xmm1, [r15 + 16]  # lr
    cvtsd2ss xmm2, xmm1
    movss [rbp - 64], xmm2  # lr float

    mov r8, [rsi + 24]      # size_bytes
    mov [rbp - 72], r8
    mov [rbp - 80], rsi     # param
    mov [rbp - 88], rbx     # grad

    # Allocate host buffers for param and grad
    mov rcx, r8
    call malloc
    test rax, rax
    jz .grad_fail
    mov rdi, rax            # rdi = host param buffer
    mov [rbp - 96], rdi

    mov rcx, [rbp - 72]
    call malloc
    test rax, rax
    jz .grad_fail_free_p
    mov r12, rax            # r12 = host grad buffer
    mov [rbp - 104], r12

    # Download param
    mov rsi, [rbp - 80]
    cmp dword ptr [rsi + 32], 1
    jne 1f
    mov rcx, [rbp - 96]
    mov rdx, [rsi + 16]
    mov r8, [rbp - 72]
    call [rip + gpu_p_cuMemcpyDtoH]
    jmp 2f
1:
    mov rcx, [rbp - 96]
    mov rdx, [rsi + 16]
    mov r8, [rbp - 72]
    call memcpy
2:
    # Download grad
    mov rbx, [rbp - 88]
    cmp dword ptr [rbx + 32], 1
    jne 3f
    mov rcx, [rbp - 104]
    mov rdx, [rbx + 16]
    mov r8, [rbp - 72]
    call [rip + gpu_p_cuMemcpyDtoH]
    jmp 4f
3:
    mov rcx, [rbp - 104]
    mov rdx, [rbx + 16]
    mov r8, [rbp - 72]
    call memcpy
4:
    # Vector update: param[i] -= lr * grad[i]
    mov r8, [rbp - 72]
    shr r8, 2               # element count
    mov rdi, [rbp - 96]     # param ptr
    mov r12, [rbp - 104]    # grad ptr
    movss xmm2, [rbp - 64]  # lr
    xor ecx, ecx
.grad_lp:
    cmp rcx, r8
    jge .grad_dn
    movss xmm0, [rdi + rcx * 4]
    movss xmm1, [r12 + rcx * 4]
    mulss xmm1, xmm2
    subss xmm0, xmm1
    movss [rdi + rcx * 4], xmm0
    inc rcx
    jmp .grad_lp
.grad_dn:

    # Upload updated param back to VRAM or Host RAM
    mov rsi, [rbp - 80]
    cmp dword ptr [rsi + 32], 1
    jne 5f
    mov rcx, [rsi + 16]     # dst VRAM
    mov rdx, [rbp - 96]     # src host
    mov r8, [rbp - 72]
    call [rip + gpu_p_cuMemcpyHtoD]
    jmp 6f
5:
    mov rcx, [rsi + 16]     # dst host
    mov rdx, [rbp - 96]     # src host
    mov r8, [rbp - 72]
    call memcpy
6:
    # Free temporary staging buffers
    mov rcx, [rbp - 104]
    call free
    mov rcx, [rbp - 96]
    call free

    # Return 1.0 (success)
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    mov rax, 1
    cvtsi2sd xmm0, rax
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.grad_fail_free_p:
    mov rcx, [rbp - 96]
    call free
.grad_fail:
    mov r13, [rbp - 32]
    mov rdx, [rbp - 8]
    xorpd xmm0, xmm0
    movsd [r13 + rdx * 8], xmm0
    jmp .dispatch_done

.check_op_fallback:
    xorpd xmm0, xmm0
    mov rdx, [rbp - 8]
    movsd [r13 + rdx * 8], xmm0

.dispatch_done:
    mov rsp, rbp
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rsi
    pop rbx
    pop rbp
    ret
