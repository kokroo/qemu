/*
 * Target-specific parts of semihosting/arm-compat-semi.c for Xtensa.
 *
 * The OpenOCD-style semihosting interface used by the Rust `semihosting`
 * crate (feature openocd-semihosting), OpenOCD, and probe-rs places the op
 * in a2 and the parameter block in a3, with the result returned in a2 --
 * a2 is the first argument register of the Xtensa ABI.
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

#ifndef TARGET_XTENSA_COMMON_SEMI_TARGET_H
#define TARGET_XTENSA_COMMON_SEMI_TARGET_H

static inline target_ulong common_semi_arg(CPUState *cs, int argno)
{
    XtensaCPU *cpu = XTENSA_CPU(cs);
    CPUXtensaState *env = &cpu->env;

    return env->regs[2 + argno];
}

static inline void common_semi_set_ret(CPUState *cs, target_ulong ret)
{
    XtensaCPU *cpu = XTENSA_CPU(cs);
    CPUXtensaState *env = &cpu->env;

    env->regs[2] = ret;
}

static inline bool common_semi_sys_exit_extended(CPUState *cs, int nr)
{
    return nr == TARGET_SYS_EXIT_EXTENDED;
}

static inline bool is_64bit_semihosting(CPUArchState *env)
{
    return false;
}

static inline target_ulong common_semi_stack_bottom(CPUState *cs)
{
    XtensaCPU *cpu = XTENSA_CPU(cs);
    CPUXtensaState *env = &cpu->env;

    return env->regs[1];    /* a1 = sp */
}

static inline bool common_semi_has_synccache(CPUArchState *env)
{
    return true;
}

#endif /* TARGET_XTENSA_COMMON_SEMI_TARGET_H */
