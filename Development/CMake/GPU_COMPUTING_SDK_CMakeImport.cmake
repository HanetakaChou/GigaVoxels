#----------------------------------------------------------------
# Import library
#----------------------------------------------------------------
	
#----------------------------------------------------------------
# SET library PATH
#----------------------------------------------------------------

INCLUDE (GvSettings_CMakeImport)

#----------------------------------------------------------------
# CUDA SDK library settings
#----------------------------------------------------------------

# Idea : we should have our own HELPER file for this (operations on basic types : float2, int 4, */-+, etc...)
if (WIN32)
	set (GV_NVIDIAGPUCOMPUTINGSDK_RELEASE "C:/ProgramData/NVIDIA Corporation/CUDA Samples/v${CUDA_VERSION_STRING}")
	set (GV_NVIDIAGPUCOMPUTINGSDK_INC "${GV_NVIDIAGPUCOMPUTINGSDK_RELEASE}/common/inc")
else ()
	# For the moment, we store the file helper_math.h in our Library
	set (GV_NVIDIAGPUCOMPUTINGSDK_INC "${GV_ROOT}/External/CommonLibraries/nvidia_helper/")
endif ()

#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

INCLUDE_DIRECTORIES (${GV_NVIDIAGPUCOMPUTINGSDK_INC})

#----------------------------------------------------------------
# Add LINK library directories
#----------------------------------------------------------------
	
#----------------------------------------------------------------
# Set LINK libraries if not defined by user
#----------------------------------------------------------------

#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------
