; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -check-prefixes=GFX9-32BANK %s
; RUN: llc -mtriple=amdgcn -mcpu=fiji -verify-machineinstrs < %s | FileCheck -check-prefixes=GFX8-32BANK %s
; RUN: llc -mtriple=amdgcn -mcpu=gfx810 -verify-machineinstrs < %s | FileCheck -check-prefixes=GFX8-16BANK %s

define amdgpu_ps half @interp_f16(float inreg %i, float inreg %j, i32 inreg %m0) #0 {
; GFX9-32BANK-LABEL: interp_f16:
; GFX9-32BANK:       ; %bb.0: ; %main_body
; GFX9-32BANK-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-32BANK-NEXT:    s_mov_b32 m0, s2
; GFX9-32BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 3
; GFX9-32BANK-NEXT:    v_interp_p1ll_f16 v1, v0, attr2.y
; GFX9-32BANK-NEXT:    v_mov_b32_e32 v2, s1
; GFX9-32BANK-NEXT:    v_interp_p1ll_f16 v0, v0, attr2.y high
; GFX9-32BANK-NEXT:    v_interp_p2_legacy_f16 v1, v2, attr2.y, v1
; GFX9-32BANK-NEXT:    v_interp_p2_legacy_f16 v0, v2, attr2.y, v0 high
; GFX9-32BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 0
; GFX9-32BANK-NEXT:    v_add_f16_e32 v0, v1, v0
; GFX9-32BANK-NEXT:    ; return to shader part epilog
;
; GFX8-32BANK-LABEL: interp_f16:
; GFX8-32BANK:       ; %bb.0: ; %main_body
; GFX8-32BANK-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-32BANK-NEXT:    s_mov_b32 m0, s2
; GFX8-32BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 3
; GFX8-32BANK-NEXT:    v_interp_p1ll_f16 v1, v0, attr2.y
; GFX8-32BANK-NEXT:    v_mov_b32_e32 v2, s1
; GFX8-32BANK-NEXT:    v_interp_p1ll_f16 v0, v0, attr2.y high
; GFX8-32BANK-NEXT:    v_interp_p2_f16 v1, v2, attr2.y, v1
; GFX8-32BANK-NEXT:    v_interp_p2_f16 v0, v2, attr2.y, v0 high
; GFX8-32BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 0
; GFX8-32BANK-NEXT:    v_add_f16_e32 v0, v1, v0
; GFX8-32BANK-NEXT:    ; return to shader part epilog
;
; GFX8-16BANK-LABEL: interp_f16:
; GFX8-16BANK:       ; %bb.0: ; %main_body
; GFX8-16BANK-NEXT:    s_mov_b32 m0, s2
; GFX8-16BANK-NEXT:    v_interp_mov_f32_e32 v0, p0, attr2.y
; GFX8-16BANK-NEXT:    v_mov_b32_e32 v1, s0
; GFX8-16BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 3
; GFX8-16BANK-NEXT:    v_interp_p1lv_f16 v2, v1, attr2.y, v0
; GFX8-16BANK-NEXT:    v_mov_b32_e32 v3, s1
; GFX8-16BANK-NEXT:    v_interp_p1lv_f16 v0, v1, attr2.y, v0 high
; GFX8-16BANK-NEXT:    v_interp_p2_f16 v2, v3, attr2.y, v2
; GFX8-16BANK-NEXT:    v_interp_p2_f16 v0, v3, attr2.y, v0 high
; GFX8-16BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 0
; GFX8-16BANK-NEXT:    v_add_f16_e32 v0, v2, v0
; GFX8-16BANK-NEXT:    ; return to shader part epilog
main_body:
  %p1_0 = call float @llvm.amdgcn.interp.p1.f16(float %i, i32 1, i32 2, i1 0, i32 %m0)
  %p2_0 = call half @llvm.amdgcn.interp.p2.f16(float %p1_0, float %j, i32 1, i32 2, i1 0, i32 %m0)
  %p1_1 = call float @llvm.amdgcn.interp.p1.f16(float %i, i32 1, i32 2, i1 1, i32 %m0)
  %p2_1 = call half @llvm.amdgcn.interp.p2.f16(float %p1_1, float %j, i32 1, i32 2, i1 1, i32 %m0)
  %res = fadd half %p2_0, %p2_1
  ret half %res
}

