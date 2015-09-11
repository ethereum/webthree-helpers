function(eth_apply TARGET REQUIRED SUBMODULE)
	# TODO take into account REQUIRED

	set(ETH_DIR "${ETH_CMAKE_DIR}/../../libethereum" CACHE PATH "The path to the ethereum directory")
	set(ETH_BUILD_DIR_NAME  "build" CACHE STRING "Ethereum build directory name")
	set(ETH_BUILD_DIR "${ETH_DIR}/${ETH_BUILD_DIR_NAME}")
	set(CMAKE_LIBRARY_PATH 	${ETH_BUILD_DIR};${CMAKE_LIBRARY_PATH})

	find_package(Eth)

	target_include_directories(${TARGET} BEFORE PUBLIC ${Eth_INCLUDE_DIRS})

	if (${SUBMODULE} STREQUAL "ethash")
		# even if ethash is required, Cryptopp is optional
		eth_use(${TARGET} OPTIONAL Cryptopp)
		target_link_libraries(${TARGET} ${Eth_ETHASH_LIBRARIES})
	endif()

	if (${SUBMODULE} STREQUAL "ethash-cl")
		if (ETHASHCL OR Eth_ETHASH-CL_LIBRARIES)
			if (OpenCL_FOUND)
				eth_use(${TARGET} ${REQUIRED} Eth::ethash)
				target_include_directories(${TARGET} SYSTEM PUBLIC ${OpenCL_INCLUDE_DIRS})
				target_link_libraries(${TARGET} ${OpenCL_LIBRARIES})
				target_link_libraries(${TARGET} ${Eth_ETHASH-CL_LIBRARIES})
				target_compile_definitions(${TARGET} PUBLIC ETH_ETHASHCL)
				eth_copy_dlls(${TARGET} OpenCL_DLLS)
			elseif (${REQUIRED} STREQUAL "REQUIRED")
				message(FATAL_ERROR "OpenCL library was not found")
			endif()
		endif()
	endif()

	if (${SUBMODULE} STREQUAL "ethcore")
		eth_use(${TARGET} ${REQUIRED} Dev::devcrypto Eth::ethash)
		# even if ethcore is required, ethash-cl and cpuid are optional
		eth_use(${TARGET} OPTIONAL Eth::ethash-cl Cpuid)
		target_link_libraries(${TARGET} ${Eth_ETHCORE_LIBRARIES})
	endif()

	if (${SUBMODULE} STREQUAL "evmcore")
		eth_use(${TARGET} ${REQUIRED} Dev::devcore)
		target_link_libraries(${TARGET} ${Eth_EVMCORE_LIBRARIES})
	endif()

	if (${SUBMODULE} STREQUAL "evmjit")
		# TODO: not sure if should use evmjit and/or evmjit-cpp
		# TODO: take into account REQUIRED variable
		if (EVMJIT)
			target_link_libraries(${TARGET} ${Eth_EVMJIT_LIBRARIES})
			target_link_libraries(${TARGET} ${Eth_EVMJIT-CPP_LIBRARIES})
			target_compile_definitions(${TARGET} PUBLIC ETH_EVMJIT)
		endif()
	endif()

	if (${SUBMODULE} STREQUAL "evm")
		eth_use(${TARGET} ${REQUIRED} Eth::ethcore Dev::devcrypto Eth::evmcore Dev::devcore)
		eth_use(${TARGET} OPTIONAL Eth::evmjit)
		target_link_libraries(${TARGET} ${Eth_EVM_LIBRARIES})
	endif()

	if (${SUBMODULE} STREQUAL "evmasm")
		eth_use(${TARGET} ${REQUIRED} Eth::evmcore)
		target_link_libraries(${TARGET} ${Eth_EVMASM_LIBRARIES})
	endif()

	if (${SUBMODULE} STREQUAL "lll")
		eth_use(${TARGET} ${REQUIRED} Eth::evmasm)
		target_link_libraries(${TARGET} ${Eth_LLL_LIBRARIES})
	endif()

	if (${SUBMODULE} STREQUAL "ethereum")
		eth_use(${TARGET} ${REQUIRED} Eth::evm Eth::lll Dev::p2p Dev::devcrypto Eth::ethcore JsonRpc::Server JsonRpc::Client)
		target_link_libraries(${TARGET} ${Boost_REGEX_LIBRARIES})
		target_link_libraries(${TARGET} ${Eth_ETHEREUM_LIBRARIES})
	endif()

	if (${SUBMODULE} STREQUAL "natspec")
		target_link_libraries(${TARGET} ${Eth_NATSPEC_LIBRARIES})
	endif()

	if (${SUBMODULE} STREQUAL "testutils")
		eth_use(${EXECUTABLE} ${REQUIRED} Eth::ethereum)
		target_link_libraries(${TARGET} ${Eth_TESTUTILS_LIBRARIES})
	endif()

endfunction()
