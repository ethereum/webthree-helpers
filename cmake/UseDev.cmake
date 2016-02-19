function(eth_apply TARGET REQUIRED SUBMODULE)

	set(DEV_DIR "${ETH_CMAKE_DIR}/../../libweb3core" CACHE PATH "The path to dev libraries directory")
	set(DEV_BUILD_DIR_NAME "build" CACHE STRING "Dev build directory name")
	set(DEV_BUILD_DIR "${DEV_DIR}/${DEV_BUILD_DIR_NAME}")
	set(CMAKE_LIBRARY_PATH ${DEV_BUILD_DIR} ${CMAKE_LIBRARY_PATH})

	find_package(Dev)

	target_include_directories(${TARGET} BEFORE PUBLIC ${Dev_INCLUDE_DIRS})

	# Base is where all dependencies for devcore are
	if (${SUBMODULE} STREQUAL "base")
		# if it's ethereum source dir, always build BuildInfo.h before
		eth_use(${TARGET} ${REQUIRED} Dev::buildinfo Jsoncpp)
		if (NOT EMSCRIPTEN)
			eth_use(${TARGET} ${REQUIRED} DB::auto)
		endif()

		# Disable Boost auto-linking, where boost libraries are automatically
		# added to the link step for platforms which support that feature, which
		# in our case appears only to be for Windows.   Presumably this is
		# implemented using #pragma comment(lib ...)
		#
		# See https://support.microsoft.com/en-us/kb/153901.
		#
		# We don't want this automatic behavior, because it can add libraries
		# to the link step which we don't actually need or want, depending on
		# how cleanly #include dependencies have been managed, sometimes within
		# header files which we don't even author.  It is much better for us
		# just to manage these dependencies explicitly ourselves.
		#
		# See http://www.boost.org/doc/libs/1_40_0/more/getting_started/windows.html#auto-linking
		#
		add_definitions(-DBOOST_ALL_NO_LIB)

		# Add Boost include path unconditionally for all modules.
		target_include_directories(${TARGET} SYSTEM PUBLIC ${Boost_INCLUDE_DIRS})

		# NOTE - We are explicitly linking against four different Boost
		# libraries here unconditionally for every single module within the
		# Ethereum C++ codebase, with no consideration whatsoever for
		# the subset of Boost which any particular module is actually
		# using.   This pattern is particularly unwanted for Solidity,
		# which doesn't use Boost at all, but which gets the unwanted
		# heavy-weight dependency, and extra work for the linker.
		#
		# These dependencies should be moved up into the build files
		# for the modules as-and-where they are actually used.
		#
		target_link_libraries(${TARGET} ${Boost_THREAD_LIBRARIES})
		target_link_libraries(${TARGET} ${Boost_RANDOM_LIBRARIES})
		target_link_libraries(${TARGET} ${Boost_FILESYSTEM_LIBRARIES})
		target_link_libraries(${TARGET} ${Boost_SYSTEM_LIBRARIES})

		# NOTE - We are also explicitly linking pthread unconditionally
		# here for all modules on non-Windows platforms, whether or not
		# they actually use the threading functionality.
		#
		if (NOT DEFINED MSVC)
			target_link_libraries(${TARGET} pthread)
		endif()
	endif()

	if (${SUBMODULE} STREQUAL "devcore")
		eth_use(${TARGET} ${REQUIRED} Dev::base)
		target_link_libraries(${TARGET} ${Dev_DEVCORE_LIBRARIES})
	endif()

	if (${SUBMODULE} STREQUAL "devcrypto")
		eth_use(${TARGET} ${REQUIRED} Dev::devcore Utils::scrypt Cryptopp)
		if ((NOT EMSCRIPTEN) AND (NOT DEFINED MSVC))
			eth_use(${TARGET} ${REQUIRED} Utils::secp256k1)
		endif()

		target_link_libraries(${TARGET} ${Dev_DEVCRYPTO_LIBRARIES})
	endif()

	if (${SUBMODULE} STREQUAL "p2p")
		eth_use(${TARGET} ${REQUIRED} Dev::devcore Dev::devcrypto)
		eth_use(${TARGET} OPTIONAL Miniupnpc)
		target_link_libraries(${TARGET} ${Dev_P2P_LIBRARIES})
	endif()

endfunction()
