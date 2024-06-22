{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/5672bc9dbf9d88246ddab5ac454e82318d094bb8";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [

      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: 
      let liteloaderqqnt = pkgs.fetchFromGitHub {
        owner = "LiteLoaderQQNT";
        repo = "LiteLoaderQQNT";
        rev = "1.1.2";
        hash = "sha256-o9NLTSFPRMm+wdve60nF8BCthS/ZjTmheBvBFxE/YC8=";
      };
      in
      {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
              "qq"
            ];
          };
        };

        packages.liteloaderqqnt = liteloaderqqnt;
        packages.qq = pkgs.qq.overrideAttrs (final: prev: {
          postInstall = ''
            # Patch QQ
            sed -i "1s@^@require(\"${liteloaderqqnt}\");\n@" $out/opt/QQ/resources/app/app_launcher/index.js
            mkdir -vp $out/opt/QQ/resources/app/application/
            cp -f ${liteloaderqqnt}/src/preload.js $out/opt/QQ/resources/app/application/
            wrapProgramShell $out/bin/qq --run "export LITELOADERQQNT_PROFILE=~/.local/share/LLQQNT"
          '';
        });
        devShells.default = pkgs.mkShell{
          buildInputs = with pkgs;[
            self'.packages.qq sway wayvnc novnc
          ];
        };

      };
      flake = {
      };
    };
}
