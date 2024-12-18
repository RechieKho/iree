// RUN: iree-opt --split-input-file --iree-gpu-test-target=gfx942 --pass-pipeline='builtin.module(iree-llvmgpu-select-lowering-strategy)' %s | FileCheck %s

func.func @argmax_2d_f32i64(%arg0 : tensor<1x?xf32>) -> tensor<1xi64> attributes {
  hal.executable.target = #hal.executable.target<"rocm", "rocm-hsaco-fb", {ukernels = "all"}>
} {
  %c0_i64 = arith.constant 0 : i64
  %cst = arith.constant 0xFF800000 : f32
  %0 = tensor.empty() : tensor<1xi64>
  %1 = linalg.fill ins(%c0_i64 : i64) outs(%0 : tensor<1xi64>) -> tensor<1xi64>
  %2 = tensor.empty() : tensor<1xf32>
  %3 = linalg.fill ins(%cst : f32) outs(%2 : tensor<1xf32>) -> tensor<1xf32>
  %4:2 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0)>], iterator_types = ["parallel", "reduction"]} ins(%arg0 : tensor<1x?xf32>) outs(%3, %1 : tensor<1xf32>, tensor<1xi64>) {
  ^bb0(%in: f32, %out: f32, %out_0: i64):
    %5 = linalg.index 1 : index
    %6 = arith.index_cast %5 : index to i64
    %7 = arith.maximumf %in, %out : f32
    %8 = arith.cmpf ogt, %in, %out : f32
    %9 = arith.select %8, %6, %out_0 : i64
    linalg.yield %7, %9 : f32, i64
  } -> (tensor<1xf32>, tensor<1xi64>)
  return %4#1 : tensor<1xi64>
}

// CHECK-LABEL: func @argmax_2d_f32i64(
//       CHECK: linalg.generic
//  CHECK-SAME: hal.executable.objects = [
//  CEHCK-SAME:   #hal.executable.object<{path = "iree_uk_amdgpu_argmax_f32i64.gfx942.bc", data = dense_resource<iree_uk_amdgpu_argmax_f32i64.gfx942.bc> : vector<{{[0-9]+}}xi8>}>]
//  CHECK-SAME:   #iree_gpu.lowering_config<{{.*}}ukernel = #iree_gpu.ukernel_config<name = "iree_uk_amdgpu_argmax_f32i64", def_attrs = {vm.import.module = "rocm"}>

// -----

func.func @argmax_4d_unit_parallel_f32i64(%arg0 : tensor<1x1x1x?xf32>) -> tensor<1x1x1xi64> attributes {
  hal.executable.target = #hal.executable.target<"rocm", "rocm-hsaco-fb", {ukernels = "all"}>
} {
  %c0_i64 = arith.constant 0 : i64
  %cst = arith.constant 0xFF800000 : f32
  %0 = tensor.empty() : tensor<1x1x1xi64>
  %1 = linalg.fill ins(%c0_i64 : i64) outs(%0 : tensor<1x1x1xi64>) -> tensor<1x1x1xi64>
  %2 = tensor.empty() : tensor<1x1x1xf32>
  %3 = linalg.fill ins(%cst : f32) outs(%2 : tensor<1x1x1xf32>) -> tensor<1x1x1xf32>
  %4:2 = linalg.generic {indexing_maps = [affine_map<(d0, d1, d2, d3) -> (d0, d1, d2, d3)>, affine_map<(d0, d1, d2, d3) -> (d0, d1, d2)>, affine_map<(d0, d1, d2, d3) -> (d0, d1, d2)>], iterator_types = ["parallel", "parallel", "parallel", "reduction"]} ins(%arg0 : tensor<1x1x1x?xf32>) outs(%3, %1 : tensor<1x1x1xf32>, tensor<1x1x1xi64>) {
  ^bb0(%in: f32, %out: f32, %out_0: i64):
    %5 = linalg.index 1 : index
    %6 = arith.index_cast %5 : index to i64
    %7 = arith.maximumf %in, %out : f32
    %8 = arith.cmpf ogt, %in, %out : f32
    %9 = arith.select %8, %6, %out_0 : i64
    linalg.yield %7, %9 : f32, i64
  } -> (tensor<1x1x1xf32>, tensor<1x1x1xi64>)
  return %4#1 : tensor<1x1x1xi64>
}

