GENCODE_SM60 ?= -gencode=arch=compute_60,code=\"sm_60,compute_60\"
GENCODE_SM62 ?= -gencode=arch=compute_62,code=\"sm_62,compute_62\"
GENCODE_SM70 ?= -gencode=arch=compute_70,code=\"sm_70,compute_70\"
GENCODE_SM75 ?= -gencode=arch=compute_75,code=\"sm_75,compute_75\"
GENCODE_SM86 ?= -gencode=arch=compute_86,code=\"sm_86,compute_86\"
# MAKE_ARGS := $(GENCODE_SM86) $(GENCODE_SM60)  $(GENCODE_SM62) $(GENCODE_SM70) $(GENCODE_SM75)

ifeq ($(GPUAPPS_SETUP_ENVIRONMENT_WAS_RUN), 0)
$(error You must run "source setup_environment before calling make")
endif

ifeq ($(CUDA_GT_10), 1)
all: rodinia lonestar2.0 polybench parboil ispass deepbench tango
endif
# ifeq ($(CUDA_GT_7), 1)
# # all:   pannotia rodinia_2.0-ft proxy-apps dragon-naive dragon-cdp microbench rodinia ispass-2009 lonestargpu-2.0 polybench parboil shoc custom_apps deeplearning cutlass GPU_Microbenchmark heterosync Deepbench_nvidia
# all: rodinia lonestargpu-2.0 polybench parboil tango
# else
# 	ifeq ($(CUDA_GT_4), 1)
# 	all:   pannotia rodinia_2.0-ft proxy-apps dragon-naive microbench rodinia ispass-2009 dragon-cdp lonestargpu-2.0 polybench parboil shoc custom_apps
# 	else
# 	all:   pannotia rodinia_2.0-ft proxy-apps microbench rodinia ispass-2009 polybench parboil shoc custom_apps
# 	endif
# endif

#Disable clean for now, It has a bug!
# clean_dragon-naive clean_pannotia clean_proxy-apps
#clean: clean_rodinia_2.0-ft clean_dragon-cdp  clean_ispass-2009 clean_lonestargpu-2.0 clean_custom_apps clean_parboil clean_cutlass clean_rodinia clean_heterosync
clean: clean_rodinia clean_lonestar2.0 clean_parboil clean_ispass clean_polybench clean_tango

# clean_data:
# 	./clean_data.sh

# data:
# 	mkdir -p $(BINDIR)/
# 	cd ../ && bash ./get_data.sh
data:
	cp -r ../hdd/data_dirs .
	mv data_dirs/tango/AlexNet/data $(BINDIR)/tango/AlexNet/
	mv data_dirs/tango/CifarNet/data $(BINDIR)/tango/CifarNet/
	mv data_dirs/tango/GRU/data $(BINDIR)/tango/GRU/
	mv data_dirs/tango/LSTM/data $(BINDIR)/tango/LSTM/
	mv data_dirs/tango/ResNet/data $(BINDIR)/tango/ResNet
	mv data_dirs/tango/SqueezeNet/data $(BINDIR)/tango/SqueezeNet