; check that m0 is setup correctly before the interp p1 instruction
define amdgpu_ps half @interp_p1_m0_setup(float inreg %i, float inreg %j, i32 inreg %m0) #0 {
; GFX9-32BANK-LABEL: interp_p1_m0_setup:
; GFX9-32BANK:       ; %bb.0: ; %main_body
; GFX9-32BANK-NEXT:    ;;#ASMSTART
; GFX9-32BANK-NEXT:    s_mov_b32 m0, 0
; GFX9-32BANK-NEXT:    ;;#ASMEND
; GFX9-32BANK-NEXT:    s_mov_b32 s3, m0
; GFX9-32BANK-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-32BANK-NEXT:    s_mov_b32 m0, s2
; GFX9-32BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 3
; GFX9-32BANK-NEXT:    v_interp_p1ll_f16 v0, v0, attr2.y
; GFX9-32BANK-NEXT:    v_mov_b32_e32 v1, s1
; GFX9-32BANK-NEXT:    v_interp_p2_legacy_f16 v0, v1, attr2.y, v0
; GFX9-32BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 0
; GFX9-32BANK-NEXT:    v_add_f16_e32 v0, s3, v0
; GFX9-32BANK-NEXT:    ; return to shader part epilog
;
; GFX8-32BANK-LABEL: interp_p1_m0_setup:
; GFX8-32BANK:       ; %bb.0: ; %main_body
; GFX8-32BANK-NEXT:    ;;#ASMSTART
; GFX8-32BANK-NEXT:    s_mov_b32 m0, 0
; GFX8-32BANK-NEXT:    ;;#ASMEND
; GFX8-32BANK-NEXT:    s_mov_b32 s3, m0
; GFX8-32BANK-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-32BANK-NEXT:    s_mov_b32 m0, s2
; GFX8-32BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 3
; GFX8-32BANK-NEXT:    v_interp_p1ll_f16 v0, v0, attr2.y
; GFX8-32BANK-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-32BANK-NEXT:    v_interp_p2_f16 v0, v1, attr2.y, v0
; GFX8-32BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 0
; GFX8-32BANK-NEXT:    v_add_f16_e32 v0, s3, v0
; GFX8-32BANK-NEXT:    ; return to shader part epilog
;
; GFX8-16BANK-LABEL: interp_p1_m0_setup:
; GFX8-16BANK:       ; %bb.0: ; %main_body
; GFX8-16BANK-NEXT:    ;;#ASMSTART
; GFX8-16BANK-NEXT:    s_mov_b32 m0, 0
; GFX8-16BANK-NEXT:    ;;#ASMEND
; GFX8-16BANK-NEXT:    s_mov_b32 s3, m0
; GFX8-16BANK-NEXT:    s_mov_b32 m0, s2
; GFX8-16BANK-NEXT:    v_interp_mov_f32_e32 v0, p0, attr2.y
; GFX8-16BANK-NEXT:    v_mov_b32_e32 v1, s0
; GFX8-16BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 3
; GFX8-16BANK-NEXT:    v_interp_p1lv_f16 v0, v1, attr2.y, v0
; GFX8-16BANK-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-16BANK-NEXT:    v_interp_p2_f16 v0, v1, attr2.y, v0
; GFX8-16BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 0
; GFX8-16BANK-NEXT:    v_add_f16_e32 v0, s3, v0
; GFX8-16BANK-NEXT:    ; return to shader part epilog
main_body:
  %mx = call i32 asm sideeffect "s_mov_b32 m0, 0", "={M0}"() #0
  %p1_0 = call float @llvm.amdgcn.interp.p1.f16(float %i, i32 1, i32 2, i1 0, i32 %m0)
  %p2_0 = call half @llvm.amdgcn.interp.p2.f16(float %p1_0, float %j, i32 1, i32 2, i1 0, i32 %m0)
  %my = trunc i32 %mx to i16
  %mh = bitcast i16 %my to half
  %res = fadd half %p2_0, %mh
  ret half %res
}