// CHECK-LABEL: func @argmax_4d_unit_parallel_f32i64(
//       CHECK: linalg.generic
//  CHECK-SAME: hal.executable.objects = [
//  CEHCK-SAME:   #hal.executable.object<{path = "iree_uk_amdgpu_argmax_f32i64.gfx942.bc", data = dense_resource<iree_uk_amdgpu_argmax_f32i64.gfx942.bc> : vector<{{[0-9]+}}xi8>}>]
//  CHECK-SAME:   #iree_gpu.lowering_config<{{.*}}ukernel = #iree_gpu.ukernel_config<name = "iree_uk_amdgpu_argmax_f32i64", def_attrs = {vm.import.module = "rocm"}>

// -----

func.func @argmax_none_ukernel_enabled(%arg0 : tensor<1x?xf32>) -> tensor<1xi64> attributes {
  hal.executable.target = #hal.executable.target<"rocm", "rocm-hsaco-fb", {ukernels = "none"}>
} {
  %c0_i64 = arith.constant 0 : i64
  %cst = arith.constant 0xFF800000 : f32
  %0 = tensor.empty() : tensor<1xi64>
  %1 = linalg.fill ins(%c0_i64 : i64) outs(%0 : tensor<1xi64>) -> tensor<1xi64>
  %2 = tensor.empty() : tensor<1xf32>
  %3 = linalg.fill ins(%cst : f32) outs(%2 : tensor<1xf32>) -> tensor<1xf32>
  %4:2 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0)>], iterator_types = ["parallel", "reduction"]} ins(%arg0 : tensor<1x?xf32>) outs(%3, %1 : tensor<1xf32>, tensor<1xi64>) {
  ^bb0(%in: f32, %out: f32, %out_0: i64):
    %5 = linalg.index 1 : index
    %6 = arith.index_cast %5 : index to i64
    %7 = arith.maximumf %in, %out : f32
    %8 = arith.cmpf ogt, %in, %out : f32
    %9 = arith.select %8, %6, %out_0 : i64
    linalg.yield %7, %9 : f32, i64
  } -> (tensor<1xf32>, tensor<1xi64>)
  return %4#1 : tensor<1xi64>
}

// CHECK-LABEL: func @argmax_none_ukernel_enabled(
//       CHECK: linalg.generic
//   CHECK-NOT: hal.executable.objects
//   CHECK-NOT: iree_gpu.ukernel_config

// -----

func.func @argmax_only_argmax_ukernel_enabled(%arg0 : tensor<1x?xf32>) -> tensor<1xi64> attributes {
  hal.executable.target = #hal.executable.target<"rocm", "rocm-hsaco-fb", {ukernels = "argmax"}>
} {
  %c0_i64 = arith.constant 0 : i64
  %cst = arith.constant 0xFF800000 : f32
  %0 = tensor.empty() : tensor<1xi64>
  %1 = linalg.fill ins(%c0_i64 : i64) outs(%0 : tensor<1xi64>) -> tensor<1xi64>
  %2 = tensor.empty() : tensor<1xf32>
  %3 = linalg.fill ins(%cst : f32) outs(%2 : tensor<1xf32>) -> tensor<1xf32>
  %4:2 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0)>], iterator_types = ["parallel", "reduction"]} ins(%arg0 : tensor<1x?xf32>) outs(%3, %1 : tensor<1xf32>, tensor<1xi64>) {
  ^bb0(%in: f32, %out: f32, %out_0: i64):
    %5 = linalg.index 1 : index
    %6 = arith.index_cast %5 : index to i64
    %7 = arith.maximumf %in, %out : f32
    %8 = arith.cmpf ogt, %in, %out : f32
    %9 = arith.select %8, %6, %out_0 : i64
    linalg.yield %7, %9 : f32, i64
  } -> (tensor<1xf32>, tensor<1xi64>)
  return %4#1 : tensor<1xi64>
}

// CHECK-LABEL: func @argmax_only_argmax_ukernel_enabled(
//       CHECK: linalg.generic
//  CHECK-SAME: hal.executable.objects = [
//  CHECK-SAME:   #hal.executable.object<{path = "iree_uk_amdgpu_argmax_f32i64.gfx942.bc", data = dense_resource<iree_uk_amdgpu_argmax_f32i64.gfx942.bc> : vector<{{[0-9]+}}xi8>}>]
//  CHECK-SAME:   #iree_gpu.lowering_config<{{.*}}ukernel = #iree_gpu.ukernel_config<name = "iree_uk_amdgpu_argmax_f32i64", def_attrs = {vm.import.module = "rocm"}>

