{ config, lib, pkgs, ... }:

{
  home.packages = [
    (pkgs.python3.withPackages (ps: with ps; [
      numpy
      pillow
      matplotlib
      jupyter
      pytest
      pyopengl
      glfw
      jupyterlab
      nbclient
      nbformat
      scikit-learn
      scikit-image
    ]))
  ];
}
