# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

   networking = { nameservers = [ "127.0.0.1" "::1" ]; };

   services.dnscrypt-proxy = { enable = true; settings = { listen_addresses = [ "127.0.0.1:53" "[::1]:53" ]; }; };

   services.zapret = { enable = true; params = [ "--dpi-desync=fake" "--dpi-desync-ttl=8" ]; }; 

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n.defaultLocale = "tr_TR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Hyprland pencere yöneticisini ve Wayland desteğini aktif eder
  programs.hyprland = {
    enable = true;
    xwayland.enable = true; # X11 bağımlı uygulamalar için XWayland desteği
  };

# XDG Portal desteği (ekran paylaşımı ve dosya seçiciler için gereklidir)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

# Electron/Chromium uygulamalarının varsayılan olarak Wayland modunda çalışması için
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Grafik hızlandırmayı ve 32-bit kütüphaneleri aç
  hardware.graphics = {
  enable = true;
  enable32Bit = true;
  };

  # NVIDIA temel ayarları
  hardware.nvidia = {
  modesetting.enable = true;
  open = false; # Açık kaynak olmayan (proprietary) sürücü
  nvidiaSettings = true;
  package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

  prime = {
    sync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
};

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
 
  hardware.enableAllFirmware = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "tr";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "trq";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  services.blueman.enable = true;

  services.flatpak.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."kayra" = {
    isNormalUser = true;
    description = "Kayra";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      firefoxpwa
	vscode
	fastfetch
	btop
	alacritty
	cava
	pipes
	obs-studio
	kdePackages.kdenlive
	spotify
	kitty

        libnotify
	catppuccin-gtk
  	papirus-icon-theme
	rofi
  	lxappearance
	onlyoffice-desktopeditors
	psmisc
	audacity
	bibata-cursors
	xwinwrap
	mpv
	git
	unzip
  	zip
  	p7zip
	xarchiver
	conky
	pciutils
	picom
        obsidian
  	appimage-run
 	vesktop
	gcc
  	clang
  	llvm
  	gnumake 
  	cmake
	gdb
	zsh
	kdePackages.bluedevil
	cmatrix
	clock-rs
	fish
	yt-dlp
	jdk17
	steam-run
	zoom-us
	waybar
	dunst
	hyprpaper
	grim
  	slurp
	wl-clipboard
	swaybg
	pavucontrol
	hyprlock
    ];
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs; [
  jetbrains-mono
  nerd-fonts.jetbrains-mono
  nerd-fonts.fira-code
  noto-fonts
  noto-fonts-color-emoji
  font-awesome
];

  # Install firefox.
  programs.firefox = {
	enable = true;
	nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
};

   programs.steam.enable = true;

   programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
