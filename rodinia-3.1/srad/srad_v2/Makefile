include ../../../common/make.config

CC := $(CUDA_DIR)/bin/nvcc $(GENCODE_SM70) $(GENCODE_SM75) $(GENCODE_SM86) $(GENCODE_SM60) $(GENCODE_SM62)

INCLUDE := $(CUDA_DIR)/include

SRC = srad.cu

EXE = srad2

release: $(SRC)
	$(CC) $(KERNEL_DIM) $(SRC) -o $(EXE) -I$(INCLUDE) -L$(CUDA_LIB_DIR) -lcudart 

enum: $(SRC)
	$(CC) $(KERNEL_DIM) -deviceemu $(SRC) -o $(EXE) -I$(INCLUDE) -L$(CUDA_LIB_DIR) -lcudart 

debug: $(SRC)
	$(CC) $(KERNEL_DIM) -g $(SRC) -o $(EXE) -I$(INCLUDE) -L$(CUDA_LIB_DIR) -lcudart

debugenum: $(SRC)
	$(CC) $(KERNEL_DIM) -g -deviceemu $(SRC) -o $(EXE) -I$(INCLUDE) -L$(CUDA_LIB_DIR) -lcudart 

clean: $(SRC)
	rm -f $(EXE) $(EXE).linkinfo result.txt
