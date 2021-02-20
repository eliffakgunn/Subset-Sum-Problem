.data 
       arr:	.space 400 #MAX_SIZE = 100
       subset:	.space 400 #MAX_SIZE = 100
       arrSize:	.asciiz "Please enter the size of the array: "
       sum:	.asciiz "Please enter the target sum: "
       arrElm:	.asciiz "Please enter the elements of array:\n"
       pos:	.asciiz "Possible! "
       notPos:	.asciiz "Not Possible! "
       newline:	.asciiz "\n"
       space:	.asciiz " "
       subs:	.asciiz "Subset: "   
       
.text
              
main:
	#get array size from user
	li $v0, 4
	la $a0, arrSize
	syscall
	
	#cin >> arraySize;
	li $v0, 5
	syscall
	move $a1, $v0
	
	#get target sum from user
	li $v0, 4
	la $a0, sum
	syscall
	
	#cin >> num;
	li $v0, 5
	syscall
	move $a2, $v0
	
	#get elements of array from user
	li $v0, 4
	la $a0, arrElm
	syscall
		
	li $t0, 0 #i
	li $t1, 0 #dört artacak her seferinde
fillArr:
	beq  $t0, $a1, endFillArr
	
	#cin >> arr[i];			
	li $v0, 5
	syscall
	move $t3, $v0
	
	sw $t3, arr($t1)

	addi $t0, $t0, 1	
	addi $t1, $t1, 4
	j fillArr			
endFillArr:

	la $s0, 0 #int flag=0;
	la $s3, arr #int arr[20];
	la $s4, subset #int subset[20];
	
	li $t1, 0 #dört artacak her seferinde subseti doldurmak için
	li $t3, 0 #k=0
	
	#CheckSumPossibility(num, arr, arraySize);
	jal CheckSumPossibility 
		
	#returnVal = CheckSumPossibility(num, arr, arraySize); 
	move $t0, $v0
	
	#if(returnVal == 1)
	beq  $t0, 1, printPos
	
	#else
	li $v0, 4
	la $a0, notPos
	syscall
	
	li $v0, 10
	syscall	

printPos:
	li $v0, 4
	la $a0, pos
	syscall
	
	li $v0, 10
	syscall	
		
 CheckSumPossibility:
	li $t7, 0 #i
	
 	loop:
		addi $sp, $sp, -24
		sw $ra, 20($sp)
		sw $a1, 16($sp) #size(arraySize) 
		sw $a2, 12($sp) #sum(num)
		sw $t7, 8($sp) #i 		
 		sw $t3, 4($sp) #k
		sw $t1, 0($sp) #subsetin elemanlarý için
 		 	
 		#if(flag == 1) return 1;
 		beq $s0, 1, retFlag
 		#for (i = 0; i<arraySize; ++i)
 		slt $t8, $t7, $a1
 		beq  $t8, $zero, endLoop					
		
		#subset[k++] = arr[i]; 							
 		sll $t6, $t7, 2
 		add $t6, $s3, $t6 #arr[i] nin adresi
 		lw $t2, 0($t6) #t2 = arr[i]	

  		sll $t6, $t3, 2
 		add $t6, $s4, $t6 #subset[k] nin adresi
 		sw $t2, subset($t1)	
 		
 		addi $t3, $t3, 1 #k++
 		addi $t1, $t1, 4
 		
 		add $a1, $t7, $zero
 		
		sw $t7, 8($sp) #i 		
 		sw $t3, 4($sp) #k
		sw $t1, 0($sp) #subsetin indisleri için
 		
 		#CheckSumPossibility(num, arr, i); 
 		jal CheckSumPossibility
 		
 		lw $t1, 0($sp) #subsetin indisleri için
 		lw $t3, 4($sp) #k 
 		lw $t7, 8($sp) #i
 		lw $a2, 12($sp) #sum(num)
 		lw $a1, 16($sp) #size(arraySize) 
 		lw $ra, 20($sp)
 		addi $sp, $sp, 24		
 			 		
 		#sum = 0;
 		li $s2, 0 #toplam
 		
 		li $t4, 0 #j=0
 		li $t6, 0 #her seferinde 4 artacak
 		#for(j=0; j<k; ++j)
 		sumSubset:		
 			beq $t4, $t3, endSumSubset
  		
 			lw $t5, subset($t6) #subset[j] 		
 			add $s2, $s2, $t5 #sum += subset[j]
 			addi $t4, $t4, 1 #++j
 			addi $t6, $t6, 4						
 			
 			j sumSubset
 		endSumSubset:
 		
 		#if(sum == num)
 		beq $a2, $s2, retTrue #num == toplam ise	
 		
 		addi $t1, $t1, -4 #subsetin adresini azalttý
 		addi $t3, $t3, -1 #--k
 		addi $t7, $t7, 1 #++i	
	 		
 		j loop
 		
 		retTrue:
 			beq $s0, 0, printElms	
 			li $v0, 1
 			jr $ra
 		retFlag:
			li $v0, 1
 			addi $sp, $sp, 24
 			jr $ra 	
 															
 	endLoop:
	 	addi $sp, $sp, 24
 		li $v0, 0
 		jr $ra
 	
#for(j=0; j<k; ++j) cout<<subset[j]	
printElms:
	li $t6, 0
 	li $t8, 0
 			
	li   $v0, 4			
	la   $a0, subs
	syscall		
				 			
 	loopPrint:
 		beq $t6, $t3, endPrint
 		
 		lw $t9, subset($t8)
	 	
		li $v0, 1
		move $a0, $t9
		syscall	
				
		li   $v0, 4			
		la   $a0, space
		syscall	
				
		addi $t6, $t6, 1
		addi $t8, $t8, 4
							
		j loopPrint
				
		endPrint:
			li   $v0, 4			
			la   $a0, newline
			syscall				
				
 			li $s0, 1
 			li $v0, 1
				 				
 			jr $ra
 