// -----

func.func @argmax_only_foo_argmax_bar_ukernel_enabled(%arg0 : tensor<1x?xf32>) -> tensor<1xi64> attributes {
  hal.executable.target = #hal.executable.target<"rocm", "rocm-hsaco-fb", {ukernels = "foo,argmax,bar"}>
} {
  %c0_i64 = arith.constant 0 : i64
  %cst = arith.constant 0xFF800000 : f32
  %0 = tensor.empty() : tensor<1xi64>
  %1 = linalg.fill ins(%c0_i64 : i64) outs(%0 : tensor<1xi64>) -> tensor<1xi64>
  %2 = tensor.empty() : tensor<1xf32>
  %3 = linalg.fill ins(%cst : f32) outs(%2 : tensor<1xf32>) -> tensor<1xf32>
  %4:2 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0)>], iterator_types = ["parallel", "reduction"]} ins(%arg0 : tensor<1x?xf32>) outs(%3, %1 : tensor<1xf32>, tensor<1xi64>) {
  ^bb0(%in: f32, %out: f32, %out_0: i64):
    %5 = linalg.index 1 : index
    %6 = arith.index_cast %5 : index to i64
    %7 = arith.maximumf %in, %out : f32
    %8 = arith.cmpf ogt, %in, %out : f32
    %9 = arith.select %8, %6, %out_0 : i64
    linalg.yield %7, %9 : f32, i64
  } -> (tensor<1xf32>, tensor<1xi64>)
  return %4#1 : tensor<1xi64>
}

// CHECK-LABEL: func @argmax_only_foo_argmax_bar_ukernel_enabled(
//       CHECK: linalg.generic
//  CHECK-SAME: hal.executable.objects = [
//  CHECK-SAME:   #hal.executable.object<{path = "iree_uk_amdgpu_argmax_f32i64.gfx942.bc", data = dense_resource<iree_uk_amdgpu_argmax_f32i64.gfx942.bc> : vector<{{[0-9]+}}xi8>}>]
//  CHECK-SAME:   #iree_gpu.lowering_config<{{.*}}ukernel = #iree_gpu.ukernel_config<name = "iree_uk_amdgpu_argmax_f32i64", def_attrs = {vm.import.module = "rocm"}>

// -----

func.func @argmax_only_foo_ukernel_enabled(%arg0 : tensor<1x?xf32>) -> tensor<1xi64> attributes {
  hal.executable.target = #hal.executable.target<"rocm", "rocm-hsaco-fb", {ukernels = "foo"}>
} {
  %c0_i64 = arith.constant 0 : i64
  %cst = arith.constant 0xFF800000 : f32
  %0 = tensor.empty() : tensor<1xi64>
  %1 = linalg.fill ins(%c0_i64 : i64) outs(%0 : tensor<1xi64>) -> tensor<1xi64>
  %2 = tensor.empty() : tensor<1xf32>
  %3 = linalg.fill ins(%cst : f32) outs(%2 : tensor<1xf32>) -> tensor<1xf32>
  %4:2 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0)>], iterator_types = ["parallel", "reduction"]} ins(%arg0 : tensor<1x?xf32>) outs(%3, %1 : tensor<1xf32>, tensor<1xi64>) {
  ^bb0(%in: f32, %out: f32, %out_0: i64):
    %5 = linalg.index 1 : index
    %6 = arith.index_cast %5 : index to i64
    %7 = arith.maximumf %in, %out : f32
    %8 = arith.cmpf ogt, %in, %out : f32
    %9 = arith.select %8, %6, %out_0 : i64
    linalg.yield %7, %9 : f32, i64
  } -> (tensor<1xf32>, tensor<1xi64>)
  return %4#1 : tensor<1xi64>
}

// CHECK-LABEL: func @argmax_only_foo_ukernel_enabled(
//       CHECK: linalg.generic
//   CHECK-NOT: hal.executable.objects
//   CHECK-NOT: iree_gpu.ukernel_config

// -----

