/* NOTE: For functions which only push/pop one register, we push ip to
 * keep the stack aligned to 64-bits, per recommendation by ARM. */

/* min(x, y)
 * returns the lesser of r0, r1 */
.global min
.type min STT_FUNC
min:
	push  {ip, lr}
	cmp   r0, r1   /* if r1 is smaller, load into r0 */
	movgt r0, r1
	pop   {ip, pc}

/* max(x, y)
 * returns the greater of r0, r1 */
.global max
.type max STT_FUNC
max:
	push  {ip, lr}
	cmp   r0, r1   /* if r1 is bigger, load into r0 */
	movlt r0, r1
	pop   {ip, pc}
