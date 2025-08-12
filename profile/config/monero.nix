{ config, pkgs, lib }:

{
        services.monero = {
                enable = true;
                prune = true;
        };




# XMRIG CONFIG
        hardware.cpu.x86.msr.enable = true;
        systemd.services.xmrig = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          description = "XMRig Mining Software Service";
          serviceConfig = let
                json = pkgs.formats.json {};
                configFile = json.generate "config.json" {
                  autosave = true;
                  cpu = true;
                  opencl = false;
                  cuda = true;
                  # randomx.igb-pages = true;
                  pools = {
                  # algo = "null";
                  # coin = "null";
                  url = "pool.supportxmr.com:443";
                  user = "455dygYZmT4Y3wgnqQc8qgXGcCW9vJevKcpKageR65dBYr5bndKP5GjFCvCownGN8dHVq9k12etDbNjvnTGXGhQ2EA6d8A6";
                  pass = "crazymonkey";
          # rig-id = "null";
          # nicehash = false;
                  keepalive = true;
          # enabled = true;
                  tls = true;
          # tls-fingerprint = "null";
          # daemon = false;
          # socks5 = "null";
          # self-select = null;
          # submit-to-origin = false;
        }; 
      };
          in {
                ExecStartPre = "${pkgs.xmrig}/bin/xmrig --config=${configFile} --dry-run";
                ExecStart = "${pkgs.xmrig}/bin/xmrig --config=${configFile}";
      # https://xmrig.com/docs/miner/randomx-optimization-guide/msr
      # If you use recent XMRig with root privileges (Linux) or admin
      # privileges (Windows) the miner configure all MSR registers
      # automatically.
                DynamicUser = lib.mkDefault false;
    };
  };
}
