/*
 * 2.5 compatibility
 * $Id: rbtree.h,v 1.1 2006/02/06 19:04:47 barf Exp $
 */

#ifndef __MTD_COMPAT_RBTREE_H__
#define __MTD_COMPAT_RBTREE_H__

#include <linux/version.h>

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,40)
#include_next <linux/rbtree.h>
#else
#define rb_node_s rb_node
#define rb_root_s rb_root

#include <linux/rbtree-24.h>

/* Find logical next and previous nodes in a tree */
extern struct rb_node *rb_next(struct rb_node *);
extern struct rb_node *rb_prev(struct rb_node *);
extern struct rb_node *rb_first(struct rb_root *);
#endif

#endif /*  __MTD_COMPAT_RBTREE_H__ */