deepbench:
	mkdir -p $(BINDIR)/deepbench
	$(SETENV) make $(MAKE_ARGS) -C DeepBench/code/nvidia
	mv DeepBench/code/nvidia/bin/* $(BINDIR)/deepbench/
#	cp -r deepbench/code/nvidia/bin/gemm_bench* $(BINDIR)/
#	cp -r deepbench/code/nvidia/bin/rnn_bench* $(BINDIR)/

tango:
	mkdir -p $(BINDIR)/tango
	$(SETENV) cd Tango/GPU; ./compile.sh
	mkdir -p $(BINDIR)/tango/AlexNet
	mkdir -p $(BINDIR)/tango/CifarNet
	mkdir -p $(BINDIR)/tango/GRU
	mkdir -p $(BINDIR)/tango/LSTM
	mkdir -p $(BINDIR)/tango/ResNet
	mkdir -p $(BINDIR)/tango/SqueezeNet
	mv Tango/GPU/AlexNet/AN $(BINDIR)/tango
	mv Tango/GPU/CifarNet/CN $(BINDIR)/tango
	mv Tango/GPU/GRU/GRU $(BINDIR)/tango
	mv Tango/GPU/LSTM/LSTM $(BINDIR)/tango
	mv Tango/GPU/ResNet/RN $(BINDIR)/tango
	mv Tango/GPU/SqueezeNet/SN $(BINDIR)/tango

rodinia:
	mkdir -p $(BINDIR)/rodinia-3.1
	if [ ${CUDA_VERSION_MAJOR} -gt 5 ]; then \
		$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/huffman/; \
	fi
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/backprop
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/bfs 
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/cfd
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/hotspot 
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/kmeans 
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/needle 
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/streamingcluster
#	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/mummergpu
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/b+tree/
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/dwt2d/
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/heartwall/
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/hybridsort/
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/myocyte/
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/nn/
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/particlefilter/
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/pathfinder/
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/lavaMD/
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/lud/
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/leukocyte/
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/hotspot3D/
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/gaussian/
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/srad/
#	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/srad/srad_v2 -f Makefile_nvidia
	if [ ${CUDA_VERSION_MAJOR} -gt 5 ]; then \
		mv rodinia-3.1/huffman/huffman $(BINDIR)/rodinia-3.1/huffman; \
	fi
	mv rodinia-3.1/b+tree/b+tree $(BINDIR)/rodinia-3.1/b+tree
	mv rodinia-3.1/dwt2d/dwt2d $(BINDIR)/rodinia-3.1/dwt2d
	mv rodinia-3.1/heartwall/heartwall $(BINDIR)/rodinia-3.1/heartwall
	mv rodinia-3.1/hybridsort/hybridsort $(BINDIR)/rodinia-3.1/hybridsort
	mv rodinia-3.1/myocyte/myocyte $(BINDIR)/rodinia-3.1/myocyte
	mv rodinia-3.1/nn/nn $(BINDIR)/rodinia-3.1/nn
	mv rodinia-3.1/particlefilter/particlefilter_float $(BINDIR)/rodinia-3.1/particlefilter_float
	mv rodinia-3.1/particlefilter/particlefilter_naive $(BINDIR)/rodinia-3.1/particlefilter_naive
	mv rodinia-3.1/pathfinder/pathfinder $(BINDIR)/rodinia-3.1/pathfinder
	mv rodinia-3.1/lavaMD/lavaMD $(BINDIR)/rodinia-3.1/lavaMD
	mv rodinia-3.1/lud/lud $(BINDIR)/rodinia-3.1/lud
	mv rodinia-3.1/leukocyte/leukocyte $(BINDIR)/rodinia-3.1/leukocyte
	mv rodinia-3.1/hotspot3D/hotspot3D $(BINDIR)/rodinia-3.1/hotspot3D
	mv rodinia-3.1/gaussian/gaussian $(BINDIR)/rodinia-3.1/gaussian
	mv rodinia-3.1/srad/srad_v1/srad1 $(BINDIR)/rodinia-3.1/srad1
	mv rodinia-3.1/srad/srad_v2/srad2 $(BINDIR)/rodinia-3.1/srad2
	mv rodinia-3.1/backprop/backprop $(BINDIR)/rodinia-3.1/backprop
	mv rodinia-3.1/bfs/bfs  $(BINDIR)/rodinia-3.1/bfs
	mv rodinia-3.1/cfd/euler3d $(BINDIR)/rodinia-3.1/euler3d
	mv rodinia-3.1/cfd/pre_euler3d $(BINDIR)/rodinia-3.1/pre_euler3d
	mv rodinia-3.1/cfd/euler3d_double $(BINDIR)/rodinia-3.1/euler3d_double
	mv rodinia-3.1/cfd/pre_euler3d_double $(BINDIR)/rodinia-3.1/pre_euler3d_double
	mv rodinia-3.1/hotspot/hotspot $(BINDIR)/rodinia-3.1/hotspot
	mv rodinia-3.1/kmeans/kmeans $(BINDIR)/rodinia-3.1/kmeans
	mv rodinia-3.1/needle/needle $(BINDIR)/rodinia-3.1/nw
	mv rodinia-3.1/streamingcluster/streamingcluster $(BINDIR)/rodinia-3.1/streamingcluster
#	mv $(BINDIR)/mummergpu $(BINDIR)/mummergpu

ispass:
#	mkdir -p $(BINDIR)/ispass-2009
#	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C ispass-2009/AES
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C ispass-2009/BFS
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C ispass-2009/LIB
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C ispass-2009/LPS
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C ispass-2009/MUM
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C ispass-2009/NN
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C ispass-2009/NQU
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C ispass-2009/RAY
	$(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C ispass-2009/STO
	mv $(BINDIR)/release $(BINDIR)/ispass-2009
#	PID=$$$$ && cp -r ispass-2009/WP ispass-2009/WP-$$PID && $(SETENV) make $(MAKE_ARGS) noinline=$(noinline) -C ispass-2009/WP-$$PID && rm -rf ispass-2009/WP-$$PID

lonestar2.0:
	mkdir -p $(BINDIR)/lonestargpu-2.0
	$(setenv) make $(make_args) noinline=$(noinline) -C lonestargpu-2.0 all
	mv lonestargpu-2.0/apps/bfs/bfs $(BINDIR)/lonestargpu-2.0/lonestar-bfs
	mv lonestargpu-2.0/apps/bfs/bfs-atomic $(BINDIR)/lonestargpu-2.0/lonestar-bfs-atomic
	mv lonestargpu-2.0/apps/bfs/bfs-wlc $(BINDIR)/lonestargpu-2.0/lonestar-bfs-wlc
	mv lonestargpu-2.0/apps/bfs/bfs-wla $(BINDIR)/lonestargpu-2.0/lonestar-bfs-wla
	mv lonestargpu-2.0/apps/bfs/bfs-wlw $(BINDIR)/lonestargpu-2.0/lonestar-bfs-wlw
	mv lonestargpu-2.0/apps/bh/bh $(BINDIR)/lonestargpu-2.0/lonestar-bh
	mv lonestargpu-2.0/apps/dmr/dmr $(BINDIR)/lonestargpu-2.0/lonestar-dmr
	mv lonestargpu-2.0/apps/mst/mst $(BINDIR)/lonestargpu-2.0/lonestar-mst
	mv lonestargpu-2.0/apps/pta/pta $(BINDIR)/lonestargpu-2.0/lonestar-pta
	mv lonestargpu-2.0/apps/nsp/nsp $(BINDIR)/lonestargpu-2.0/lonestar-nsp
	mv lonestargpu-2.0/apps/sssp/sssp $(BINDIR)/lonestargpu-2.0/lonestar-sssp
	mv lonestargpu-2.0/apps/sssp/sssp-wlc $(BINDIR)/lonestargpu-2.0/lonestar-sssp-wlc
	mv lonestargpu-2.0/apps/sssp/sssp-wln $(BINDIR)/lonestargpu-2.0/lonestar-sssp-wln

parboil:
#	make data
	mkdir -p $(BINDIR)/parboil
	$(SETENV) cd Parboil; ./parboil compile cutcp cuda
	$(SETENV) cd Parboil; ./parboil compile bfs cuda
	$(SETENV) cd Parboil; ./parboil compile histo cuda
	$(SETENV) cd Parboil; ./parboil compile lbm cuda
	$(SETENV) cd Parboil; ./parboil compile mri-gridding cuda
	$(SETENV) cd Parboil; ./parboil compile mri-q cuda
	$(SETENV) cd Parboil; ./parboil compile sad cuda
	$(SETENV) cd Parboil; ./parboil compile sgemm cuda
	$(SETENV) cd Parboil; ./parboil compile spmv cuda
	$(SETENV) cd Parboil; ./parboil compile stencil cuda
	$(SETENV) cd Parboil; ./parboil compile tpacf cuda
	mv ./parboil/benchmarks/lbm/build/cuda_default/lbm $(BINDIR)/parboil/lbm
	mv ./parboil/benchmarks/cutcp/build/cuda_default/cutcp $(BINDIR)/parboil/cutcp
	mv ./parboil/benchmarks/bfs/build/cuda_default/bfs $(BINDIR)/parboil/bfs
	mv ./parboil/benchmarks/histo/build/cuda_default/histo $(BINDIR)/parboil/histo
	mv ./parboil/benchmarks/mri-gridding/build/cuda_default/mri-gridding $(BINDIR)/parboil/mri-gridding
	mv ./parboil/benchmarks/mri-q/build/cuda_default/mri-q $(BINDIR)/parboil/mri-q
	mv ./parboil/benchmarks/sad/build/cuda_default/sad $(BINDIR)/parboil/sad
	mv ./parboil/benchmarks/sgemm/build/cuda_default/sgemm $(BINDIR)/parboil/sgemm
	mv ./parboil/benchmarks/spmv/build/cuda_default/spmv $(BINDIR)/parboil/spmv
	mv ./parboil/benchmarks/stencil/build/cuda_default/stencil $(BINDIR)/parboil/stencil
	mv ./parboil/benchmarks/tpacf/build/cuda_default/tpacf $(BINDIR)/parboil/tpacf

polybench:
	mkdir -p $(BINDIR)/polybench
	$(SETENV) cd polybench-3.2/; sh ./compileCodes.sh bin
	mv polybench-3.2/bin/2DConvolution.exe $(BINDIR)/polybench/2DConvolution
	mv polybench-3.2/bin/3DConvolution.exe $(BINDIR)/polybench/3DConvolution
	mv polybench-3.2/bin/2mm.exe $(BINDIR)/polybench/2mm
	mv polybench-3.2/bin/3mm.exe $(BINDIR)/polybench/3mm
	mv polybench-3.2/bin/adi.exe $(BINDIR)/polybench/adi
	mv polybench-3.2/bin/atax.exe $(BINDIR)/polybench/atax
	mv polybench-3.2/bin/bicg.exe $(BINDIR)/polybench/bicg
	mv polybench-3.2/bin/correlation.exe $(BINDIR)/polybench/correlation
	mv polybench-3.2/bin/covariance.exe $(BINDIR)/polybench/covariance
	mv polybench-3.2/bin/doitgen.exe $(BINDIR)/polybench/doitgen
	mv polybench-3.2/bin/fdtd2d.exe $(BINDIR)/polybench/fdtd2d
	mv polybench-3.2/bin/gemm.exe $(BINDIR)/polybench/gemm
	mv polybench-3.2/bin/gemver.exe $(BINDIR)/polybench/gemver
	mv polybench-3.2/bin/gesummv.exe $(BINDIR)/polybench/gesummv
	mv polybench-3.2/bin/gramschmidt.exe $(BINDIR)/polybench/gramschmidt
	mv polybench-3.2/bin/jacobi1D.exe $(BINDIR)/polybench/jacobi1D
	mv polybench-3.2/bin/jacobi2D.exe $(BINDIR)/polybench/jacobi2D
	mv polybench-3.2/bin/lu.exe $(BINDIR)/polybench/lu
	mv polybench-3.2/bin/mvt.exe $(BINDIR)/polybench/mvt
	mv polybench-3.2/bin/syr2k.exe $(BINDIR)/polybench/syr2k
	mv polybench-3.2/bin/syrk.exe $(BINDIR)/polybench/syrk
	rm -r polybench-3.2/bin


# cutlass:
# 	mkdir -p $(BINDIR)
# 	git submodule init && git submodule update
# 	$(SETENV) mkdir -p cutlass-bench/build && cd cutlass-bench/build && cmake .. -DUSE_GPGPUSIM=1 -DCUTLASS_NVCC_ARCHS=86 && make cutlass_perf_test
# 	cd cutlass-bench/build/tools/test/perf && ln -s -f ../../../../binary.sh . && ./binary.sh
# 	cp cutlass-bench/build/tools/test/perf/cutlass_perf_test $(BINDIR)/

# clean_cutlass:
# 	rm -fr cutlass-bench/build

# clean_tango:
# 	rm -r $(BINDIR)/tango

# clean_polybench:
# 	rm -r $(BINDIR)/polybench

clean_parboil:
	$(SETENV) cd parboil; ./parboil clean cutcp cuda
	$(SETENV) cd parboil; ./parboil clean bfs cuda
	$(SETENV) cd parboil; ./parboil clean histo cuda
	$(SETENV) cd parboil; ./parboil clean lbm cuda
	$(SETENV) cd parboil; ./parboil clean mri-gridding cuda
	$(SETENV) cd parboil; ./parboil clean mri-q cuda
	$(SETENV) cd parboil; ./parboil clean sad cuda
	$(SETENV) cd parboil; ./parboil clean sgemm cuda
	$(SETENV) cd parboil; ./parboil clean spmv cuda
	$(SETENV) cd parboil; ./parboil clean stencil cuda
	$(SETENV) cd parboil; ./parboil clean tpacf cuda

clean_lonestar2.0:
	$(setenv) make $(make_args) noinline=$(noinline) -C lonestargpu-2.0 clean

clean_ispass:
#	$(SETENV) make $(MAKE_ARGS) clean noinline=$(noinline) -C ispass-2009/AES
	$(SETENV) make $(MAKE_ARGS) clean noinline=$(noinline) -C ispass-2009/BFS
	$(SETENV) make $(MAKE_ARGS) clean noinline=$(noinline) -C ispass-2009/LIB
	$(SETENV) make $(MAKE_ARGS) clean noinline=$(noinline) -C ispass-2009/LPS
	$(SETENV) make $(MAKE_ARGS) clean noinline=$(noinline) -C ispass-2009/MUM
	$(SETENV) make $(MAKE_ARGS) clean noinline=$(noinline) -C ispass-2009/NN
	$(SETENV) make $(MAKE_ARGS) clean noinline=$(noinline) -C ispass-2009/NQU
	$(SETENV) make $(MAKE_ARGS) clean noinline=$(noinline) -C ispass-2009/RAY
	$(SETENV) make $(MAKE_ARGS) clean noinline=$(noinline) -C ispass-2009/STO
#	$(SETENV) make $(MAKE_ARGS) clean noinline=$(noinline) -C ispass-2009/WP

clean_rodinia:
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/backprop 
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/bfs 
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/cfd
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/hotspot 
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/kmeans
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/needle
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/streamingcluster
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/mummergpu
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/b+tree/
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/dwt2d/
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/heartwall/
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/huffman/
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/hybridsort/
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/myocyte/
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/nn/
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/particlefilter/
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/particlefilter/
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/pathfinder/
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/lavaMD/
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/lud/
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/leukocyte/
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/hotspot3D/
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/gaussian
	$(SETENV) make clean $(MAKE_ARGS) noinline=$(noinline) -C rodinia-3.1/srad/
