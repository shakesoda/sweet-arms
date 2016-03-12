.data

.text

/* C */
.extern exit
.extern printf

/* SDL */
.extern SDL_Init
.extern SDL_Quit
.extern SDL_SetVideoMode

.align 4
SDL_INIT_EVERYTHING: .int 0x0000FFFF

.global main

main:
	push  {ip, lr}

	/* initialize SDL... */
	ldr   r1, =SDL_INIT_EVERYTHING
	ldr   r0, [r1]
	bl SDL_Init

	/* let's make a window to play with!
	 * 640x480@32bpp */
	mov   r0, $640
	mov   r1, $480
	mov   r2, $32
	mov   r3, $0
	bl SDL_SetVideoMode
	cmp   r0, $0
	moveq r0, $-1
	beq exit
	
	/* clean up SDL */
	mov   r0, $0
	bl SDL_Quit

	/* exit with code 0 */
	mov   r0, $0
	pop   {ip, pc}
