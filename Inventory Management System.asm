.model small 
.stack 100h

.data


   ; ------------------------ MAIN MENU HEADER -----------------------------
   msg db 'Wecome To Navenesh Inventory System $'
   menuPrompt db 13, '==== Wecome To Navenesh Inventory System ====',13,10, '========== INVENTORY SYSTEM ==========',13,10, '-------------- MAIN MENU -------------', 13, 10, 10 ,'1. View Inventory',13,10,'2. Restock Stock',13,10,'3. Supplying Stock',13,10,'0. Exit the Program',13,10, 13,10, 'Enter Input: ', '$'		
   Inventory db 13,10,13,10, '========== INVENTORY SYSTEM ==========',13,10, '-------------- MAIN MENU -------------', 13, 10,' ID',9,' Goods Name',9,' Price ',9,' Quantity' ,13,10,'$'
   menuChoice db ?
	menuPrompt3 db 13,10,'kekw','$'  
   
   ; ------------------------ INVENTORY HEADERS -----------------------------
   item1 db 0Ah, '1',9, 'Apple ',9,9, 'RM 6.00',9,9,'$'
   item2 db 0Ah, '2',9, 'Milk  ',9,9, 'RM 6.00',9,9,'$'
   item3 db 0Ah, '3',9, 'Orange',9,9, 'RM 6.00',9,9,'$'
   item4 db 0Ah, '4',9, 'Carrot',9,9, 'RM 6.00',9,9,'$'
   item5 db 0Ah, '5',9, 'Juice ',9,9, 'RM 6.00',9,9,'$'
   
   ; ------------------------ INVENTORY VALUE -----------------------------
    item1Value db '7$',0
	item2Value db '2$',0
	item3Value db '2$',0
	item4Value db '2$',0
	item5Value db '4$',0
	
	; ------------------------ ADD STOCK HEADERS -----------------------------
	addstockMessage db ,13,10, 'Choose ID between 1 to 5: $'
	addstockMessage2 db ,13,10, 'Choose Quantity To Add Between 1 to 9: $'
	addstockChoice db ?
	addstocMenukChoice db ?
	updatedstockChoice db ?
		
	; ------------------------ DEDUCT STOCK HEADERS -----------------------------
	deductstockMessage db ,13,10, 'Choose ID between 1 to 5: $'
	deductstockMessage2 db ,13,10, 'Choose Quantity To Deduct Between 1 to 9: $'
	deductstockChoice db ?
	deductstocMenukChoice db ?
	updatedostockChoice db ?
	
	
.code 

; ------------------------ MACRO -----------------------------
displayMsg MACRO msgToDisplay
mov ah,09h
mov dx,offset msgToDisplay
int 21h
Endm

DisplayMenu PROC
	displayMsg menuPrompt 
	mainInput:
		mov ah,01h
		int 21h 
		mov menuChoice,al
		
		cmp menuChoice, '1'
		je ViewInventory

		cmp menuChoice,'2'
		je AddingStock
		
		cmp menuChoice, '3'
		je DeductingStock

		cmp menuChoice,'0'
		je EndProgram
		
		ViewInventory:
			call viewinginventory		
			call BackToMenu
			
		AddingStock:
			call AddStock
				call BackToMenu
				
		DeductingStock:
			call DeductStock
				call BackToMenu
				
		EndProgram:
			call EndMenu
			
		jmp mainInput
		
	ret

DisplayMenu ENDP

EndMenu PROC
	mov ah,4ch
	int 21h 
	ret
EndMenu ENDP


; ------------------------VIEWING INVENTORY PROCEDURE -----------------------------
viewinginventory PROC 
	displayMsg Inventory
	
	displayMsg item1
	lea bx,item1Value
	call CheckGoodStock
	
	displayMsg item2
	lea bx,item2Value
	call CheckGoodStock
	
	displayMsg item3
	lea bx,item3Value
	call CheckGoodStock
	
	displayMsg item4
	lea bx,item4Value
	call CheckGoodStock
	
	displayMsg item5
	lea bx,item5Value
	call CheckGoodStock
	ret
	
	
CheckGoodStock:
	mov al,[bx]
	sub al,'0'
	cmp al,5
	jg printNormalGoods
	jmp PrintHighlightedGoods
	ret 
	
printNormalGoods:
	mov ah,09h
	mov dx,bx
	int 21h
	ret

PrintHighlightedGoods:
	mov ah,09
    mov al,[bx] 
    mov bh,0
	mov bl,158
	mov cx,1
	int 10h
	ret	
	
viewinginventory ENDP 