// Currently we do only handle -Inf case as initial values.
func.func @argmax_2d_f32i64_not_neg_inf_init(%arg0 : tensor<1x?xf32>) -> tensor<1xi64> attributes {
  hal.executable.target = #hal.executable.target<"rocm", "rocm-hsaco-fb", {ukernels = "all"}>
} {
  %c0_i64 = arith.constant 0 : i64
  %cst = arith.constant 0.0 : f32
  %0 = tensor.empty() : tensor<1xi64>
  %1 = linalg.fill ins(%c0_i64 : i64) outs(%0 : tensor<1xi64>) -> tensor<1xi64>
  %2 = tensor.empty() : tensor<1xf32>
  %3 = linalg.fill ins(%cst : f32) outs(%2 : tensor<1xf32>) -> tensor<1xf32>
  %4:2 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0)>], iterator_types = ["parallel", "reduction"]} ins(%arg0 : tensor<1x?xf32>) outs(%3, %1 : tensor<1xf32>, tensor<1xi64>) {
  ^bb0(%in: f32, %out: f32, %out_0: i64):
    %5 = linalg.index 1 : index
    %6 = arith.index_cast %5 : index to i64
    %7 = arith.maximumf %in, %out : f32
    %8 = arith.cmpf ogt, %in, %out : f32
    %9 = arith.select %8, %6, %out_0 : i64
    linalg.yield %7, %9 : f32, i64
  } -> (tensor<1xf32>, tensor<1xi64>)
  return %4#1 : tensor<1xi64>
}

//   CHECK-NOT: lowering_config<{{.*}}ukernel
// CHECK-LABEL: func @argmax_2d_f32i64_not_neg_inf_init(
//       CHECK: linalg.generic
//   CHECK-NOT: hal.executable.objects

// -----

// Test user-provided bitcode in the source IR.

func.func @argmax_2d_f32i64_custom_bitcode(%arg0 : tensor<1x?xf32>) -> tensor<1xi64> attributes {
  hal.executable.target = #hal.executable.target<"rocm", "rocm-hsaco-fb", {ukernels = "all"}>,
  // Dummy bitcode with an unusual length of 12. The first 4 bytes are the .bc file format signature.
  hal.executable.objects = [
    #hal.executable.object<{
      path = "iree_uk_amdgpu_argmax_f32i64.gfx942.bc",
      data = dense<[66, 67, -64, -34, 1, 35, 69, 103, -119, -85, -51, -17]> : tensor<12xi8>
    }>
  ]
} {
  %c0_i64 = arith.constant 0 : i64
  %cst = arith.constant 0xFF800000 : f32
  %0 = tensor.empty() : tensor<1xi64>
  %1 = linalg.fill ins(%c0_i64 : i64) outs(%0 : tensor<1xi64>) -> tensor<1xi64>
  %2 = tensor.empty() : tensor<1xf32>
  %3 = linalg.fill ins(%cst : f32) outs(%2 : tensor<1xf32>) -> tensor<1xf32>
  %4:2 = linalg.generic {indexing_maps = [affine_map<(d0, d1) -> (d0, d1)>, affine_map<(d0, d1) -> (d0)>, affine_map<(d0, d1) -> (d0)>], iterator_types = ["parallel", "reduction"]} ins(%arg0 : tensor<1x?xf32>) outs(%3, %1 : tensor<1xf32>, tensor<1xi64>) {
  ^bb0(%in: f32, %out: f32, %out_0: i64):
    %5 = linalg.index 1 : index
    %6 = arith.index_cast %5 : index to i64
    %7 = arith.maximumf %in, %out : f32
    %8 = arith.cmpf ogt, %in, %out : f32
    %9 = arith.select %8, %6, %out_0 : i64
    linalg.yield %7, %9 : f32, i64
  } -> (tensor<1xf32>, tensor<1xi64>)
  return %4#1 : tensor<1xi64>
}

// CHECK-LABEL: func @argmax_2d_f32i64_custom_bitcode(
//       CHECK:   linalg.generic
//  CHECK-SAME:     hal.executable.objects = [
//  CHECK-SAME:       #hal.executable.object<{
//  CHECK-SAME:         path = "iree_uk_amdgpu_argmax_f32i64.gfx942.bc",
//  CHECK-SAME:         data = dense<[66, 67, -64, -34, 1, 35, 69, 103, -119, -85, -51, -17]> : tensor<12xi8>
//  CHECK-SAME:       }>
//  CHECK-SAME:     ]
//  CHECK-SAME: #iree_gpu.lowering_config<{{.*}}ukernel = #iree_gpu.ukernel_config<name = "iree_uk_amdgpu_argmax_f32i64", def_attrs = {vm.import.module = "rocm"}>