.arch armv7-a

.data

.align 2
.comm screen, 4, 4
.equ SDL_INIT_EVERYTHING, 0x0000FFFF
.equ SDL_SWSURFACE,       0x00000000

.text

/* C */
.extern exit
.extern printf

/* SDL */
.extern SDL_Init
.extern SDL_Quit
.extern SDL_SetVideoMode
.extern SDL_UpdateRect

.type render, %function
render:
	push {lr}
	movw r0, #:lower16:screen
	movt r0, #:upper16:screen
	mov  r2, #0
	mov  r3, #640
	sub  sp, sp, #4
	mov  r1, #480
	str  r1, [sp]
	mov  r1, #0
	bl SDL_UpdateRect
	add  sp, sp, #4
	pop  {pc}

.global main
.type   main, %function
main:
	push  {ip, lr}

	/* initialize SDL... */
	/* SDL_INIT_EVERYTHING is only 16 bits */
	movw  r1, #:lower16:SDL_INIT_EVERYTHING
	bl SDL_Init

	/* let's make a window to play with!
	 * 640x480@32bpp */
	mov   r0, #640
	mov   r1, #480
	mov   r2, #32	
	movw  r3, #:lower16:SDL_SWSURFACE /* sure it's zero, but fuck it */
	bl SDL_SetVideoMode
	cmp   r0, #0
	moveq r0, #1
	bleq exit

	/* save screen */
	ldr   r1, =screen
        str   r0, [r1]

	sub  sp, sp, #32

	/* loop for a long time */
.gameloop:
	bl render

.event:
	ldrb r3, [sp, #12]
	cmp  r3, #12 /* confusingly, 12 is the quit event. */
	beq .done

	add r0, sp, #12
	bl SDL_PollEvent
	cmp r0, #0
	bne .event
	b .gameloop

.done:
	add   sp, sp, #32

	/* clean up SDL */
	mov   r0, #0
	bl SDL_Quit

	/* exit with code 0 */
	mov   r0, #0
	pop   {ip, pc}
