# unraid_packages


docker build -t builder .

docker run --rm -it -v $PWD:/build builder "./make_nvtop_pkg.sh"