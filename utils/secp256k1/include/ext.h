/*
	This file is part of cpp-ethereum.

	cpp-ethereum is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	cpp-ethereum is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with cpp-ethereum.  If not, see <http://www.gnu.org/licenses/>.
*/
/** @file ext.h
 * Ethereum extensions to libecp256k1
 * @authors:
 *   Arkadiy Paronyan <i@gavwood.com>
 * @date 2014
 */

#ifndef _SECP256K1_EXT_
# define _SECP256K1_EXT__

# include "secp256k1.h"

# ifdef __cplusplus
extern "C" {
# endif

/** Compute a raw EC Diffie-Hellman secret in constant time
 *  Returns: 1: exponentiation was successful
 *           0: scalar was invalid (zero or overflow)
 *  Args:    ctx:      pointer to a context object (cannot be NULL)
 *  Out:     result:   a 32-byte array which will be populated by an ECDH
 *                     secret computed from the point and scalar
 *  In:      point:    pointer to a public point
 *           scalar:   a 32-byte scalar with which to multiply the point
 */
SECP256K1_API SECP256K1_WARN_UNUSED_RESULT int secp256k1_ecdh_raw(
  const secp256k1_context* ctx,
  unsigned char *result,
  const secp256k1_pubkey *point,
  const unsigned char *scalar
) SECP256K1_ARG_NONNULL(1) SECP256K1_ARG_NONNULL(2) SECP256K1_ARG_NONNULL(3) SECP256K1_ARG_NONNULL(4);

# ifdef __cplusplus
}
# endif

#endif
