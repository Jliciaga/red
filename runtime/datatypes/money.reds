Red/System [
	Title:   "Money! datatype runtime functions"
	Author:  "Vladimir Vasilyev"
	File: 	 %money.reds
	Tabs:	 4
	Rights:  "Copyright (C) 2020 Red Foundation. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
		See https://github.com/red/red/blob/master/BSL-License.txt
	}
]

#define STUB [func [][--NOT_IMPLEMENTED--]]

money: context [
	verbose: 0
	
	#enum sizes! [
		SIZE_BYTES: 11
		SIZE_SCALE: 05
	]
	
	SIZE_DIGITS: SIZE_BYTES * 2
	
	;-- Support --
	
	see: func [
		money   [red-money!]
		return: [red-money!]
	][
		dump-memory get-amount money 1 1
		money
	]
	
	get-sign: func [
		money   [red-money!]
		return: [integer!]
	][
		money/header and 4000h >> 14
	]
		
	get-amount: func [
		money   [red-money!]
		return: [byte-ptr!]
	][
		(as byte-ptr! money) + (size? money) - SIZE_BYTES
	]

	zero-amount?: func [
		amount  [byte-ptr!]
		return: [logic!]
	][
		loop SIZE_BYTES [
			unless null-byte = amount/value [return no]
			amount: amount + 1
		]
		
		yes
	]

	make-at: func [
		slot	[red-value!]
		sign    [integer!]
		amount1 [integer!]
		amount2 [integer!]
		amount3 [integer!]
		return:	[red-money!]
		/local
			money [red-money!]
	][
		money: as red-money! slot
		money/header: TYPE_MONEY or (sign << 14)
		money/amount1: amount1
		money/amount2: amount2
		money/amount3: amount3
		money
	]
	
	make-in: func [
		parent  [red-block!]
		sign    [integer!]
		amount1 [integer!]
		amount2 [integer!]
		amount3 [integer!]
		return: [red-money!]
	][
		make-at ALLOC_TAIL(parent) sign amount1 amount2 amount3
	]
	
	push: func [
		sign    [integer!]
		amount1 [integer!]
		amount2 [integer!]
		amount3 [integer!]
		return: [red-money!]
	][
		make-at stack/push* sign amount1 amount2 amount3
	]
	
	;-- Natives --
	
	negative?: STUB
	zero?:     STUB
	positive?: STUB
	
	sign?: func [
		money   [red-money!]
		return: [integer!]
	][
		either zero-amount? get-amount money [0][
			either as logic! get-sign money [-1][+1]
		]
	]
	
	;-- Actions --

	make:      STUB
	to:        STUB

	form: func [
		money   [red-money!]
		buffer  [red-string!]
		arg     [red-value!]
		part    [integer!]
		return: [integer!]
		/local
			amount [byte-ptr!]
			sign   [integer!]
	][
		amount: get-amount money
		sign:   sign? money
		
		if sign < 0 [
			string/concatenate-literal buffer "-"
			part: part - 1
		]
		
		string/concatenate-literal buffer "$"
		
		loop SIZE_BYTES [
			string/concatenate-literal
				buffer
				string/byte-to-hex as integer! amount/value
				
			amount: amount + 1
		]
		
		part - SIZE_DIGITS - 1
	]
	
	mold: func [
		money   [red-money!]
		buffer  [red-string!]
		only?   [logic!]
		all?    [logic!]
		flat?   [logic!]
		arg     [red-value!]
		part    [integer!]
		indent  [integer!]		
		return: [integer!]
	][
		form money buffer arg part
	]
	
	random:    STUB
	
	compare:   STUB
	
	absolute:  STUB
	negate:    STUB
	
	add:       STUB
	subtract:  STUB
	multiply:  STUB
	divide:    STUB
	remainder: STUB
	
	round:     STUB
	
	even?:     STUB
	odd?:      STUB

	init: does [
		datatype/register [
			TYPE_MONEY
			TYPE_VALUE
			"money!"
			;-- General actions --
				null;:make
				null;:random
			null			;reflect
				null;:to
			:form
			:mold
			null			;eval-path
			null			;set-path
				null;:compare
			;-- Scalar actions --
				null;:absolute
				null;:add
				null;:divide
				null;:multiply
				null;:negate
			null			;power
				null;:remainder
				null;:round
				null;:subtract
				null;:even?
				null;:odd?
			;-- Bitwise actions --
			null			;and~
			null			;complement
			null			;or~
			null			;xor~
			;-- Series actions --
			null			;append
			null			;at
			null			;back
			null			;change
			null			;clear
			null			;copy
			null			;find
			null			;head
			null			;head?
			null			;index?
			null			;insert
			null			;length?
			null			;move
			null			;next
			null			;pick
			null			;poke
			null			;put
			null			;remove
			null			;reverse
			null			;select
			null			;sort
			null			;skip
			null			;swap
			null			;tail
			null			;tail?
			null			;take
			null			;trim
			;-- I/O actions --
			null			;create
			null			;close
			null			;delete
			null			;modify
			null			;open
			null			;open?
			null			;query
			null			;read
			null			;rename
			null			;update
			null			;write
		]
	]
]