; check that m0 is setup correctly before the interp p2 instruction
define amdgpu_ps half @interp_p2_m0_setup(float inreg %i, float inreg %j, i32 inreg %m0) #0 {
; GFX9-32BANK-LABEL: interp_p2_m0_setup:
; GFX9-32BANK:       ; %bb.0: ; %main_body
; GFX9-32BANK-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-32BANK-NEXT:    s_mov_b32 m0, s2
; GFX9-32BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 3
; GFX9-32BANK-NEXT:    v_interp_p1ll_f16 v0, v0, attr2.y
; GFX9-32BANK-NEXT:    ;;#ASMSTART
; GFX9-32BANK-NEXT:    s_mov_b32 m0, 0
; GFX9-32BANK-NEXT:    ;;#ASMEND
; GFX9-32BANK-NEXT:    s_mov_b32 s0, m0
; GFX9-32BANK-NEXT:    v_mov_b32_e32 v1, s1
; GFX9-32BANK-NEXT:    s_mov_b32 m0, s2
; GFX9-32BANK-NEXT:    v_interp_p2_legacy_f16 v0, v1, attr2.y, v0
; GFX9-32BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 0
; GFX9-32BANK-NEXT:    v_add_f16_e32 v0, s0, v0
; GFX9-32BANK-NEXT:    ; return to shader part epilog
;
; GFX8-32BANK-LABEL: interp_p2_m0_setup:
; GFX8-32BANK:       ; %bb.0: ; %main_body
; GFX8-32BANK-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-32BANK-NEXT:    s_mov_b32 m0, s2
; GFX8-32BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 3
; GFX8-32BANK-NEXT:    v_interp_p1ll_f16 v0, v0, attr2.y
; GFX8-32BANK-NEXT:    ;;#ASMSTART
; GFX8-32BANK-NEXT:    s_mov_b32 m0, 0
; GFX8-32BANK-NEXT:    ;;#ASMEND
; GFX8-32BANK-NEXT:    s_mov_b32 s0, m0
; GFX8-32BANK-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-32BANK-NEXT:    s_mov_b32 m0, s2
; GFX8-32BANK-NEXT:    v_interp_p2_f16 v0, v1, attr2.y, v0
; GFX8-32BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 0
; GFX8-32BANK-NEXT:    v_add_f16_e32 v0, s0, v0
; GFX8-32BANK-NEXT:    ; return to shader part epilog
;
; GFX8-16BANK-LABEL: interp_p2_m0_setup:
; GFX8-16BANK:       ; %bb.0: ; %main_body
; GFX8-16BANK-NEXT:    s_mov_b32 m0, s2
; GFX8-16BANK-NEXT:    v_interp_mov_f32_e32 v0, p0, attr2.y
; GFX8-16BANK-NEXT:    v_mov_b32_e32 v1, s0
; GFX8-16BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 3
; GFX8-16BANK-NEXT:    v_interp_p1lv_f16 v0, v1, attr2.y, v0
; GFX8-16BANK-NEXT:    ;;#ASMSTART
; GFX8-16BANK-NEXT:    s_mov_b32 m0, 0
; GFX8-16BANK-NEXT:    ;;#ASMEND
; GFX8-16BANK-NEXT:    s_mov_b32 s0, m0
; GFX8-16BANK-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-16BANK-NEXT:    s_mov_b32 m0, s2
; GFX8-16BANK-NEXT:    v_interp_p2_f16 v0, v1, attr2.y, v0
; GFX8-16BANK-NEXT:    s_setreg_imm32_b32 hwreg(HW_REG_MODE, 2, 2), 0
; GFX8-16BANK-NEXT:    v_add_f16_e32 v0, s0, v0
; GFX8-16BANK-NEXT:    ; return to shader part epilog
main_body:
  %p1_0 = call float @llvm.amdgcn.interp.p1.f16(float %i, i32 1, i32 2, i1 0, i32 %m0)
  %mx = call i32 asm sideeffect "s_mov_b32 m0, 0", "={M0}"() #0
  %p2_0 = call half @llvm.amdgcn.interp.p2.f16(float %p1_0, float %j, i32 1, i32 2, i1 0, i32 %m0)
  %my = trunc i32 %mx to i16
  %mh = bitcast i16 %my to half
  %res = fadd half %p2_0, %mh
  ret half %res
}

; float @llvm.amdgcn.interp.p1.f16(i, attrchan, attr, high, m0)
declare float @llvm.amdgcn.interp.p1.f16(float, i32, i32, i1, i32) #0
; half @llvm.amdgcn.interp.p1.f16(p1, j, attrchan, attr, high, m0)
declare half @llvm.amdgcn.interp.p2.f16(float, float, i32, i32, i1, i32) #0
declare float @llvm.amdgcn.interp.mov(i32, i32, i32, i32) #0

attributes #0 = { nounwind readnone }