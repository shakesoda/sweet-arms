.data

/* test statuses */
output_str: .asciz "%s returned %d\n"
success:    .asciz "Test passed.\n"
failure:    .asciz "Test failed.\n"
allgood:    .asciz "Everything looks good (%d passed).\n"
allbad:     .asciz "Everything is awful (%d passed).\n"

/* function names */
_L_min: .asciz "min"
_L_max: .asciz "max"

.align 4
passed: .word 0

.text
.include "src/math.s"

.global main

/* r0: actual result
 * r1: function name
 * r2: expected result
 *
 * r3: add 1 for every passed test */
report:
	push  {r4, r5, lr}

	mov   r4, r1 /* name */
	mov   r5, r0 /* value */

	cmp   r2, r0
	ldreq r1, =passed
	ldreq r0, [r1]
	addeq r0, #1
	streq r0, [r1]

	ldrne r0, =failure
	ldreq r0, =success
	bl printf

	mov   r1, r4
	mov   r2, r5
	ldr   r0, =output_str
	bl printf

	pop   {r4, r5, pc}
main:
	push  {ip, lr}


	/* test min */
	mov   r0, #-5
	mov   r1, #5
	bl min

	ldr   r1, =_L_min
	mov   r2, #-5
	bl report

	/* test max */
	mov   r0, #50
	mov   r1, #11
	bl max

	ldr   r1, =_L_max
	mov   r2, #50
	bl report

	/* see if we passed them all */
	ldr   r0, =passed
	ldr   r1, [r0]
	cmp   r1, #2
	ldreq r0, =allgood
	ldrne r0, =allbad
	bl printf

	mov   r0, #0
	pop   {ip, pc}