; ------------------------ADD STOCK PROCEDURE -----------------------------
AddStock PROC
    call viewinginventory  
	displayMsg addstockMessage 	; instructions - tell user what to do i.e. 1,2,3,4,5 (expected) - get id
	
	mov ah,01h					; character input function (read user input)
	int 21h 
	
	mov addstockChoice,al		; move the value from al to menuChoice 
		
	displayMsg addstockMessage2 ; instructions - tell user to input the Quantity amount to add
	
	mov ah,01h					; character input function (read user input)
	int 21h
	
	sub al, '0'
	mov ah, 0
	mov word ptr [updatedstockChoice], ax 
	
	
	cmp addstockChoice, '1'
	je ModifyItem1
	cmp addstockChoice, '2'
	je ModifyItem2
	cmp addstockChoice, '3'
	je ModifyItem3
	cmp addstockChoice, '4'
	je ModifyItem4
	cmp addstockChoice, '5'
	je ModifyItem5
	
	jmp AddStockEnd
	
	ModifyItem1:
		mov ax, word ptr [item1Value]
		mov bx, word ptr [updatedstockChoice] 		
		add ax,bx
		mov  word ptr [item1Value], ax	
		jmp AddStockEnd
	
	ModifyItem2:
		mov ax, word ptr [item2Value]
		mov bx, word ptr [updatedstockChoice] 		
		add ax,bx
		mov  word ptr [item2Value], ax	
		jmp AddStockEnd
		
	ModifyItem3:
		mov ax, word ptr [item3Value]
		mov bx, word ptr [updatedstockChoice] 		
		add ax,bx
		mov  word ptr [item3Value], ax	
		jmp AddStockEnd
	
	ModifyItem4:
		mov ax, word ptr [item4Value]
		mov bx, word ptr [updatedstockChoice] 		
		add ax,bx
		mov  word ptr [item4Value], ax	
		jmp AddStockEnd
	
	ModifyItem5:
		mov ax, word ptr [item5Value]
		mov bx, word ptr [updatedstockChoice] 		
		add ax,bx
		mov  word ptr [item5Value], ax	
		jmp AddStockEnd
		
AddStockEnd:
	call viewinginventory  ; Display updated inventory
	ret
	
	
	
AddStock ENDP


; ------------------------DEDUCT STOCK PROCEDURE -----------------------------
DeductStock PROC

    call viewinginventory  
	displayMsg deductstockMessage 	; instructions - tell user what to do i.e. 1,2,3,4,5 (expected) - get id
	
	mov ah,01h					; character input function (read user input)
	int 21h 
	
	mov deductstockChoice,al		; move the value from al to menuChoice 
		
	displayMsg deductstockMessage2 ; instructions - tell user to input the Quantity amount to add
	
	mov ah,01h					; character input function (read user input)
	int 21h
	
	sub al, '0'
	mov ah, 0
	mov word ptr [updatedostockChoice], ax 
	
	
	cmp deductstockChoice, '1'
	je DeductItem1
	cmp deductstockChoice, '2'
	je DeductItem2
	cmp deductstockChoice, '3'
	je DeductItem3
	cmp deductstockChoice, '4'
	je DeductItem4
	cmp deductstockChoice, '5'
	je DeductItem5
	
	jmp AddStockEnd
	
	DeductItem1:
		mov ax, word ptr [item1Value]
		mov bx, word ptr [updatedostockChoice] 		
		sub ax,bx
		mov  word ptr [item1Value], ax	
		jmp AddStockEnd
	
	DeductItem2:
		mov ax, word ptr [item2Value]
		mov bx, word ptr [updatedostockChoice] 		
		sub ax,bx
		mov  word ptr [item2Value], ax	
		jmp AddStockEnd
		
	DeductItem3:
		mov ax, word ptr [item3Value]
		mov bx, word ptr [updatedostockChoice]  		
		sub ax,bx
		mov  word ptr [item3Value], ax	
		jmp AddStockEnd
	
	DeductItem4:
		mov ax, word ptr [item4Value]
		mov bx, word ptr [updatedostockChoice]  		
		sub ax,bx
		mov  word ptr [item4Value], ax	
		jmp AddStockEnd
	
	DeductItem5:
		mov ax, word ptr [item5Value]
		mov bx, word ptr [updatedostockChoice] 		
		sub ax,bx
		mov  word ptr [item5Value], ax	
		jmp AddStockEnd
		
DeductStockEnd:
	call viewinginventory  ; Display updated inventory
	ret
	
	
DeductStock ENDP



BackToMenu PROC
	displayMsg menuPrompt3
	mov ah,01h
	int 21h
	
	mov menuChoice,al
	cmp menuChoice,'1'
	je BackToMenu1
	BackToMenu1:
		call DisplayMenu
		
	ret
BackToMenu ENDP

MAIN PROC

	mov ax,@data 
	mov ds,ax
	
	
	call DisplayMenu
	
MAIN ENDP 
END MAIN