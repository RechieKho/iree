// Copyright 2023 The IREE Authors
//
// Licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

#ifndef IREE_CODEGEN_LLVMGPU_PASSES
#define IREE_CODEGEN_LLVMGPU_PASSES

include "mlir/Pass/PassBase.td"

//------------------------------------------------------------------------------
// LLVMGPU Passes (keep alphabetical)
//------------------------------------------------------------------------------

def AMDGPUPrepareForChainedMatmul :
    InterfacePass<"iree-amdgpu-prepare-chained-matmul", "mlir::FunctionOpInterface"> {
  let summary = "Pass to swap operands and transpose accumulator and result";
  let constructor = "mlir::iree_compiler::createAMDGPUPrepareForChainedMatmulPass()";
}

// TODO: Bring the argument in line with the names used elsewhere.
def ConvertToNVVM :
    Pass<"iree-convert-to-nvvm", "ModuleOp"> {
  let summary = "Perform final conversion from builtin/GPU/HAL/standard dialect to LLVM "
    "and NVVM dialects";
  let constructor = "mlir::iree_compiler::createConvertToNVVMPass()";
}

// TODO: Bring the argument in line with the names used elsewhere.
def ConvertToROCDL :
    Pass<"iree-convert-to-rocdl", "ModuleOp"> {
  let summary = "Perform final conversion from builtin/GPU/HAL/standard dialect to LLVM "
    "and ROCDL dialects";
  let constructor = "mlir::iree_compiler::createConvertToROCDLPass()";
}

def ExtractAddressComputationGPU: Pass<"extract-address-computation-gpu"> {
  let summary = "Extract address computations from memory accesses";
  let description = [{
     This pass is similar to `extract-address-computation` except it also
     supports memory accesses that are specific to GPUs.
  }];
  let constructor = "mlir::iree_compiler::createExtractAddressComputationGPUPass()";
  let dependentDialects = [
      "memref::MemRefDialect", "nvgpu::NVGPUDialect", "affine::AffineDialect"
  ];
}

def LLVMGPUCastAddressSpaceFunction :
    Pass<"iree-llvmgpu-cast-address-space-function", "ModuleOp"> {
  let summary = "Cast address space to generic in CallOp and FuncOp";
  let constructor = "mlir::iree_compiler::createLLVMGPUCastAddressSpaceFunction()";
}

def LLVMGPUCastTypeToFitMMA : InterfacePass<"iree-llvmgpu-cast-type-to-fit-mma",
                                            "mlir::FunctionOpInterface"> {
  let summary = "Perform type extension/truncation over vector.contract types "
                "to target GPU MMA intrinsics";
  let constructor = "mlir::iree_compiler::createLLVMGPUCastTypeToFitMMAPass()";
}

def LLVMGPUConfigureVectorLayouts :
    InterfacePass<"iree-llvmgpu-configure-vector-layouts", "mlir::FunctionOpInterface"> {
  let summary = "Pass to set layouts for vector distribution";
  let constructor = "mlir::iree_compiler::createLLVMGPUConfigureVectorLayouts()";
}

def LLVMGPULowerExecutableTarget :
    InterfacePass<"iree-llvmgpu-lower-executable-target", "mlir::FunctionOpInterface"> {
  let summary = "Perform lowering of executable target using one of the IREE::HAL::DispatchLoweringPassPipeline";
  let constructor = "mlir::iree_compiler::createLLVMGPULowerExecutableTargetPass()";
}

def LLVMGPUPackSharedMemoryAlloc :
    InterfacePass<"iree-llvmgpu-pack-shared-memory-alloc", "mlir::FunctionOpInterface"> {
  let summary = "Pass pack shared memory allocation in order to reduce memory usage.";
  let constructor = "mlir::iree_compiler::createLLVMGPUPackSharedMemoryAlloc()";
}

def LLVMGPUPrefetchSharedMemory :
    InterfacePass<"iree-llvmgpu-prefetch-shared-memory", "mlir::FunctionOpInterface"> {
  let summary = "Rotate scf.for loops to prefetch shared memory with distance 1";
  let constructor = "mlir::iree_compiler::createLLVMGPUPrefetchSharedMemoryPass()";
}

