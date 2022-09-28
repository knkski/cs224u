{ pkgs ? import <nixpkgs> { }, lib ? pkgs.lib }:
let
  env = pkgs.poetry2nix.mkPoetryEnv {
    python = pkgs.python39;
    projectDir = ./.;
    preferWheels = true;
    overrides = pkgs.poetry2nix.overrides.withDefaults (self: super: {
      pyzmq = super.pyzmq.overridePythonAttrs
        (old: { buildInputs = [ pkgs.stdenv.cc.cc.lib ]; });

      nbconvert = super.nbconvert.overridePythonAttrs (_: { postPatch = ""; });
      astunparse = super.astunparse.overridePythonAttrs
        (old: { buildInputs = old.buildInputs ++ [ self.wheel ]; });
      nbdev = super.nbdev.overridePythonAttrs
        (old: { buildInputs = old.buildInputs ++ [ self.wheel ]; });
    });
  };
in env.env
