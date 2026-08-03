{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [
    "debugfs=off"                   # Disable mounting of debugfs (kernel debugging filesystem) for security/hardening
    "vsyscall=none"                 # Disable legacy vsyscall interface; improves security by preventing old syscall mechanisms
    "split_lock_detect=off"         # Disable split-lock detection (avoids performance penalties or crashes on CPUs supporting this feature)
    "libahci.ignore_sss=1"          # Ignore AHCI "Slumber State" support; can help with SATA controller compatibility issues
    "rootflags=noatime"             # Mount the root filesystem with noatime; avoids updating file access timestamps to reduce disk writes
    "rfkill.default_state=1"        # Set wireless device killswitch state to enabled by default (allows radios to start enabled)
    "rfkill.master_switch_mode=2"   # Configure rfkill master switch behavior; mode 2 controls how hardware/software radio blocks interact
    "amdgpu.msi=1"                  # Enable Message Signaled Interrupts (MSI) for AMD GPUs; can improve interrupt handling
    "nvidia.NVreg_EnableMSI=1"      # Enable MSI interrupts for NVIDIA drivers; may improve GPU interrupt performance/stability
    "nowatchdog"                    # Disable kernel watchdog timers
    "nmi_watchdog=0"                # Disable the NMI watchdog (hardware-based kernel lockup detector)
    "module_blacklist=iTCO_wdt"     # Prevent loading Intel TCO watchdog driver module
    "amdgpu.audio=0"                # Disable AMD GPU HDMI/DisplayPort audio support
    "amdgpu.ppfeaturemask=0xffffffff"# Enable all AMDGPU PowerPlay features (advanced power/clock control options)
  ];

  boot.kernel.sysctl = {
    # Prevent loading new line disciplines (reduces attack surface)
    "dev.tty.ldisc_autoload" = 0;

    # Protect FIFO files from unsafe writes by unprivileged users
    "fs.protected_fifos" = 2;

    # Protect hardlinks from unprivileged users
    "fs.protected_hardlinks" = 1;

    # Protect regular files from unsafe writes
    "fs.protected_regular" = 2;

    # Protect symlinks from following attacks
    "fs.protected_symlinks" = 1;

    # Disable core dumps for SUID programs
    "fs.suid_dumpable" = 0;

    # Include PID in core dump filenames
    "kernel.core_uses_pid" = 1;

    # Disable Ctrl+Alt+Del reboot
    "kernel.ctrl-alt-del" = 0;

    # Restrict access to kernel logs
    "kernel.dmesg_restrict" = 1;

    # Restrict exposure of kernel pointers
    "kernel.kptr_restrict" = 2;

    # Restrict SysRq magic key functions
    "kernel.sysrq" = 0;

    # Disable unprivileged eBPF
    "kernel.unprivileged_bpf_disabled" = 1;

    # Harden BPF JIT compiler
    "net.core.bpf_jit_harden" = 2;

    # Disable IPv4 ICMP redirects
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;

    # Disable IPv4 source routing
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;

    # Disable logging of impossible addresses unless desired
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.conf.default.log_martians" = 1;

    # Enable reverse path filtering (anti-spoofing)
    "net.ipv4.conf.all.rp_filter" = 1;

    # Disable sending ICMP redirects
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;

    # IPv6 hardening
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;

    # Disable IPv6 source routing
    "net.ipv6.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.default.accept_source_route" = 0;
  };
}