def LLVMGPUPromoteMatmulToFitMMA :
    InterfacePass<"iree-llvmgpu-promote-matmul-to-fit-mma", "mlir::FunctionOpInterface"> {
  let summary = "Pass to promote contraction ops to fit mma shapes";
  let constructor = "mlir::iree_compiler::createLLVMGPUPromoteMatmulToFitMMAPass()";
  let options = [
    Option<"targetDimensions", "target-dimensions", "mlir::iree_compiler::LLVMGPUMatmulPadOption",
           /*default=*/"mlir::iree_compiler::LLVMGPUMatmulPadOption::ParallelDims",
           "Select the strategy to control how multi_reduction is lowered.",
           [{::llvm::cl::values(
            clEnumValN(mlir::iree_compiler::LLVMGPUMatmulPadOption::ParallelDims,
                       "parallel",
                       "Pad all the parallel dims for contraction ops."),
            clEnumValN(mlir::iree_compiler::LLVMGPUMatmulPadOption::ReductionDims,
                       "reduction",
                       "Pad all the reduction dims for contraction ops.")
        )}]>
  ];
}

def LLVMGPUSelectLoweringStrategy :
    Pass<"iree-llvmgpu-select-lowering-strategy", "ModuleOp"> {
  let summary = "Select a IREE::HAL::DispatchLoweringPassPipeline for lowering the target variant";
  let constructor = "mlir::iree_compiler::createLLVMGPUSelectLoweringStrategyPass()";
}

def LLVMGPUTensorCoreVectorization :
    InterfacePass<"iree-llvmgpu-tensorcore-vectorization", "mlir::FunctionOpInterface"> {
  let summary = "Pass to convert linalg into Vector and transform it to a form that can be lowered to GPU MMA ops";
  let constructor = "mlir::iree_compiler::createLLVMGPUTensorCoreVectorizationPass()";
}

def LLVMGPUTensorPad :
    InterfacePass<"iree-llvmgpu-tensor-pad", "mlir::FunctionOpInterface"> {
  let summary = "Pass to pad out tensors up to static dimensions.";
  let constructor = "mlir::iree_compiler::createLLVMGPUTensorPadPass()";
}

def LLVMGPUTileAndDistribute :
    InterfacePass<"iree-llvmgpu-tile-and-distribute", "mlir::FunctionOpInterface"> {
  let summary = "Pass to tile and distribute linalg ops within a workgroup.";
  let constructor = "mlir::iree_compiler::createLLVMGPUTileAndDistribute()";
}

def LLVMGPUVectorDistribute :
    InterfacePass<"iree-llvmgpu-vector-distribute", "mlir::FunctionOpInterface"> {
  let summary = "Pass to distribute vectorized functions.";
  let constructor = "mlir::iree_compiler::createLLVMGPUVectorDistribute()";
}

def LLVMGPUVectorLowering :
    InterfacePass<"iree-llvmgpu-vector-lowering", "mlir::FunctionOpInterface"> {
  let summary = "Pass to lower Vector ops before conversion to LLVM.";
  let constructor = "mlir::iree_compiler::createLLVMGPUVectorLoweringPass()";
}

def LLVMGPUVectorToGPU :
    InterfacePass<"iree-llvmgpu-vector-to-gpu", "mlir::FunctionOpInterface"> {
  let summary = "Pass to convert vector to gpu.";
  let constructor = "mlir::iree_compiler::createLLVMGPUVectorToGPU()";
}

//------------------------------------------------------------------------------
// Test Passes
//------------------------------------------------------------------------------

def TestLLVMGPUScalarizeMathOp :
    Pass<"iree-test-llvmgpu-legalize-ops", "ModuleOp"> {
  let summary = "Test pass for several legalization patterns.";
  let constructor = "mlir::iree_compiler::createTestLLVMGPULegalizePass()";
}

#endif // IREE_CODEGEN_LLVMGPU_PASSES
