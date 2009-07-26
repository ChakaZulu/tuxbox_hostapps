/*
 * JFFS2 -- Journalling Flash File System, Version 2.
 *
 * Copyright (C) 2008 Nikos Mavrogiannopoulos.
 *
 * compr_lzma is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *               
 * compr_lzma is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *                               
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <stdint.h>
#include <stdio.h>
#include <asm/types.h>
#include <linux/jffs2.h>
#include "LzmaDec.h"
#include "LzmaEnc.h"
#include "compr.h"

#ifndef JFFS2_COMPR_LZMA
# define JFFS2_COMPR_LZMA 0x15
#endif

#define USERSPACE 1

#ifdef USERSPACE
static void* my_alloc( void* p, size_t size)
{
  return malloc(size);
}

static void my_free( void* p, void* addr)
{
  free(addr);
}

static void* my_bigalloc( void* p, size_t size)
{
  return malloc(size);
}

static void my_bigfree( void* p, void* addr)
{
  free(addr);
}
#else /* kernel space */

static void* my_alloc( void* p, size_t size)
{
  return kmalloc(size, GFP_KERNEL);
}

static void my_free( void* p, void* addr)
{
  kfree(addr);
}

static void* my_bigalloc( void* p, size_t size)
{
  return vmalloc(size);
}

static void my_bigfree( void* p, void* addr)
{
  vfree(addr);
}
#endif

const CLzmaEncProps lzma_props = {
  .level = 1, /* unused */
  .lc = 3,
  .lp = 0,
  .pb = 2,
  .algo = 1,
  .fb = 32,
  .btMode = 1,
  .mc = 32,
  .writeEndMark = 0,
  .numThreads = 1,
  .numHashBytes = 4,
  /* something more than this doesn't seem to offer anything
   * practical and increases memory size.
   */
  .dictSize = 1 << 13,
};

ISzAlloc xalloc = { my_alloc, my_free };
ISzAlloc xbigalloc = { my_bigalloc, my_bigfree };

int jffs2_lzma_compress(unsigned char *data_in, unsigned char *cpage_out,
		uint32_t *sourcelen, uint32_t *dstlen, void *model)
{
	int ret;
	size_t props_size = LZMA_PROPS_SIZE;
	size_t data_out_size = (*dstlen)-LZMA_PROPS_SIZE;

	if (*dstlen < LZMA_PROPS_SIZE)
		return -1;

        ret = LzmaEncode( cpage_out+LZMA_PROPS_SIZE, &data_out_size, 
        	data_in, *sourcelen, &lzma_props, 
        	cpage_out, &props_size, 0, NULL, &xalloc, &xbigalloc);
        	
	if (ret != SZ_OK)
		return -1;

	*dstlen = data_out_size + LZMA_PROPS_SIZE;
	
	return 0;
}

int jffs2_lzma_decompress(unsigned char *data_in, unsigned char *cpage_out,
		uint32_t srclen, uint32_t destlen, void *model)
{
	int ret;
	size_t data_out_size = destlen;
	size_t data_in_size = srclen - LZMA_PROPS_SIZE;
	ELzmaStatus status;
	
	if (srclen < LZMA_PROPS_SIZE)
		return -1;
	
	ret = LzmaDecode( cpage_out, &data_out_size, data_in+LZMA_PROPS_SIZE, &data_in_size, 
		data_in, LZMA_PROPS_SIZE, LZMA_FINISH_ANY, &status, &xalloc);
	
	if (ret != SZ_OK)
		return -1;

	return 0;
}

static struct jffs2_compressor jffs2_lzma_comp = {
	.priority = JFFS2_LZMA_PRIORITY,
	.name = "lzma",
	.disabled = 0,
	.compr = JFFS2_COMPR_LZMA,
	.compress = &jffs2_lzma_compress,
	.decompress = &jffs2_lzma_decompress,
};

int jffs2_lzma_init(void)
{
	return jffs2_register_compressor(&jffs2_lzma_comp);
}

void jffs2_lzma_exit(void)
{
	jffs2_unregister_compressor(&jffs2_lzma_comp);
}
