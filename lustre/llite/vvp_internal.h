/*
 * GPL HEADER START
 *
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 only,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License version 2 for more details (a copy is included
 * in the LICENSE file that accompanied this code).
 *
 * You should have received a copy of the GNU General Public License
 * version 2 along with this program; If not, see
 * http://www.sun.com/software/products/lustre/docs/GPLv2.pdf
 *
 * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
 * CA 95054 USA or visit www.sun.com if you need additional information or
 * have any questions.
 *
 * GPL HEADER END
 */
/*
 * Copyright (c) 2002, 2010, Oracle and/or its affiliates. All rights reserved.
 * Use is subject to license terms.
 *
 * Copyright (c) 2013, Intel Corporation.
 */
/*
 * This file is part of Lustre, http://www.lustre.org/
 * Lustre is a trademark of Sun Microsystems, Inc.
 *
 * Internal definitions for VVP layer.
 *
 *   Author: Nikita Danilov <nikita.danilov@sun.com>
 */

#ifndef VVP_INTERNAL_H
#define VVP_INTERNAL_H

#ifndef __KERNEL__
# error This file is kernel only.
#endif

#include <cl_object.h>
#include "llite_internal.h"

int vvp_io_init(const struct lu_env *env, struct cl_object *obj,
		struct cl_io *io);
int vvp_lock_init(const struct lu_env *env, struct cl_object *obj,
		  struct cl_lock *lock, const struct cl_io *io);
int vvp_page_init(const struct lu_env *env, struct cl_object *obj,
		  struct cl_page *page, pgoff_t index);
struct lu_object *vvp_object_alloc(const struct lu_env *env,
				   const struct lu_object_header *hdr,
				   struct lu_device *dev);
struct ccc_object *cl_inode2ccc(struct inode *inode);

extern struct kmem_cache *vvp_thread_kmem;

#endif /* VVP_INTERNAL_H */
